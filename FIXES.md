# WebODM Setup - Fixed Issues

## Issue: Missing start scripts

**Problem**: `/webodm/start-webapp.sh: No such file or directory`

**Solution**: Changed from using `entrypoint` with custom scripts to using `command` with the correct startup commands:

- webapp uses `/webodm/start.sh`
- worker uses `/webodm/worker.sh start`

## Issue: Worker Command Error

**Problem**: `Unknown command: 'rqworker'` - The worker was trying to use Django's `rqworker` command which doesn't exist

**Solution**: Changed from `python manage.py rqworker default` to `/webodm/worker.sh start`. The worker.sh script properly starts Celery workers for background task processing.

## Issue: Database Configuration

**Problem**: WebODM requires specific database setup

**Solution**:

1. Changed from `postgres:14` to `postgis/postgis:14-3.3` (PostGIS with raster support)
2. Database name must be `webodm_dev`
3. PostGIS and PostGIS raster extensions must be enabled

## Final Working Configuration

The docker-compose.yml now correctly:

- Uses PostGIS-enabled PostgreSQL image
- Configures proper database name (`webodm_dev`)
- Uses correct startup commands
- Includes all necessary environment variables

## Manual Setup Steps (if starting fresh)

If you need to manually set up the database:

1. Create PostGIS extensions:

```bash
docker exec -it webodm-db psql -U postgres -d webodm_dev -c "CREATE EXTENSION IF NOT EXISTS postgis; CREATE EXTENSION IF NOT EXISTS postgis_raster;"
```

2. Run migrations:

```bash
docker exec -it webodm-webapp bash -c "python manage.py migrate"
```

3. Restart webapp:

```bash
docker-compose restart webapp
```

## Verification

### WebODM Webapp

WebODM is ready when you see this message in the webapp logs:

```text
Congratulations! ♪┏(・o･)┛♪
If there are no errors, WebODM should be up and running!
Open a web browser and navigate to http://0.0.0.0:8000
```

### Worker

Worker is running correctly when you see:

```text
Checking for celery... OK
Starting worker using broker at redis://broker:6379/0
```

## Container Status Check

```bash
docker-compose ps
```

All containers should show "Up" status:

- webodm-broker (Redis)
- webodm-db (PostGIS - healthy)
- webodm-webapp (WebODM interface)
- webodm-worker (Background task processor)
- webodm-node-odm-1 (Processing node)
- webodm-node-register (one-time registration - will show "Exited")

## Processing Node Registration

The NodeODM processing node is **automatically registered** on first startup via the `node-register` service. This service:

1. Waits for WebODM to be ready
2. Registers the NodeODM node at `node-odm-1:3000`
3. Exits after registration

### Manual Registration (if needed)

If you need to manually add a processing node:

```bash
docker exec -it webodm-webapp bash -c "python manage.py addnode <hostname> <port> --label '<Node Name>'"
```

Example:

```bash
docker exec -it webodm-webapp bash -c "python manage.py addnode node-odm-1 3000 --label 'NodeODM-1'"
```

### Verify Processing Nodes

After logging into WebODM:

1. Go to **Administration** → **Processing Nodes**
2. You should see "NodeODM-1" listed
3. Status should show as "online"

## Access

- **WebODM**: <http://localhost:8000>
- **NodeODM**: <http://localhost:3000>

## Issue 6: GPU Acceleration Setup

**Problem:**
NodeODM using CPU-only processing which is slower for large drone datasets.

**Error Symptoms:**
- Long processing times for photogrammetry tasks
- CPU at 100% utilization during processing
- No GPU utilization shown in nvidia-smi

**Solution:**

1. **Verified GPU availability:**
   ```powershell
   nvidia-smi
   ```
   Output confirmed:
   - GPU: NVIDIA GeForce RTX 4060
   - VRAM: 8GB
   - CUDA: 13.0
   - Driver: 581.80

2. **Modified docker-compose.yml for GPU support:**
   
   Changed node-odm-1 service:
   ```yaml
   node-odm-1:
     image: opendronemap/nodeodm:gpu  # Changed from :latest
     environment:
       - GPU_ENABLED=true  # Added
     deploy:
       resources:
         reservations:
           devices:
             - driver: nvidia
               count: 1
               capabilities: [gpu]
   ```

3. **Applied changes:**
   ```bash
   docker-compose down
   docker-compose pull node-odm-1
   docker-compose up -d
   ```

**Expected Performance Improvements:**
- 2-5x faster processing for typical datasets
- Better memory efficiency for large point clouds
- GPU utilization: 70-100% during active processing

**Verification:**
```bash
# Check GPU access in container
docker exec -it webodm-node-odm-1 nvidia-smi

# Monitor GPU usage during processing
nvidia-smi -l 2
```

**Documentation:**
See [GPU_SETUP.md](GPU_SETUP.md) for complete GPU configuration guide.

---

**All systems operational! WebODM is ready for GPU-accelerated drone video processing.** 🚀

For usage instructions, see:
- [QUICKSTART.md](QUICKSTART.md) - Quick start guide
- [WORKFLOW.md](WORKFLOW.md) - Complete workflow
- [EXAMPLES.md](EXAMPLES.md) - Example commands
- [GPU_SETUP.md](GPU_SETUP.md) - GPU acceleration guide
