#!/usr/bin/env python3
"""
Batch process multiple drone videos to extract frames.
Supports parallel processing and various video formats.
"""

import argparse
import os
from pathlib import Path
from concurrent.futures import ProcessPoolExecutor, as_completed
import json
from datetime import datetime
from tqdm import tqdm
import cv2

def extract_frames(video_path, output_dir, fps=1, quality=95, format='jpg', start_time=0, end_time=None):
    """Extract frames from video - simplified version for batch processing."""
    from tqdm import tqdm
    
    video_path = Path(video_path)
    output_dir = Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)
    
    cap = cv2.VideoCapture(str(video_path))
    video_fps = cap.get(cv2.CAP_PROP_FPS)
    frame_count = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
    
    frame_interval = int(video_fps / fps) if fps > 0 else 1
    
    saved_count = 0
    frame_num = 0
    base_name = video_path.stem
    
    while True:
        ret, frame = cap.read()
        if not ret:
            break
        
        if frame_num % frame_interval == 0:
            timestamp_ms = int(cap.get(cv2.CAP_PROP_POS_MSEC))
            output_filename = f"{base_name}_frame_{saved_count:06d}_t{timestamp_ms}.{format}"
            output_path = output_dir / output_filename
            
            if format.lower() in ['jpg', 'jpeg']:
                cv2.imwrite(str(output_path), frame, [cv2.IMWRITE_JPEG_QUALITY, quality])
            else:
                cv2.imwrite(str(output_path), frame)
            
            saved_count += 1
        
        frame_num += 1
    
    cap.release()
    return saved_count

def process_single_video(video_path, output_base_dir, fps, quality, format):
    """Process a single video file."""
    try:
        video_name = video_path.stem
        output_dir = Path(output_base_dir) / video_name
        
        saved_count = extract_frames(
            video_path=video_path,
            output_dir=output_dir,
            fps=fps,
            quality=quality,
            format=format
        )
        
        return {
            'video': str(video_path),
            'status': 'success',
            'frames_extracted': saved_count,
            'output_dir': str(output_dir)
        }
    except Exception as e:
        return {
            'video': str(video_path),
            'status': 'error',
            'error': str(e)
        }

def find_video_files(input_dir, extensions=None):
    """Find all video files in directory."""
    if extensions is None:
        extensions = ['.mp4', '.avi', '.mov', '.MP4', '.AVI', '.MOV', '.mkv', '.MKV']
    
    input_path = Path(input_dir)
    video_files = []
    
    for ext in extensions:
        video_files.extend(input_path.glob(f'*{ext}'))
    
    return sorted(video_files)

def main():
    parser = argparse.ArgumentParser(
        description='Batch process multiple drone videos to extract frames',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Process all videos in a directory
  python batch-process.py --input-dir ./videos --output-dir ./frames
  
  # Process with 2 FPS extraction
  python batch-process.py --input-dir ./videos --output-dir ./frames --fps 2
  
  # Parallel processing with 4 workers
  python batch-process.py --input-dir ./videos --output-dir ./frames --workers 4
        """
    )
    
    parser.add_argument('--input-dir', '-i', required=True, help='Directory containing video files')
    parser.add_argument('--output-dir', '-o', required=True, help='Base output directory for frames')
    parser.add_argument('--fps', type=float, default=1.0, help='Frames per second to extract (default: 1)')
    parser.add_argument('--format', choices=['jpg', 'jpeg', 'png'], default='jpg', help='Output format (default: jpg)')
    parser.add_argument('--quality', type=int, default=95, help='JPEG quality 1-100 (default: 95)')
    parser.add_argument('--workers', type=int, default=1, help='Number of parallel workers (default: 1)')
    parser.add_argument('--extensions', nargs='+', help='Video file extensions to process (default: .mp4 .avi .mov)')
    
    args = parser.parse_args()
    
    # Validate input directory
    input_dir = Path(args.input_dir)
    if not input_dir.exists():
        print(f"❌ Error: Input directory not found: {input_dir}")
        return 1
    
    # Find video files
    print(f"\n🔍 Scanning for video files in: {input_dir}")
    video_files = find_video_files(input_dir, args.extensions)
    
    if not video_files:
        print(f"❌ No video files found in: {input_dir}")
        return 1
    
    print(f"✅ Found {len(video_files)} video file(s)")
    for vf in video_files:
        print(f"   • {vf.name}")
    
    # Create output directory
    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)
    
    # Process videos
    print(f"\n⚙️  Processing settings:")
    print(f"   FPS: {args.fps}")
    print(f"   Format: {args.format.upper()}")
    print(f"   Quality: {args.quality}")
    print(f"   Workers: {args.workers}")
    print()
    
    results = []
    
    if args.workers > 1:
        # Parallel processing
        print(f"🚀 Processing {len(video_files)} videos in parallel...")
        with ProcessPoolExecutor(max_workers=args.workers) as executor:
            futures = {
                executor.submit(
                    process_single_video,
                    video_path,
                    output_dir,
                    args.fps,
                    args.quality,
                    args.format
                ): video_path for video_path in video_files
            }
            
            for future in tqdm(as_completed(futures), total=len(futures), desc="Overall progress"):
                result = future.result()
                results.append(result)
    else:
        # Sequential processing
        print(f"⏳ Processing {len(video_files)} videos sequentially...")
        for video_path in video_files:
            result = process_single_video(
                video_path,
                output_dir,
                args.fps,
                args.quality,
                args.format
            )
            results.append(result)
    
    # Summary
    print(f"\n" + "="*50)
    print("📊 BATCH PROCESSING SUMMARY")
    print("="*50)
    
    successful = [r for r in results if r['status'] == 'success']
    failed = [r for r in results if r['status'] == 'error']
    
    print(f"\n✅ Successful: {len(successful)}/{len(results)}")
    for r in successful:
        print(f"   • {Path(r['video']).name}: {r['frames_extracted']} frames")
    
    if failed:
        print(f"\n❌ Failed: {len(failed)}/{len(results)}")
        for r in failed:
            print(f"   • {Path(r['video']).name}: {r['error']}")
    
    # Save summary
    summary_path = output_dir / f"batch_summary_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
    with open(summary_path, 'w') as f:
        json.dump({
            'timestamp': datetime.now().isoformat(),
            'settings': {
                'fps': args.fps,
                'format': args.format,
                'quality': args.quality,
                'workers': args.workers
            },
            'results': results
        }, f, indent=2)
    
    print(f"\n📄 Summary saved to: {summary_path}")
    print(f"📁 Output directory: {output_dir}")
    
    return 0 if len(failed) == 0 else 1

if __name__ == '__main__':
    exit(main())
