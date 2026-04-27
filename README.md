# FingerBeat

---

## 中文

一款基于 HarmonyOS 的节奏游戏。跟随节拍点击音符，争取最高分！

### 功能特性

- **节奏玩法** — 经典下落式4轨道节奏游戏
- **判定系统** — PERFECT / GREAT / GOOD / MISS 四级判定，可配置时间窗口
- **分数与连击** — 加权计分，连击倍率
- **最高分记录** — 按曲目和难度持久化历史最高分，结算画面展示并标注新纪录
- **曲目选择** — 可滚动的关卡列表，全局 EASY / NORMAL / HARD 难度选择器
- **4个内置关卡** — 牛刀小试、星空旋律、电子脉冲、梦幻节拍，各含3种难度
- **MISS独立显示** — MISS在对应轨道上方独立显示（最多同时2个），GOOD/GREAT/PERFECT居中显示
- **无BGM模式** — 所有关卡均无背景音乐，纯击打体验
- **音频引擎** — BGM播放 + SFX音效反馈
- **双语国际化** — 中英双语界面实时切换，首页左上角语言切换按钮，语言偏好持久化
- **3秒倒计时** — 进入游戏前显示 3 → 2 → 1 → BEAT 倒计时动画
- **持久化存储** — 最高分和设置通过 HarmonyOS Preferences 保存
- **深色模式** — 全局深色主题
- **响应式布局** — 适配手机、平板和二合一设备

### 关卡列表

| # | 名称 | 曲目ID | BPM | 时长 | BGM | 说明 |
|---|------|--------|-----|------|-----|------|
| 0 | 牛刀小试 | song0 | 95 | 15s | 无 | 纯击打练习 |
| 1 | 星空旋律 | song1 | 120 | 20s | 无 | — |
| 2 | 电子脉冲 | song2 | 140 | 25s | 无 | — |
| 3 | 梦幻节拍 | song3 | 100 | 35s | 无 | — |

### 架构

采用 HarmonyOS 多模块分层架构：

```
products/default (entry)     -- 应用壳，UI页面，资源
    ├── @ohos/game (HAR)     -- 游戏引擎核心
    └── @ohos/common (HAR)   -- 共享工具、LanguageManager

features/game (HAR)          -- 游戏逻辑、模型、数据、引擎
    └── @ohos/common (HAR)

common (HAR)                 -- Logger、BreakpointSystem、LanguageManager、常量
```

#### 游戏引擎子系统

| 子系统 | 文件 | 职责 |
|--------|------|------|
| GameEngine | `engine/GameEngine.ets` | 主循环控制器，协调所有子系统，最高分持久化 |
| JudgeSystem | `engine/JudgeSystem.ets` | 基于时间的判定（PERFECT/GREAT/GOOD/MISS） |
| ScoreSystem | `engine/ScoreSystem.ets` | 分数计算、连击倍率 |
| NoteScheduler | `engine/NoteScheduler.ets` | 音符位置更新、可见性、MISS检测（含轨道信息） |
| AudioPlayer | `engine/AudioPlayer.ets` | BGM（AVPlayer）+ SFX 音效播放，可选跳过BGM（尚未实现） |
| GameEventBus | `engine/GameEventBus.ets` | 发布-订阅事件总线（单例） |
| BeatmapRepository | `data/BeatmapRepository.ets` | 谱面数据管理（4首曲目 × 3种难度） |
| ScoreStore | `data/ScoreStore.ets` | 通过 Preferences 持久化分数 |
| SettingsStore | `data/SettingsStore.ets` | 通过 Preferences 持久化设置 |
| LanguageManager | `utils/LanguageManager.ets` | 语言偏好管理、翻译词条、持久化 |
| BeatmapEditor | `engine/BeatmapEditor.ets` | 预留桩实现，计划在 v1.4+ 实现 |
| MultiplayerService | `engine/MultiplayerService.ets` | 预留桩实现，计划在 v1.4+ 实现 |

### 技术栈

| 项目 | 详情 |
|------|------|
| 平台 | HarmonyOS |
| 语言 | ArkTS (ETS) |
| SDK | 6.0.2(22) |
| 构建 | Hvigor |
| 包管理 | OHPM |
| 模块模型 | Stage Model |
| 测试框架 | @ohos/hypium 1.0.25, @ohos/hamock 1.0.0 |
| 代码检查 | @performance/recommended + @typescript-eslint/recommended |

### 项目结构

```
FingerBeat/
├── AppScope/                    # 应用级配置和资源
├── common/                      # @ohos/common HAR 模块
│   └── src/main/ets/
│       ├── constants/           # CommonConstants
│       └── utils/               # Logger, BreakpointSystem, LanguageManager
├── features/
│   └── game/                    # @ohos/game HAR 模块
│       └── src/main/ets/
│           ├── constants/       # GameConstants
│           ├── data/            # BeatmapRepository, ScoreStore, SettingsStore, beatmaps/
│           ├── engine/          # GameEngine, JudgeSystem, ScoreSystem, NoteScheduler, AudioPlayer, ...
│           └── model/           # GameTypes（枚举、接口）
├── products/
│   └── default/                 # 入口模块
│       └── src/main/
│           ├── ets/             # UIAbility, 页面, 组件
│           │   ├── pages/       # Index, SongSelectPage, GamePage
│           │   └── components/  # LanguageSwitchButton, CountdownOverlay, ResultOverlay
│           └── resources/       # i18n (en_US, zh_CN, base), 深色模式, rawfile (音频)
├── screenshots/                 # 应用截图
├── build-profile.json5          # 构建配置
├── oh-package.json5             # 包清单
└── code-linter.json5            # 代码检查规则
```

### 页面

| 页面 | 路由 | 描述 |
|------|------|------|
| Index | `pages/Index` | 主菜单，显示应用标题和"开始击打！"按钮，左上角语言切换 |
| SongSelectPage | `pages/SongSelectPage` | 曲目选择页，可滚动关卡列表 + EASY/NORMAL/HARD难度选择器 + 返回箭头 |
| GamePage | `pages/GamePage` | 游戏页面，3秒倒计时 + Canvas渲染 + HUD叠加层 + 结算画面 |

### 游戏常量

| 参数 | Easy | Normal | Hard |
|------|------|--------|------|
| PERFECT 窗口 | 50ms | 40ms | 30ms |
| GREAT 窗口 | 100ms | 80ms | 60ms |
| GOOD 窗口 | 150ms | 120ms | 100ms |
| 速度倍率 | 0.8x | 1.0x | 1.2x |

**分数权重**：PERFECT=300, GREAT=200, GOOD=100, MISS=0

**连击倍率**：4+连击=1.1x, 8+=1.2x, 16+=1.3x, 32+=1.4x, 64+=1.5x

### 判定显示

| 判定 | 显示位置 | 说明 |
|------|---------|------|
| PERFECT / GREAT / GOOD | 屏幕中上方居中 | 单个显示，新判定覆盖旧判定 |
| MISS | 对应轨道上方 | 最多同时显示2个，独立于其他判定 |

### 快速开始

#### 前置条件

- [DevEco Studio](https://developer.huawei.com/consumer/cn/deveco-studio/) 5.0+
- HarmonyOS SDK 6.0.2(22) 或更高版本
- OHPM（随 DevEco Studio 附带）

#### 构建与运行

1. 克隆仓库
2. 在 DevEco Studio 中打开项目
3. 等待 OHPM 安装依赖
4. 连接 HarmonyOS 设备或启动模拟器
5. 点击 **运行** 或使用 `hvigorw assembleHap`

#### 运行测试

```bash
hvigorw testLocalUnit
hvigorw testOhosTest
```

### 版本声明

**当前版本：v1.3.1** (2026-04-27)

**本次更新亮点：**
- 实现了中英双语界面实时切换（首页左上角语言切换按钮）
- 进入游戏前增加3秒倒计时动画（3 → 2 → 1 → BEAT）
- 首页背景统一为深色主题，结算页面全面支持双语显示

**项目当前核心能力：**
- 音符自动下落与实时判定系统（v1.3.0 起）
- 四级判定（PERFECT/GREAT/GOOD/MISS）与连击倍率（v1.3.0 起）
- 音符生成：基于 Python 脚本预生成的固定四循环谱面（脚本位于项目根目录 gen_beatmaps.py）
- 中英双语界面、3秒倒计时（v1.3.1 起）

**已知限制：**
- "开始演奏！"模式尚未完整实现（计划于 v1.6.x 完成）
- 暂不支持用户自定义谱面编辑
- 暂不支持背景音乐、击打音效、节拍识别

📜 完整版本历史请查看 [CHANGELOG.md](./CHANGELOG.md)

### 项目亮点："开始演奏！"模式设计（计划 v1.6.x 实现）

本模式的设计目标是让不会乐器的用户也能体验"自己演奏音乐"的效果。

**双模式设计：**
- **自动播放模式**：BGM 全程自动播放，用户跟随节拍击打
- **开始演奏！模式**（Beat It Yourself）：默认不自动播放 BGM；未踩中音符时音乐中断（BGM 音量归零，不暂停播放），踩中音符时音量淡入恢复——营造"由用户演奏出音乐"的体验

**技术要点（v1.6.x 计划）：**
- 未踩中音符块时，BGM 音量调为零（不暂停播放），踩中时恢复原音量
- 踩入瞬间音量淡入（fade-in），而非突然恢复
- 演奏模式下默认不开启击打音效，仅通过 BGM 音量变化提供反馈

**版权规避方案：**
- 提供 MP3 路径记忆选项，方便用户快速加载个人音乐文件
- 提供专门的存放目录用于存放用户 MP3 文件
- 通过"阻断交互"机制，界面要求用户保证所使用的 MP3 为合法途径取得、拥有合法复制权
- 技术中立原则：用户使用 MP3 的合法性由用户自行负责，与开发者无关

提供此模式亦旨在缓解学生群体因缺乏音乐版权而难以制作关卡的实际困难。

### 更新计划

**版本 1.4.x — 基础音频播放**

- 实现背景音乐播放功能：支持导入并播放本地 MP3 文件，提供播放、暂停、进度条控制。
- 实现击打音效播放功能：玩家点击音符时，通过低延迟方式播放短促音效（如"叮"）。

**版本 1.5.x — 音符生成优化 + 节拍识别 + 普通模式自动对齐**

- 优化音符生成逻辑：替换原有的 Python 脚本固定四循环方式，改为在游戏内根据 BPM 动态生成音符，使谱面更丰富多变。
- 实现节拍识别能力：对用户导入的 MP3 进行本地分析，检测 BPM 并提取节拍时间点数组。
- 将节拍识别结果应用于普通模式：实现音符与音乐节拍的自动对齐，让玩家在普通模式下也能获得精准的节奏体验。

**版本 1.6.x — "开始演奏！"模式完整版**

- 新增"开始演奏！"游戏接口：
  - 允许用户导入本地 MP3，手动输入 BPM 和时长（若节拍识别已实现，可自动填充推荐值）；若节拍识别未启用或用户选择不使用，则进入分离模式（音乐独立播放，音符按手动 BPM 生成，两者不同步）。
  - 提供"自动播放 BGM"开关：
    - 开启：音乐全程自动播放，不受玩家击打情况影响。
    - 关闭：当玩家未踩中音符块时，将 BGM 音量调为零（不暂停播放），踩中时恢复原音量。
- 集成节拍识别结果到演奏模式：实现音符与音乐节拍的自动对齐，完成完整节奏体验。

### 许可证

Apache-2.0

---

## English

A rhythm game built for HarmonyOS. Tap the notes to the beat and aim for the highest score!

### Features

- **Rhythm Gameplay** — Classic falling-note rhythm game with 4-lane tap mechanics
- **Judgment System** — PERFECT / GREAT / GOOD / MISS grading with configurable timing windows
- **Score & Combo** — Weighted scoring with combo multipliers
- **Best Score Tracking** — Historical best scores persisted per song & difficulty, shown on result screen with new record indicator
- **Song Select** — Scrollable level list with global EASY / NORMAL / HARD difficulty selector
- **4 Built-in Levels** — Warm Up, Starry Melody, Electro Pulse, Dream Beat, each with 3 difficulties
- **MISS Independent Display** — MISS shown above the corresponding lane (max 2 concurrent), GOOD/GREAT/PERFECT centered
- **No-BGM Mode** — All levels have no background music, pure tap experience
- **Audio Engine** — BGM playback with SFX sound pool for hit/miss feedback
- **Bilingual i18n** — Chinese/English real-time UI switching via LanguageManager, language preference persisted
- **3-Second Countdown** — Countdown overlay (3 → 2 → 1 → BEAT) before game starts
- **Persistent Storage** — Best scores and settings saved via HarmonyOS Preferences
- **Dark Mode** — Full dark theme support
- **Responsive Layout** — Adaptive breakpoint system for phone, tablet, and 2-in-1 devices

### Level List

| # | Name | Song ID | BPM | Duration | BGM | Notes |
|---|------|---------|-----|----------|-----|-------|
| 0 | Warm Up | song0 | 95 | 15s | No | Pure tap practice |
| 1 | Starry Melody | song1 | 120 | 20s | No | — |
| 2 | Electro Pulse | song2 | 140 | 25s | No | — |
| 3 | Dream Beat | song3 | 100 | 35s | No | — |

### Architecture

HarmonyOS multi-module layered architecture:

```
products/default (entry)     -- App shell, UI pages, resources
    ├── @ohos/game (HAR)     -- Game engine core
    └── @ohos/common (HAR)   -- Shared utilities, LanguageManager

features/game (HAR)          -- Game logic, models, data, engine
    └── @ohos/common (HAR)

common (HAR)                 -- Logger, BreakpointSystem, LanguageManager, constants
```

#### Game Engine Subsystems

| Subsystem | File | Responsibility |
|-----------|------|----------------|
| GameEngine | `engine/GameEngine.ets` | Main loop controller, coordinates all subsystems, best score persistence |
| JudgeSystem | `engine/JudgeSystem.ets` | Timing-based judgment (PERFECT/GREAT/GOOD/MISS) |
| ScoreSystem | `engine/ScoreSystem.ets` | Score calculation, combo multiplier |
| NoteScheduler | `engine/NoteScheduler.ets` | Note position updates, visibility, MISS detection (with lane info) |
| AudioPlayer | `engine/AudioPlayer.ets` | BGM (AVPlayer) + SFX playback, optional BGM skip (not yet implemented) |
| GameEventBus | `engine/GameEventBus.ets` | Publish-subscribe event bus (singleton) |
| BeatmapRepository | `data/BeatmapRepository.ets` | Beatmap data management (4 songs x 3 difficulties) |
| ScoreStore | `data/ScoreStore.ets` | Score persistence via Preferences |
| SettingsStore | `data/SettingsStore.ets` | Settings persistence via Preferences |
| LanguageManager | `utils/LanguageManager.ets` | Language preference management, translations, persistence |
| BeatmapEditor | `engine/BeatmapEditor.ets` | Stub implementation, reserved for v1.4+ |
| MultiplayerService | `engine/MultiplayerService.ets` | Stub implementation, reserved for v1.4+ |

### Tech Stack

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

### Project Structure

```
FingerBeat/
├── AppScope/                    # App-level config and resources
├── common/                      # @ohos/common HAR module
│   └── src/main/ets/
│       ├── constants/           # CommonConstants
│       └── utils/               # Logger, BreakpointSystem, LanguageManager
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
│           ├── ets/             # UIAbility, pages, components
│           │   ├── pages/       # Index, SongSelectPage, GamePage
│           │   └── components/  # LanguageSwitchButton, CountdownOverlay, ResultOverlay
│           └── resources/       # i18n (en_US, zh_CN, base), dark mode, rawfile (audio)
├── screenshots/                 # App screenshots
├── build-profile.json5          # Build configuration
├── oh-package.json5             # Package manifest
└── code-linter.json5            # Lint rules
```

### Pages

| Page | Route | Description |
|------|-------|-------------|
| Index | `pages/Index` | Main menu with app title, "Ready to Beat" button, and language switch |
| SongSelectPage | `pages/SongSelectPage` | Song selection page with scrollable level list + EASY/NORMAL/HARD difficulty selector + back arrow |
| GamePage | `pages/GamePage` | Game play page with 3-second countdown, Canvas rendering, HUD overlay, and result screen |

### Game Constants

| Parameter | Easy | Normal | Hard |
|-----------|------|--------|------|
| PERFECT window | 50ms | 40ms | 30ms |
| GREAT window | 100ms | 80ms | 60ms |
| GOOD window | 150ms | 120ms | 100ms |
| Speed multiplier | 0.8x | 1.0x | 1.2x |

**Score weights**: PERFECT=300, GREAT=200, GOOD=100, MISS=0

**Combo multipliers**: 4+ combo = 1.1x, 8+ = 1.2x, 16+ = 1.3x, 32+ = 1.4x, 64+ = 1.5x

### Judgment Display

| Judgment | Position | Notes |
|----------|----------|-------|
| PERFECT / GREAT / GOOD | Centered above screen center | Single display, new judgment overwrites previous |
| MISS | Above corresponding lane | Max 2 concurrent, independent from other judgments |

### Getting Started

#### Prerequisites

- [DevEco Studio](https://developer.huawei.com/consumer/cn/deveco-studio/) 5.0+
- HarmonyOS SDK 6.0.2(22) or later
- OHPM (bundled with DevEco Studio)

#### Build & Run

1. Clone the repository
2. Open the project in DevEco Studio
3. Wait for OHPM to install dependencies
4. Connect a HarmonyOS device or start an emulator
5. Click **Run** or use `hvigorw assembleHap`

#### Run Tests

```bash
hvigorw testLocalUnit
hvigorw testOhosTest
```

### Version Statement

**Current Version: v1.3.1** (2026-04-27)

**Highlights of this update:**
- Implemented Chinese/English bilingual real-time UI switching (language switch button at top-left corner of home page)
- Added 3-second countdown animation before game starts (3 → 2 → 1 → BEAT)
- Unified home page background to dark theme, result screen fully supports bilingual display

**Current core capabilities:**
- Note auto-fall and real-time judgment system (since v1.3.0)
- Four-grade judgment (PERFECT/GREAT/GOOD/MISS) with combo multipliers (since v1.3.0)
- Note generation: Pre-generated fixed 4-cycle beatmaps via Python script (located at project root gen_beatmaps.py)
- Bilingual UI (Chinese/English), 3-second countdown (since v1.3.1)

**Known limitations:**
- "Beat It Yourself" mode not yet fully implemented (planned for v1.6.x)
- User custom beatmap editing not supported
- Background music, hit sound effects, and beat detection not supported

📜 Full version history available at [CHANGELOG.md](./CHANGELOG.md)

### Project Highlight: "Beat It Yourself" Mode Design (Planned for v1.6.x)

The design goal of this mode is to enable users who cannot play instruments to experience the effect of "playing music themselves."

**Dual-mode design:**
- **Auto-play mode**: BGM plays continuously throughout; user taps to the beat
- **Beat It Yourself mode**: BGM is not auto-played by default; when notes are missed, music cuts out (BGM volume set to zero without pausing playback); when notes are hit, volume fades in — creating a "user plays the music" experience

**Technical details (v1.6.x planned):**
- When a note is missed, BGM volume is set to zero (without pausing playback); volume restored on hit
- Volume fade-in on hit rather than abrupt restoration
- In this mode, hit sound effects are disabled by default; feedback provided solely through BGM volume changes

**Copyright mitigation:**
- MP3 path memory option for quick loading of personal music files
- Dedicated directory for storing user MP3 files
- "Blocking interaction" mechanism requiring users to confirm that their MP3 files are obtained through legal means with lawful copy rights
- Technology-neutral principle: the legality of user MP3 usage is the user's responsibility and unrelated to the developer

Providing this mode also aims to alleviate the practical difficulty faced by students who lack music copyrights for creating game levels.

### Update Plan

**Version 1.4.x — Basic Audio Playback**

- Implement background music playback: Support importing and playing local MP3 files, with play, pause, and progress bar controls.
- Implement hit sound effect playback: When the player taps a note, play a short sound effect (e.g., "ding") with low latency.

**Version 1.5.x — Note Generation Optimization + Beat Detection + Normal Mode Auto-Alignment**

- Optimize note generation logic: Replace the original Python script fixed 4-cycle approach with in-game dynamic note generation based on BPM, making beatmaps more varied and rich.
- Implement beat detection capability: Perform local analysis on user-imported MP3 files to detect BPM and extract beat timestamp arrays.
- Apply beat detection results to normal mode: Achieve automatic alignment between notes and music beats, giving players a precise rhythm experience in normal mode.

**Version 1.6.x — "Beat It Yourself" Mode Full Version**

- New "Beat It Yourself" game interface:
  - Allow users to import local MP3 files, manually input BPM and duration (if beat detection is implemented, auto-fill recommended values); if beat detection is not enabled or the user opts out, enter detached mode (music plays independently, notes generated by manual BPM, not synchronized).
  - Provide "Auto-play BGM" toggle:
    - On: Music plays continuously throughout, unaffected by player hit/miss results.
    - Off: When the player misses a note, set BGM volume to zero (without pausing playback); restore original volume on hit.
- Integrate beat detection results into play mode: Achieve automatic alignment between notes and music beats, completing the full rhythm experience.

### License

Apache-2.0
