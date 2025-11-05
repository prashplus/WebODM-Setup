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

## Access

- **WebODM**: <http://localhost:8000>
- **NodeODM**: <http://localhost:3000>
