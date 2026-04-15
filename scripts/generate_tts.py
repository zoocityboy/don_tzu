#!/usr/bin/env python3
"""
Generate TTS audio files for The Art of Deal War quotes.

Usage:
    python scripts/generate_tts.py <language>
    python scripts/generate_tts.py --all

Example:
    python scripts/generate_tts.py en
    python scripts/generate_tts.py de
    python scripts/generate_tts.py --all
"""

import argparse
import asyncio
import json
from pathlib import Path

import edge_tts
from edge_tts.exceptions import NoAudioReceived


# Map language codes to edge-tts voice names
VOICE_MAP: dict[str, str] = {
    "en": "en-US-GuyNeural",
    "cs": "cs-CZ-AntoninNeural",
    "de": "de-DE-ConradNeural",
    "hu": "hu-HU-TamasNeural",
    "pl": "pl-PL-MarekNeural",
    "sk": "sk-SK-LukasNeural",
    "ja": "ja-JP-KeitaNeural",
    "zh": "zh-CN-YunxiNeural",
}

_DEFAULT_VOICE = "en-US-GuyNeural"
_MAX_CONCURRENT = 3


async def generate_audio(
    text: str, output_path: str, voice_name: str, semaphore: asyncio.Semaphore
) -> bool:
    """Generate a single audio file from text using edge-tts."""
    async with semaphore:
        try:
            communicate = edge_tts.Communicate(
                text, voice_name, rate="-10%", pitch="-20Hz"
            )
            await communicate.save(output_path)
            return True
        except NoAudioReceived as e:
            print(f"No audio received for {output_path}: {e}")
            return False
        except Exception as e:
            print(f"Error generating {output_path}: {e}")
            return False


async def generate_language(
    lang: str, data_dir: Path, output_dir: Path
) -> tuple[int, int]:
    """Generate all audio files for a language concurrently."""
    quotes_file = data_dir / lang / "quotes.json"

    if not quotes_file.exists():
        print(f"Quotes file not found: {quotes_file}")
        return 0, 0

    with open(quotes_file, "r", encoding="utf-8") as f:
        quotes = json.load(f)

    voice_name = VOICE_MAP.get(lang, _DEFAULT_VOICE)

    # Create output directory if it doesn't exist
    output_dir.mkdir(parents=True, exist_ok=True)

    semaphore = asyncio.Semaphore(_MAX_CONCURRENT)

    async def process(item: dict) -> bool | None:
        quote_id = item["id"]
        output_file = output_dir / f"{quote_id}.mp3"

        if output_file.exists():
            print(f"Skipping {quote_id}.mp3 (already exists)")
            return None  # skipped

        print(f"Generating {lang}/{quote_id}.mp3...")
        result = await generate_audio(item["quote"], str(output_file), voice_name, semaphore)
        if result:
            print(f"  ✓ Generated: {quote_id}.mp3")
        else:
            print(f"  ✗ Failed: {quote_id}.mp3")
        return result

    results = await asyncio.gather(*(process(item) for item in quotes))
    success_count = sum(1 for r in results if r is True)
    fail_count = sum(1 for r in results if r is False)
    return success_count, fail_count


async def main():
    parser = argparse.ArgumentParser(description="Generate TTS audio files for quotes")
    parser.add_argument(
        "language",
        nargs="?",
        help="Language code (e.g., en, de, hu). Required unless --all is set.",
    )
    parser.add_argument(
        "--all",
        action="store_true",
        help="Generate audio for all supported languages.",
    )
    parser.add_argument(
        "--data-dir",
        default="_data/lang",
        help="Data directory with quotes.json files",
    )
    parser.add_argument(
        "--output-dir", default="_data/tts", help="Output directory for audio files"
    )
    args = parser.parse_args()

    if not args.all and not args.language:
        parser.error("Provide a language code or use --all.")

    data_dir = Path(args.data_dir)
    base_output_dir = Path(args.output_dir)
    langs = list(VOICE_MAP.keys()) if args.all else [args.language]

    total_success = 0
    total_failed = 0

    for lang in langs:
        print(f"Generating TTS for language: {lang}")
        print(f"Output directory: {base_output_dir / lang}")
        print("---")

        success, failed = await generate_language(lang, data_dir, base_output_dir / lang)
        total_success += success
        total_failed += failed

        print("---")
        print(f"[{lang}] Generated: {success}, Failed: {failed}")
        print()

    if args.all:
        print(f"Total — Generated: {total_success}, Failed: {total_failed}")


if __name__ == "__main__":
    asyncio.run(main())
