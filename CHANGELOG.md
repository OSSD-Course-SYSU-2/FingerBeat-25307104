# Changelog

All notable changes to FingerBeat will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.3.0] - 2026-04-25

### Added
- Game engine core with main loop controller (`GameEngine`)
- Judgment system with PERFECT/GREAT/GOOD/MISS grading (`JudgeSystem`)
- Score system with combo multipliers and letter grades S/A/B/C/D (`ScoreSystem`)
- Note scheduler for position updates, visibility, and MISS detection (`NoteScheduler`)
- Audio player with BGM (AVPlayer) and SFX (SoundPool) support (`AudioPlayer`)
- Event bus for publish-subscribe communication (`GameEventBus`)
- Beatmap repository with 3 built-in songs x 3 difficulties (`BeatmapRepository`)
- Score persistence via HarmonyOS Preferences (`ScoreStore`)
- Settings persistence via HarmonyOS Preferences (`SettingsStore`)
- Complete type system with 9 enums and 15+ interfaces (`GameTypes`)
- Centralized game constants (`GameConstants`)
- Stub implementations for BeatmapEditor and MultiplayerService (v1.4+ reserved)
- i18n support (English and Simplified Chinese)
- Dark mode support
- Responsive breakpoint system for phone/tablet/2-in-1
- Code lint configuration with performance and security rules
- Song selection page (`SongSelectPage`) with scrollable level list and back navigation
- Global EASY / NORMAL / HARD difficulty selector on song select page
- Practice level "牛刀小试" (level 0) with no BGM, pure tap practice
- Best score tracking: historical best score persisted per song & difficulty
- New record indicator ("新纪录!") on result screen when best score is beaten
- Best score display on result screen

### Changed
- Start button text changed from "开始游戏" to "开始击打！"
- Start button now navigates to song select page instead of directly starting game
- Startup splash icon changed from `startIcon` to `foreground` (app icon)
- Combo multipliers revised: 4+→1.1x, 8+→1.2x, 16+→1.3x, 32+→1.4x, 64+→1.5x (was 10+→1.1x, 30+→1.2x, 50+→1.3x)
- `GameConfig` interface now includes `hasBGM` field to support BGM-less practice mode
- `GameUIUpdater.onGameEnd` signature extended with `bestScore` and `isNewRecord` parameters
- GameEngine now initializes ScoreStore and persists best scores on game end

## [1.2.0] - 2026-04-22

### Added
- Common utilities module (`@ohos/common`)
- Logger utility based on hilog
- Breakpoint system for responsive layout

## [1.1.0] - 2026-04-21

### Added
- Multi-module project structure (products/features/common)
- Entry module with UIAbility and page routing
- Basic test framework setup (@ohos/hypium, @ohos/hamock)

## [1.0.0] - 2026-04-20

### Added
- Initial project scaffold with HarmonyOS Stage Model
- DevEco Studio project configuration
