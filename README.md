# FingerBeat

A rhythm game built for HarmonyOS. Tap the notes to the beat and aim for the highest score!

## Features

- **Rhythm Gameplay** - Classic falling-note rhythm game with 4-lane tap mechanics
- **Judgment System** - PERFECT / GREAT / GOOD / MISS grading with configurable timing windows
- **Score & Combo** - Weighted scoring with combo multipliers and letter grades (S/A/B/C/D)
- **Best Score Tracking** - Historical best scores persisted per song & difficulty, shown on result screen with new record indicator
- **Song Select** - Scrollable level list with global EASY / NORMAL / HARD difficulty selector
- **Practice Mode** - "牛刀小试" level with no BGM, pure tap practice
- **3 Built-in Songs** - Each with Easy, Normal, and Hard difficulties
- **Audio Engine** - BGM playback with SFX sound pool for hit/miss feedback
- **Persistent Scores** - Best scores and settings saved via HarmonyOS Preferences
- **i18n** - English and Chinese (Simplified) UI support
- **Dark Mode** - Full dark theme support
- **Responsive Layout** - Adaptive breakpoint system for phone, tablet, and 2-in-1 devices

## Architecture

Multi-module layered architecture following HarmonyOS best practices:

```
products/default (entry)     -- App shell, UI pages, resources
    ├── @ohos/game (HAR)     -- Game engine core
    └── @ohos/common (HAR)   -- Shared utilities

features/game (HAR)          -- Game logic, models, data, engine
    └── @ohos/common (HAR)

common (HAR)                 -- Logger, BreakpointSystem, constants
```

### Game Engine Subsystems

| Subsystem | File | Responsibility |
|-----------|------|----------------|
| GameEngine | `engine/GameEngine.ets` | Main loop controller, coordinates all subsystems, best score persistence |
| JudgeSystem | `engine/JudgeSystem.ets` | Timing-based judgment (PERFECT/GREAT/GOOD/MISS) |
| ScoreSystem | `engine/ScoreSystem.ets` | Score calculation, combo multiplier, letter grade |
| NoteScheduler | `engine/NoteScheduler.ets` | Note position updates, visibility, MISS detection |
| AudioPlayer | `engine/AudioPlayer.ets` | BGM (AVPlayer) + SFX (SoundPool) playback, optional BGM skip |
| GameEventBus | `engine/GameEventBus.ets` | Publish-subscribe event bus (singleton) |
| BeatmapRepository | `data/BeatmapRepository.ets` | Beatmap data management (3 songs x 3 difficulties) |
| ScoreStore | `data/ScoreStore.ets` | Score persistence via Preferences |
| SettingsStore | `data/SettingsStore.ets` | Settings persistence via Preferences |

> **Note**: `BeatmapEditor` and `MultiplayerService` are stub implementations reserved for v1.4+.

## Tech Stack

| Item | Detail |
|------|--------|
| Platform | HarmonyOS |
| Language | ArkTS (ETS) |
| SDK | 6.0.2(22) |
| Build | Hvigor |
| Package Manager | OHPM |
| Module Model | Stage Model |
| Test Framework | @ohos/hypium 1.0.25, @ohos/hamock 1.0.0 |
| Lint | @performance/recommended + @typescript-eslint/recommended |

## Project Structure

```
FingerBeat/
├── AppScope/                    # App-level config and resources
├── common/                      # @ohos/common HAR module
│   └── src/main/ets/
│       ├── constants/           # CommonConstants
│       └── utils/               # Logger, BreakpointSystem
├── features/
│   └── game/                    # @ohos/game HAR module
│       └── src/main/ets/
│           ├── constants/       # GameConstants
│           ├── data/            # BeatmapRepository, ScoreStore, SettingsStore, beatmaps/
│           ├── engine/          # GameEngine, JudgeSystem, ScoreSystem, NoteScheduler, AudioPlayer, ...
│           └── model/           # GameTypes (enums, interfaces)
├── products/
│   └── default/                 # Entry module
│       └── src/main/
│           ├── ets/             # UIAbility, pages (Index, SongSelectPage, GamePage)
│           └── resources/       # i18n (en_US, zh_CN), dark mode, rawfile (audio)
├── screenshots/                 # App screenshots
├── build-profile.json5          # Build configuration
├── oh-package.json5             # Package manifest
└── code-linter.json5            # Lint rules
```

## Pages

| Page | Route | Description |
|------|-------|-------------|
| Index | `pages/Index` | Main menu with app title and "开始击打！" button |
| SongSelectPage | `pages/SongSelectPage` | Scrollable level list with EASY/NORMAL/HARD difficulty selector and back arrow |
| GamePage | `pages/GamePage` | Game play page with Canvas rendering, HUD overlay, and result screen |

### Level List

| # | Name | Song | BGM | Description |
|---|------|------|-----|-------------|
| 0 | 牛刀小试 | song1 | No | BPM 95, pure tap practice, no background music |
| 1 | 星空旋律 | song1 | Yes | BPM 120, 30s |
| 2 | 电子脉冲 | song2 | Yes | BPM 140, 25s |
| 3 | 梦幻节拍 | song3 | Yes | BPM 100, 35s |

## Getting Started

### Prerequisites

- [DevEco Studio](https://developer.huawei.com/consumer/cn/deveco-studio/) 5.0+
- HarmonyOS SDK 6.0.2(22) or later
- OHPM (bundled with DevEco Studio)

### Build & Run

1. Clone the repository
2. Open the project in DevEco Studio
3. Wait for OHPM to install dependencies
4. Connect a HarmonyOS device or start an emulator
5. Click **Run** or use `hvigorw assembleHap`

### Run Tests

```bash
hvigorw testLocalUnit
hvigorw testOhosTest
```

## Game Constants

| Parameter | Easy | Normal | Hard |
|-----------|------|--------|------|
| PERFECT window | 50ms | 40ms | 30ms |
| GREAT window | 100ms | 80ms | 60ms |
| GOOD window | 150ms | 120ms | 100ms |
| Speed multiplier | 0.8x | 1.0x | 1.2x |

**Score weights**: PERFECT=300, GREAT=200, GOOD=100, MISS=0

**Combo multipliers**: 4+ combo = 1.1x, 8+ = 1.2x, 16+ = 1.3x, 32+ = 1.4x, 64+ = 1.5x

**Letter grades**: S >= 95%, A >= 85%, B >= 70%, C >= 50%, D < 50%

## Roadmap

- [ ] Beatmap Editor (v1.4+)
- [ ] Multiplayer mode (v1.4+)
- [ ] Custom song import
- [ ] More built-in songs

## License

Apache-2.0
