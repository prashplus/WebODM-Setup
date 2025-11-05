# Drone Video to 3D Model Workflow

Complete workflow from drone video capture to final 3D model/orthophoto using WebODM.

## Workflow Overview

```
1. Capture → 2. Extract Frames → 3. Quality Check → 4. Upload → 5. Process → 6. Export
```

---

## Step 1: Drone Video Capture

### Flight Planning

**Grid Pattern** (Recommended for orthophotos):
- Fly in parallel lines
- 70-80% front overlap
- 60-70% side overlap
- Maintain consistent altitude
- Use double grid for 3D (perpendicular passes)

**Circular Pattern** (For 3D models):
- Circle around subject
- Multiple altitudes
- Oblique angles (45-60°)
- Overlap: 70-80%

### Camera Settings

- **Format**: H.264/H.265 video
- **Resolution**: 4K (3840x2160) minimum
- **Frame Rate**: 30 FPS
- **Shutter Speed**: 1/60 or faster
- **ISO**: As low as possible (100-400)
- **White Balance**: Locked
- **Focus**: Locked on infinity

### Flight Tips

- ✅ Fly in good lighting (overcast is ideal)
- ✅ Avoid harsh shadows
- ✅ Maintain steady speed (2-5 m/s)
- ✅ Keep consistent altitude
- ❌ Avoid wind if possible
- ❌ Don't fly in rain or fog
- ❌ Avoid moving objects

---

## Step 2: Extract Frames

### Choose Frame Rate

**For Orthophotos (2D maps)**:
- Slow flight (2-3 m/s): 0.5-1 FPS
- Normal flight (4-5 m/s): 1-2 FPS
- Fast flight (6+ m/s): 2-3 FPS

**For 3D Models**:
- Stationary subject: 1-2 FPS
- Moving around subject: 2-3 FPS

### Extract Frames

**Single Video**:
```bash
# Windows
python scripts\extract-frames.py --input DJI_0001.MP4 --output .\frames\project1 --fps 1 --quality 95

# Linux/macOS
python scripts/extract-frames.py --input DJI_0001.MP4 --output ./frames/project1 --fps 1 --quality 95
```

**Multiple Videos** (batch):
```bash
# Windows
python scripts\batch-process.py --input-dir .\videos --output-dir .\frames --fps 1

# Linux/macOS
python scripts/batch-process.py --input-dir ./videos --output-dir ./frames --fps 1
```

### Expected Results

For a 5-minute video at 1 FPS: ~300 images

---

## Step 3: Quality Check

### Check Frame Quality

1. **Open random frames** - verify sharpness
2. **Check overlap** - ensure consecutive frames overlap
3. **Look for blur** - discard any blurry frames
4. **Verify coverage** - no gaps in coverage

### Remove Bad Frames

Delete frames that are:
- Blurry or out of focus
- Overexposed or underexposed
- Showing only sky or water
- Duplicates or similar

**Recommended**: Keep 200-500 frames for most projects

---

## Step 4: Upload to WebODM

### Start WebODM

```bash
# Windows
.\scripts\start-webodm.ps1

# Linux/macOS
./scripts/start-webodm.sh
```

### Create Project

1. Open browser: http://localhost:8000
2. Login (or create account)
3. Click "Add Project"
4. Enter:
   - **Name**: Descriptive name (e.g., "Farm Field Survey 2024-11-05")
   - **Description**: Details about the project
5. Click "Create Project"

### Upload Images

1. Click "Select Images and GCP"
2. Select all frames from Step 2
3. Wait for upload (may take several minutes)
4. Verify image count

---

## Step 5: Process

### Choose Processing Preset

**Fast** (10-30 minutes):
- For quick preview
- Check data quality
- Verify coverage

**Default** (1-2 hours):
- Good quality results
- Most projects
- Balanced speed/quality

**High Quality** (3-6 hours):
- Important projects
- Detailed 3D models
- Professional deliverables

**Ultra** (6-12+ hours):
- Maximum detail
- Large scale prints
- Heritage documentation

### Configure Options

**For Orthophotos**:
- Use GPS
- DEM: Yes
- Orthophoto: Yes
- 3D Model: Optional

**For 3D Models**:
- Use GPS
- DEM: Optional
- 3D Model: Yes
- Texturing: Yes
- Point Cloud: Yes

### Start Processing

1. Select preset or custom options
2. Click "Start Processing"
3. Monitor progress
4. Check logs if errors occur

### Processing Time Examples

200 images at 20MP each:

| Hardware | Fast | Default | High Quality |
|----------|------|---------|--------------|
| 4C/8GB   | 30m  | 3h      | 8h           |
| 8C/16GB  | 15m  | 1.5h    | 4h           |
| 16C/32GB | 10m  | 1h      | 2.5h         |

---

## Step 6: Export Results

### Available Outputs

After processing completes, you can download:

**Orthophoto** (GeoTIFF):
- 2D map with geographic coordinates
- Import into GIS software
- Print as map

**3D Model** (OBJ/PLY/LAS):
- Textured 3D mesh
- View in MeshLab, Blender, etc.
- Use for measurements

**Point Cloud** (PLY/LAS):
- XYZ point data with colors
- Use in CloudCompare
- Further processing

**Digital Elevation Model** (GeoTIFF):
- Height information
- Terrain analysis
- Contour generation

**Contours** (GeoJSON):
- Elevation contours
- Import into CAD/GIS

### Download

1. Click on completed task
2. Click "Download Assets"
3. Select desired formats
4. Save to your computer

---

## Common Workflows

### Agriculture Mapping

1. **Capture**: Grid pattern, 100m altitude
2. **Extract**: 0.5 FPS
3. **Process**: Default preset, enable DEM and Orthophoto
4. **Export**: Orthophoto (GeoTIFF) for NDVI analysis

### Construction Site Survey

1. **Capture**: Grid pattern, 50m altitude
2. **Extract**: 1 FPS
3. **Process**: High Quality preset, enable DEM
4. **Export**: DEM and Orthophoto for volume calculations

### Building/Monument 3D Model

1. **Capture**: Circular pattern, multiple altitudes, oblique angles
2. **Extract**: 2 FPS
3. **Process**: High Quality preset, enable 3D model
4. **Export**: 3D model (OBJ) and point cloud

### Infrastructure Inspection

1. **Capture**: Focused on structure, multiple angles
2. **Extract**: 1-2 FPS
3. **Process**: High Quality, 3D model with high texture
4. **Export**: 3D model for detailed inspection

---

## Troubleshooting

### Not Enough Overlap
**Problem**: Processing fails or poor results
**Solution**: 
- Extract more frames (increase FPS)
- Re-fly with more overlap

### Out of Memory
**Problem**: Processing crashes
**Solution**:
- Use Fast preset
- Process fewer images
- Increase Docker memory
- Split into multiple projects

### Poor Quality Results
**Problem**: Blurry or distorted output
**Solution**:
- Check input image quality
- Remove blurry frames
- Use higher quality preset
- Ensure good lighting in capture

### GPS Errors
**Problem**: No georeferencing
**Solution**:
- Verify drone GPS was enabled
- Use ground control points (GCPs)
- Manual georeferencing in post

---

## Next Steps

After completing your first project:

1. **Experiment** with different presets
2. **Learn** about GCPs for accuracy
3. **Explore** advanced ODM options
4. **Integrate** with GIS software
5. **Join** OpenDroneMap community

## Resources

- [WebODM Documentation](https://docs.webodm.org/)
- [ODM Parameters](https://docs.opendronemap.org/arguments/)
- [Flight Planning Guide](https://docs.opendronemap.org/flying/)
- [Community Forum](https://community.opendronemap.org/)

---

Happy mapping! 🗺️✨
