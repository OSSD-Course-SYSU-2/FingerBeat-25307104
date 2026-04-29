# Changelog

All notable changes to FingerBeat will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.3.2] - 2026-04-29

### Added
- Light/dark appearance mode for non-game pages (home, song select) with persisted preference
- Light/dark chart color mode for game pages (gameplay, result) with persisted preference, independent from appearance mode
- `ThemeManager` singleton for appearance/chart color preference management and persistence
- `ColorScheme` constants: 4 color sets (DarkAppearanceColors, LightAppearanceColors, DarkChartColors, LightChartColors)
- `GearIconButton` component (gearshape SVG icon) on home page and song select page (top-right corner)
- `SettingsDialog` component (centered rounded-rect popup with semi-transparent overlay, × close button)
- `RadioOption` component inside SettingsDialog (radio dot + label, blue dot when selected, bold text when selected)
- Settings dialog with two labels: "外观模式"/"Appearance" and "谱面颜色"/"Chart Color", each with dark/light options
- Eye-friendly light appearance palette: #EDEDED background, #1A1A2E primary text, #D4A800 accent
- Light chart palette: #F0F0F0 background, #1A1A2E text, softer note colors for readability
- Light mode difficulty colors: Easy=#2E8B57 (sea green), Normal=#C8960A (dark gold), Hard=#FF4500 (unchanged)
- `onPageShow()` lifecycle on Index and SongSelectPage to sync theme state across page navigations
- gearshape.svg resource in media assets

### Changed
- Result overlay now uses chart color mode for text/background and appearance mode for button color (dark chart → blue button, light chart → gold button)
- Game page Canvas rendering now uses chart color scheme (background, lane lines, judgment line, notes, HUD)
- Countdown overlay background changed from #80000000 (black 50%) to #80808080 (gray 128,128,128 50%)
- Countdown now renders static background (track lines + judgment line) behind the semi-transparent overlay
- Pause/Resume button width changed to padding-based auto-sizing for full text display
- Home page "Ready to Beat" button: dark mode → blue (#007DFF) background, light mode → gold (#D4A800) background
- LanguageSwitchButton now accepts `textColor` prop for appearance-aware coloring
- Architecture section updated: `@ohos/common` now exports ThemeManager, ColorScheme, and color constants
- .gitignore: added `/.preview`
- .codeartsdoer: added DISCLAIMER.md; renamed v1_3_refactor → v1_3_0refactor

### Fixed
- Accuracy display in ResultOverlay: removed double percentage conversion (was `accuracy * 100`, now `accuracy.toFixed(1)`)
- Settings dialog radio options now update reactively on selection (replaced @Builder with independent @Component RadioOption)
- Settings dialog appearance/chart colors update in real-time when switching modes (using @Link binding)
- Page appearance mode sync: returning from song select to home page now reflects appearance changes via onPageShow()
- v1.3.0 spec/design/tasks documents corrected: combo multiplier thresholds fixed from (10/30/50) to (4/8/16/32/64)

## [1.3.1] - 2026-04-27

### Added
- Runtime language switching between Simplified Chinese and English via `LanguageManager` singleton
- `LanguageSwitchButton` component (rounded rect, transparent fill, text color matches border)
- 3-second countdown overlay (3→2→1→BEAT) before game start with touch/interaction blocking
- `ResultOverlay` component extracted from GamePage with full i18n support
- 15+ i18n entries across zh_CN, en_US, and base string resources
- `LanguageManager` with built-in translation map, Preferences persistence, system locale detection, and fallback to Chinese for unsupported languages
- Countdown cancellation on back key press with proper cleanup
- Pause button i18n during gameplay

### Changed
- Index page: dark background (#0D0D1A), white text (#FFFFFF), language switch button, i18n for all text
- SongSelectPage: level title, difficulty, and description now use i18n via `t()` helper
- GamePage: countdown logic inlined (3→2→1→BEAT), ResultOverlay integration, interaction blocking during countdown
- "开始击打！" English translation: "Ready to Beat" (Title Case, no exclamation mark)
- "开始演奏！" English translation: "Beat It Yourself"
- Start button text i18n-aware

### Fixed
- `resourceManager.updateOverrideConfiguration()` does not trigger `$r()` refresh at runtime — switched to built-in translation map approach
- UI not re-rendering on language switch — `t()` helper now depends on `this.currentLang` to stay in ArkUI state tracking
- Build errors: 5 API compatibility fixes

## [1.3.0] - 2026-04-26

### Added
- Game engine core with main loop controller (`GameEngine`)
- Judgment system with PERFECT/GREAT/GOOD/MISS grading (`JudgeSystem`)
- Score system with combo multipliers and letter grades S/A/B/C/D (`ScoreSystem`)
- Note scheduler for position updates, visibility, and MISS detection (`NoteScheduler`)
- Audio player with BGM (AVPlayer) and SFX support (`AudioPlayer`)
- Event bus for publish-subscribe communication (`GameEventBus`)
- Beatmap repository with 4 built-in songs x 3 difficulties (`BeatmapRepository`)
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
- Practice level "牛刀小试" (level 0, song0) with no BGM, pure tap practice
- Best score tracking: historical best score persisted per song & difficulty
- New record indicator ("新纪录!") on result screen when best score is beaten
- Best score display on result screen
- MISS independent display: MISS shown above corresponding lane (max 2 concurrent), GOOD/GREAT/PERFECT centered
- Song0 (practice) beatmap with BPM 95, 15s duration
- Bilingual README (Chinese + English)

### Changed
- Start button text changed from "开始游戏" to "开始击打！"
- Start button now navigates to song select page instead of directly starting game
- Startup splash icon changed from `startIcon` to `foreground` (app icon)
- Combo multipliers revised: 4+→1.1x, 8+→1.2x, 16+→1.3x, 32+→1.4x, 64+→1.5x (was 10+→1.1x, 30+→1.2x, 50+→1.3x)
- `GameConfig` interface now includes `hasBGM` field to support BGM-less practice mode
- `GameUIUpdater.onGameEnd` signature extended with `bestScore` and `isNewRecord` parameters
- GameEngine now initializes ScoreStore and persists best scores on game end
- All levels set to no BGM mode (`hasBGM: false`)
- Level durations adjusted: Practice 15s, Starry Melody 20s, Electronic Pulse 25s, Dream Beat 35s
- Beatmaps regenerated with correct targetTime ranges matching level durations
- `NoteScheduler.checkMissedNotes` now returns lane info (`MissedNoteInfo`) instead of note IDs only
- GameEngine passes correct lane value for MISS judgments (was hardcoded -1)
- Level 0 now uses independent song0 beatmap (was sharing song1)

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
