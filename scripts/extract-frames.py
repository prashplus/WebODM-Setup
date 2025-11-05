#!/usr/bin/env python3
"""
Extract frames from drone videos for photogrammetry processing.
Supports various video formats and can extract GPS metadata if available.
"""

import cv2
import os
import argparse
from pathlib import Path
from tqdm import tqdm
import json
from datetime import datetime

def extract_video_metadata(video_path):
    """Extract basic metadata from video file."""
    cap = cv2.VideoCapture(str(video_path))
    
    metadata = {
        'filename': video_path.name,
        'fps': cap.get(cv2.CAP_PROP_FPS),
        'frame_count': int(cap.get(cv2.CAP_PROP_FRAME_COUNT)),
        'width': int(cap.get(cv2.CAP_PROP_FRAME_WIDTH)),
        'height': int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT)),
        'duration_seconds': 0
    }
    
    if metadata['fps'] > 0:
        metadata['duration_seconds'] = metadata['frame_count'] / metadata['fps']
    
    cap.release()
    return metadata

def extract_frames(video_path, output_dir, fps=1, quality=95, format='jpg', start_time=0, end_time=None):
    """
    Extract frames from video at specified intervals.
    
    Args:
        video_path: Path to input video file
        output_dir: Directory to save extracted frames
        fps: Frames per second to extract (default: 1)
        quality: JPEG quality 1-100 (default: 95)
        format: Output format (jpg, png) (default: jpg)
        start_time: Start extraction at this time in seconds (default: 0)
        end_time: End extraction at this time in seconds (default: None - end of video)
    """
    
    video_path = Path(video_path)
    output_dir = Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)
    
    # Get video metadata
    print(f"\n📹 Processing: {video_path.name}")
    metadata = extract_video_metadata(video_path)
    print(f"   Resolution: {metadata['width']}x{metadata['height']}")
    print(f"   Duration: {metadata['duration_seconds']:.2f} seconds")
    print(f"   Original FPS: {metadata['fps']:.2f}")
    
    # Calculate frame interval
    video_fps = metadata['fps']
    frame_interval = int(video_fps / fps) if fps > 0 else 1
    
    # Calculate start and end frames
    start_frame = int(start_time * video_fps)
    end_frame = int(end_time * video_fps) if end_time else metadata['frame_count']
    
    print(f"\n⚙️  Extraction settings:")
    print(f"   Extract every {frame_interval} frames ({fps} FPS)")
    print(f"   Frame range: {start_frame} to {end_frame}")
    print(f"   Output format: {format.upper()}")
    print(f"   Quality: {quality}")
    
    # Open video
    cap = cv2.VideoCapture(str(video_path))
    
    # Set start position
    if start_frame > 0:
        cap.set(cv2.CAP_PROP_POS_FRAMES, start_frame)
    
    frame_count = 0
    saved_count = 0
    current_frame = start_frame
    
    # Create base filename
    base_name = video_path.stem
    
    # Progress bar
    total_frames_to_process = (end_frame - start_frame)
    pbar = tqdm(total=total_frames_to_process, desc="Extracting frames", unit="frames")
    
    while current_frame < end_frame:
        ret, frame = cap.read()
        if not ret:
            break
        
        # Save frame at specified interval
        if frame_count % frame_interval == 0:
            # Generate output filename
            timestamp_ms = int(cap.get(cv2.CAP_PROP_POS_MSEC))
            output_filename = f"{base_name}_frame_{saved_count:06d}_t{timestamp_ms}.{format}"
            output_path = output_dir / output_filename
            
            # Save frame
            if format.lower() == 'jpg' or format.lower() == 'jpeg':
                cv2.imwrite(str(output_path), frame, [cv2.IMWRITE_JPEG_QUALITY, quality])
            elif format.lower() == 'png':
                cv2.imwrite(str(output_path), frame, [cv2.IMWRITE_PNG_COMPRESSION, 9 - (quality // 11)])
            else:
                cv2.imwrite(str(output_path), frame)
            
            saved_count += 1
        
        frame_count += 1
        current_frame += 1
        pbar.update(1)
    
    pbar.close()
    cap.release()
    
    # Save metadata
    metadata['extraction_info'] = {
        'fps_extracted': fps,
        'frames_saved': saved_count,
        'output_format': format,
        'quality': quality,
        'start_time': start_time,
        'end_time': end_time
    }
    
    metadata_path = output_dir / f"{base_name}_metadata.json"
    with open(metadata_path, 'w') as f:
        json.dump(metadata, f, indent=2)
    
    print(f"\n✅ Extraction complete!")
    print(f"   Frames saved: {saved_count}")
    print(f"   Output directory: {output_dir}")
    print(f"   Metadata saved: {metadata_path}")
    
    return saved_count

def main():
    parser = argparse.ArgumentParser(
        description='Extract frames from drone videos for photogrammetry processing',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Extract 1 frame per second
  python extract-frames.py --input video.mp4 --output ./frames
  
  # Extract 2 frames per second in PNG format
  python extract-frames.py --input video.mp4 --output ./frames --fps 2 --format png
  
  # Extract from specific time range
  python extract-frames.py --input video.mp4 --output ./frames --start 10 --end 60
  
  # High quality extraction
  python extract-frames.py --input video.mp4 --output ./frames --fps 0.5 --quality 100
        """
    )
    
    parser.add_argument('--input', '-i', required=True, help='Input video file path')
    parser.add_argument('--output', '-o', required=True, help='Output directory for frames')
    parser.add_argument('--fps', type=float, default=1.0, help='Frames per second to extract (default: 1)')
    parser.add_argument('--format', choices=['jpg', 'jpeg', 'png'], default='jpg', help='Output format (default: jpg)')
    parser.add_argument('--quality', type=int, default=95, help='JPEG quality 1-100 (default: 95)')
    parser.add_argument('--start', type=float, default=0, help='Start time in seconds (default: 0)')
    parser.add_argument('--end', type=float, default=None, help='End time in seconds (default: end of video)')
    
    args = parser.parse_args()
    
    # Validate input file
    input_path = Path(args.input)
    if not input_path.exists():
        print(f"❌ Error: Input file not found: {input_path}")
        return 1
    
    # Extract frames
    try:
        extract_frames(
            video_path=input_path,
            output_dir=args.output,
            fps=args.fps,
            quality=args.quality,
            format=args.format,
            start_time=args.start,
            end_time=args.end
        )
        return 0
    except Exception as e:
        print(f"\n❌ Error during extraction: {e}")
        import traceback
        traceback.print_exc()
        return 1

if __name__ == '__main__':
    exit(main())
