# Example: Processing Configuration for Different Scenarios

This document provides recommended configurations for different drone mapping scenarios.

## Scenario 1: Quick Preview

**Use Case**: Fast preview of your data, checking coverage

**Settings**:

- Preset: Fast
- Feature Quality: Lowest
- Point Cloud Quality: Lowest
- Expected Time: 10-20 minutes for 100 images

**Frame Extraction**:

```bash
python scripts/extract-frames.py --input video.mp4 --output ./frames --fps 0.5 --quality 85
```

## Scenario 2: Standard Mapping

**Use Case**: General purpose mapping, good quality orthophotos

**Settings**:

- Preset: Default
- Feature Quality: Medium
- Point Cloud Quality: Medium
- DEM Resolution: 5cm
- Orthophoto Resolution: 5cm
- Expected Time: 1-2 hours for 100 images

**Frame Extraction**:

```bash
python scripts/extract-frames.py --input video.mp4 --output ./frames --fps 1 --quality 95
```

## Scenario 3: High Detail 3D Model

**Use Case**: Detailed 3D reconstruction, inspection, cultural heritage

**Settings**:

- Preset: High Quality
- Feature Quality: High
- Point Cloud Quality: High
- Min Features: 16000
- Matcher Neighbors: 12
- DEM Resolution: 2cm
- Expected Time: 3-6 hours for 100 images

**Frame Extraction**:

```bash
python scripts/extract-frames.py --input video.mp4 --output ./frames --fps 2 --quality 98 --format png
```

## Scenario 4: Large Area Mapping

**Use Case**: Agriculture, forestry, large construction sites

**Settings**:

- Preset: Default (or Fast for very large areas)
- Split Large Images: Yes
- Max Concurrency: 2-4 (depending on RAM)
- Tiles: Yes

**Frame Extraction**:

```bash
python scripts/batch-process.py --input-dir ./videos --output-dir ./frames --fps 0.5 --workers 2
```

## Scenario 5: Vertical Structure Inspection

**Use Case**: Building facades, towers, monuments

**Settings**:

- Preset: High Quality
- Camera Lens: Perspective (or Brown if significant distortion)
- Feature Quality: High
- Optimize Disk Space: No

**Frame Extraction**:

```bash
python scripts/extract-frames.py --input video.mp4 --output ./frames --fps 1.5 --quality 95
```

## Hardware Recommendations

### Minimum (Fast Preset)

- CPU: 4 cores
- RAM: 8GB
- Storage: 50GB SSD

### Recommended (Default/High Quality)

- CPU: 8+ cores
- RAM: 16GB+
- Storage: 100GB+ SSD
- GPU: Optional (not used by default)

### Professional (Ultra Quality)

- CPU: 16+ cores
- RAM: 32GB+
- Storage: 500GB+ NVMe SSD
- GPU: NVIDIA (for custom processing)

## Processing Time Estimates

Based on 100 images at 20MP:

| Preset       | Time    | CPU Usage | RAM Usage |
|--------------|---------|-----------|-----------|
| Fast         | 15-30m  | High      | 4-8GB     |
| Default      | 1-2h    | High      | 8-16GB    |
| High Quality | 3-6h    | High      | 16-24GB   |
| Ultra        | 6-12h+  | High      | 24-32GB+  |

*Times vary significantly based on hardware and image content*

## Tips for Optimization

1. **Start with Fast preset** to verify your data quality
2. **Use appropriate resolution** - higher isn't always better
3. **Monitor RAM usage** - if swapping, reduce quality or image count
4. **Process in batches** for very large datasets
5. **Enable tiles** for orthophotos larger than 10000x10000 pixels

## Custom Options

For advanced users, you can add custom options in WebODM:

```
--dem-resolution 2
--orthophoto-resolution 2
--pc-quality high
--feature-quality high
--matcher-neighbors 12
--min-num-features 16000
```

Refer to [ODM documentation](https://docs.opendronemap.org/arguments/) for all available options.
