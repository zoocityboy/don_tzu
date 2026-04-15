#!/usr/bin/env python3
"""
Generate TTS audio files for The Art of Deal War quotes.

Usage:
    python scripts/generate_tts.py <language>

Example:
    python scripts/generate_tts.py en
    python scripts/generate_tts.py de
"""

import argparse
import asyncio
import json
import os
from pathlib import Path

import edge_tts


# Map language codes to edge-tts voice presets
VOICE_MAP = {
    "en": {"name": "en-US-AriaNeural", "locale": "en-US"},
    "de": {"name": "de-DE-KatjaNeural", "locale": "de-DE"},
    "hu": {"name": "hu-HU-NoemiNeural", "locale": "hu-HU"},
    "pl": {"name": "pl-PL-AgnieszkaNeural", "locale": "pl-PL"},
    "sk": {"name": "sk-SK-LukasNeural", "locale": "sk-SK"},
    "ja": {"name": "ja-JP-NanamiNeural", "locale": "ja-JP"},
    "zh": {"name": "zh-CN-XiaoxiaoNeural", "locale": "zh-CN"},
}


async def generate_audio(text: str, output_path: str, voice_name: str) -> bool:
    """Generate audio file from text using edge-tts."""
    try:
        communicate = edge_tts.Communicate(
            text, voice_name, rate="-10%", pitch="-20Hz", volume="+0%"
        )
        await communicate.save(output_path)
        return True
    except Exception as e:
        print(f"Error generating {output_path}: {e}")
        return False


async def generate_language(
    lang: str, data_dir: Path, output_dir: Path
) -> tuple[int, int]:
    """Generate all audio files for a language."""
    quotes_file = data_dir / lang / "quotes.json"

    if not quotes_file.exists():
        print(f"Quotes file not found: {quotes_file}")
        return 0, 0

    with open(quotes_file, "r", encoding="utf-8") as f:
        quotes = json.load(f)

    voice = VOICE_MAP.get(lang, {"name": "en-US-AriaNeural", "locale": "en-US"})

    # Create output directory if it doesn't exist
    output_dir.mkdir(parents=True, exist_ok=True)

    success_count = 0
    fail_count = 0

    for item in quotes:
        quote_id = item["id"]
        text = item["quote"]
        output_file = output_dir / f"{quote_id}.mp3"

        # Skip if file already exists
        if output_file.exists():
            print(f"Skipping {quote_id}.mp3 (already exists)")
            continue

        print(f"Generating {lang}/{quote_id}.mp3...")

        if await generate_audio(text, str(output_file), voice["name"]):
            success_count += 1
            print(f"  ✓ Generated: {quote_id}.mp3")
        else:
            fail_count += 1
            print(f"  ✗ Failed: {quote_id}.mp3")

    return success_count, fail_count


async def main():
    parser = argparse.ArgumentParser(description="Generate TTS audio files for quotes")
    parser.add_argument("language", help="Language code (e.g., en, de, hu)")
    parser.add_argument(
        "--data-dir",
        default="assets/data",
        help="Data directory with quotes.json files",
    )
    parser.add_argument(
        "--output-dir", default="assets/tts", help="Output directory for audio files"
    )
    args = parser.parse_args()

    lang = args.language
    data_dir = Path(args.data_dir)
    output_dir = Path(args.output_dir) / lang

    print(f"Generating TTS for language: {lang}")
    print(f"Output directory: {output_dir}")
    print("---")

    success, failed = await generate_language(lang, data_dir, output_dir)

    print("---")
    print(f"Done! Generated: {success}, Failed: {failed}")


if __name__ == "__main__":
    asyncio.run(main())
