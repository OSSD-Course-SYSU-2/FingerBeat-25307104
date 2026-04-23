# Changelog

All notable changes to FingerBeat will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.3.0] - 2026-04-23

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
