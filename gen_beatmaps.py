"""
FingerBeat Beatmap Generator
=============================
Generates beatmap .ets files for all songs with note data.

Usage:
    python gen_beatmaps.py

This script overwrites the following files:
    features/game/src/main/ets/data/beatmaps/Song0Beatmaps.ets
    features/game/src/main/ets/data/beatmaps/Song1Beatmaps.ets
    features/game/src/main/ets/data/beatmaps/Song2Beatmaps.ets
    features/game/src/main/ets/data/beatmaps/Song3Beatmaps.ets

Note: Song1Info.ets is NOT overwritten (it only contains SongInfo, not beatmap data).
      Song1Info.ets duration should be manually kept in sync with the beatmap.
"""

import os

def gen_notes(start, end, interval, lane_pattern):
    """Generate note tuples (id, lane, targetTime) from start to end with given interval."""
    notes = []
    t = start
    i = 0
    while t <= end:
        lane = lane_pattern[i % len(lane_pattern)]
        notes.append((i, lane, t))
        t += interval
        i += 1
    return notes

def format_array(notes):
    """Format note tuples into ArkTS NoteData array entries."""
    lines = []
    for idx, lane, t in notes:
        lines.append("  { id: '%d', lane: %d, targetTime: %d, type: NoteType.TAP }," % (idx, lane, t))
    return '\n'.join(lines)

# Lane rotation patterns (4-lane)
LANE_0123 = [0, 1, 2, 3]
LANE_1203 = [1, 2, 0, 3]
LANE_2130 = [2, 1, 3, 0]

# Target durations per song (ms)
# Song0: BPM 95, 15s (practice)
# Song1: BPM 120, 20s
# Song2: BPM 140, 25s
# Song3: BPM 100, 35s

base = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                    'features', 'game', 'src', 'main', 'ets', 'data', 'beatmaps')

# === Song0: BPM 95, 15s ===
s0e = gen_notes(2000, 15000, 500, LANE_1203)
s0n = gen_notes(2000, 15000, 375, LANE_0123)
s0h = gen_notes(2000, 15000, 250, LANE_2130)

content = """import { SongInfo, Difficulty, SongSource, NoteData, NoteType } from '../../model/GameTypes';

export const SONG0_INFO: SongInfo = {
  id: 'song0',
  title: '\u725b\u5200\u5c0f\u8bd5',
  artist: 'FingerBeat',
  difficulties: [Difficulty.Easy, Difficulty.Normal, Difficulty.Hard],
  audioFilePath: 'bgm_song0.wav',
  coverImagePath: 'icon.png',
  duration: 15000,
  bpm: 95,
  source: SongSource.BUILTIN
};

export const SONG0_EASY: NoteData[] = [
"""
content += format_array(s0e) + '\n];\n\n'
content += 'export const SONG0_NORMAL: NoteData[] = [\n'
content += format_array(s0n) + '\n];\n\n'
content += 'export const SONG0_HARD: NoteData[] = [\n'
content += format_array(s0h) + '\n];\n'

with open(os.path.join(base, 'Song0Beatmaps.ets'), 'w', encoding='utf-8') as f:
    f.write(content)
print('Song0: Easy=%d Normal=%d Hard=%d (last targetTime=%d)' % (len(s0e), len(s0n), len(s0h), s0h[-1][2]))

# === Song1: BPM 120, 20s ===
s1e = gen_notes(2000, 20000, 500, LANE_1203)
s1n = gen_notes(2000, 20000, 375, LANE_0123)
s1h = gen_notes(2000, 20000, 250, LANE_2130)

content = """import { NoteData, NoteType } from '../../model/GameTypes';

export const SONG1_EASY: NoteData[] = [
"""
content += format_array(s1e) + '\n];\n\n'
content += 'export const SONG1_NORMAL: NoteData[] = [\n'
content += format_array(s1n) + '\n];\n\n'
content += 'export const SONG1_HARD: NoteData[] = [\n'
content += format_array(s1h) + '\n];\n'

with open(os.path.join(base, 'Song1Beatmaps.ets'), 'w', encoding='utf-8') as f:
    f.write(content)
print('Song1: Easy=%d Normal=%d Hard=%d (last targetTime=%d)' % (len(s1e), len(s1n), len(s1h), s1h[-1][2]))

# === Song2: BPM 140, 25s ===
s2e = gen_notes(1500, 25000, 500, LANE_0123)
s2n = gen_notes(1500, 25000, 375, LANE_1203)
s2h = gen_notes(1500, 25000, 250, LANE_2130)

content = """import { SongInfo, Difficulty, SongSource, NoteData, NoteType } from '../../model/GameTypes';

export const SONG2_INFO: SongInfo = {
  id: 'song2',
  title: '\u7535\u5b50\u8109\u51b2',
  artist: 'FingerBeat',
  difficulties: [Difficulty.Easy, Difficulty.Normal, Difficulty.Hard],
  audioFilePath: 'bgm_song2.wav',
  coverImagePath: 'icon.png',
  duration: 25000,
  bpm: 140,
  source: SongSource.BUILTIN
};

export const SONG2_EASY: NoteData[] = [
"""
content += format_array(s2e) + '\n];\n\n'
content += 'export const SONG2_NORMAL: NoteData[] = [\n'
content += format_array(s2n) + '\n];\n\n'
content += 'export const SONG2_HARD: NoteData[] = [\n'
content += format_array(s2h) + '\n];\n'

with open(os.path.join(base, 'Song2Beatmaps.ets'), 'w', encoding='utf-8') as f:
    f.write(content)
print('Song2: Easy=%d Normal=%d Hard=%d (last targetTime=%d)' % (len(s2e), len(s2n), len(s2h), s2h[-1][2]))

# === Song3: BPM 100, 35s ===
s3e = gen_notes(2500, 35000, 500, LANE_2130)
s3n = gen_notes(2500, 35000, 375, LANE_0123)
s3h = gen_notes(2500, 35000, 250, LANE_1203)

content = """import { SongInfo, Difficulty, SongSource, NoteData, NoteType } from '../../model/GameTypes';

export const SONG3_INFO: SongInfo = {
  id: 'song3',
  title: '\u68a6\u5e7b\u8282\u62cd',
  artist: 'FingerBeat',
  difficulties: [Difficulty.Easy, Difficulty.Normal, Difficulty.Hard],
  audioFilePath: 'bgm_song3.wav',
  coverImagePath: 'icon.png',
  duration: 35000,
  bpm: 100,
  source: SongSource.BUILTIN
};

export const SONG3_EASY: NoteData[] = [
"""
content += format_array(s3e) + '\n];\n\n'
content += 'export const SONG3_NORMAL: NoteData[] = [\n'
content += format_array(s3n) + '\n];\n\n'
content += 'export const SONG3_HARD: NoteData[] = [\n'
content += format_array(s3h) + '\n];\n'

with open(os.path.join(base, 'Song3Beatmaps.ets'), 'w', encoding='utf-8') as f:
    f.write(content)
print('Song3: Easy=%d Normal=%d Hard=%d (last targetTime=%d)' % (len(s3e), len(s3n), len(s3h), s3h[-1][2]))

print('\nAll beatmap files generated successfully!')
