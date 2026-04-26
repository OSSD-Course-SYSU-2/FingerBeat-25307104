# FingerBeat v1.3.0 编码任务

## 阶段一：项目基础设施搭建

### 任务 1.1：清理当前项目模板代码

**目标**：移除当前项目中 adaptiveLayout、responsiveLayout 等模板模块，保留项目骨架

**操作**：
1. 删除 `features/adaptiveLayout/` 目录
2. 删除 `features/responsiveLayout/` 目录
3. 从 `build-profile.json5` 的 modules 中移除 adaptiveLayout 和 responsiveLayout
4. 从 `products/default/oh-package.json5` 中移除对 adaptiveLayout 和 responsiveLayout 的依赖
5. 删除 `products/default/src/main/ets/pages/AdaptiveIndex.ets`
6. 删除 `products/default/src/main/ets/pages/ResponsiveIndex.ets`
7. 删除 `products/default/src/main/ets/pages/SystemCapabilitiesIndex.ets`
8. 清理 `products/default/src/main/ets/view/` 和 `viewmodel/` 中的模板代码
9. 更新 `products/default/src/main/resources/base/profile/main_pages.json` 移除模板页面路由
10. 更新 `AppScope/app.json5` 中 versionName 为 "1.3.0"

**验收**：项目可正常编译，无模板残留代码

---

### 任务 1.2：创建游戏核心 HAR 模块

**目标**：创建 `features/game/` HAR 模块，建立游戏核心代码的目录结构

**操作**：
1. 创建 `features/game/` 目录及标准 HAR 模块配置文件：
   - `oh-package.json5`（依赖 `@ohos/common`）
   - `build-profile.json5`
   - `hvigorfile.ts`
   - `consumer-rules.txt`
   - `obfuscation-rules.txt`
   - `Index.ets`（模块导出入口）
   - `src/main/module.json5`（type: "har"）
2. 创建源码目录结构：
   - `src/main/ets/model/` - 数据模型
   - `src/main/ets/engine/` - 游戏引擎
   - `src/main/ets/data/` - 数据仓库与持久化
   - `src/main/ets/data/beatmaps/` - 谱面数据
   - `src/main/ets/constants/` - 游戏常量
   - `src/main/ets/pages/` - 游戏页面
3. 在 `build-profile.json5` 中注册 game 模块
4. 在 `products/default/oh-package.json5` 中添加对 `@ohos/game` 的依赖

**验收**：game 模块可被 default 模块正确引用，项目可编译

---

### 任务 1.3：迁移音频资源文件

**目标**：将 v1.2.0 的音频资源文件迁移到当前项目

**操作**：
1. 从 v1.2.0 复制以下文件到 `products/default/src/main/resources/rawfile/`：
   - `bgm_song1.wav`
   - `bgm_song2.wav`
   - `bgm_song3.wav`
   - `sfx_hit.wav`
   - `sfx_miss.wav`
2. 从 v1.2.0 复制图片资源到对应资源目录（如 note_normal.png 等）

**验收**：rawfile 目录包含所有音频文件，资源可被正确引用

---

### 任务 1.4：配置国际化资源

**目标**：设置中英文国际化字符串资源

**操作**：
1. 更新 `products/default/src/main/resources/base/element/string.json` 添加游戏相关字符串
2. 更新 `products/default/src/main/resources/zh_CN/element/string.json` 添加中文字符串
3. 更新 `products/default/src/main/resources/en_US/element/string.json` 添加英文字符串
4. 包含的字符串键：app_name, app_subtitle, start_game, settings, song_select, difficulty_easy/normal/hard, score, combo, accuracy, max_combo, perfect/great/good/miss, retry, back_to_songs, resume, quit, pause, new_record, restore_default, judgment_perfect/great/good/miss 等

**验收**：所有页面文本使用 `$r()` 引用，中英文切换正常

---

## 阶段二：模型层与常量层

### 任务 2.1：实现 GameTypes 数据模型

**目标**：在 `features/game/src/main/ets/model/GameTypes.ets` 中定义所有枚举和接口

**操作**：
1. 定义枚举：GameState, JudgmentGrade, LetterGrade, Difficulty, NoteType, SongSource, GameEventType, GameMode, RoomStatus
2. 定义接口：NoteData, RuntimeNote, JudgmentWindows, JudgmentResult, GameConfig, GameResult, SongInfo, Beatmap, GameSettings, BestScore, GamePageParams, ResultPageParams, BeatmapPackage
3. 定义抽象类 GameUIUpdater（onNotesUpdate, onScoreUpdate, onComboUpdate, onJudgmentShow, onGameEnd）
4. 定义编辑器预留接口：EditorProject, EditorAction, BeatmapEditor（createNote/deleteNote/moveNote/undo/redo/preview/save/detectBPM 空实现）
5. 定义多人游戏预留接口：RoomInfo, PlayerState, MultiplayerResult, MultiplayerService（createRoom/joinRoom/leaveRoom/setReady/startGame/syncState/getRanking 空实现）
6. 在 `features/game/Index.ets` 中导出 GameTypes

**验收**：所有类型可被外部模块正确导入使用，编辑器和多人游戏预留接口可编译通过

---

### 任务 2.2：实现 GameConstants 游戏常量

**目标**：在 `features/game/src/main/ets/constants/GameConstants.ets` 中集中管理所有游戏常量

**操作**：
1. 游戏循环常量：GAME_LOOP_INTERVAL, DEFAULT_LANE_COUNT, BASE_SCROLL_SPEED, JUDGMENT_LINE_RATIO, NOTE_VISIBLE_AHEAD_TIME, NOTE_VISIBLE_BEHIND_TIME
2. 判定窗口配置：JUDGMENT_WINDOWS（按难度）
3. 难度速度倍率：DIFFICULTY_SPEED_MULTIPLIER
4. 评分权重：SCORE_WEIGHTS
5. 连击倍率：COMBO_MULTIPLIERS
6. 字母评级阈值：LETTER_GRADE_THRESHOLDS
7. 判定颜色：JUDGMENT_COLORS
8. 字母评级颜色：LETTER_GRADE_COLORS
9. 持久化存储名：SETTINGS_STORE_NAME, SCORE_STORE_NAME
10. 在 `features/game/Index.ets` 中导出 GameConstants

**验收**：无魔法数字，所有配置值集中管理

---

## 阶段三：数据层

### 任务 3.1：实现谱面数据

**目标**：在 `features/game/src/main/ets/data/beatmaps/` 中定义3首曲目的谱面数据

**操作**：
1. 创建 `Song1Info.ets`：曲目1 "星空旋律" 信息（id, title, artist, bpm, duration, audioFilePath, difficulties, source）
2. 创建 `Song1Beatmaps.ets`：曲目1 三个难度谱面（Easy 25音符, Normal 50音符, Hard 100音符）
3. 创建 `Song2Beatmaps.ets`：曲目2 "电子脉冲" 信息+三个难度谱面（Easy 22, Normal 43, Hard 85）
4. 创建 `Song3Beatmaps.ets`：曲目3 "梦幻节拍" 信息+三个难度谱面（Easy 24, Normal 47, Hard 93）
5. 所有音符均为 NoteType.TAP，按 targetTime 升序排列

**验收**：谱面数据完整，音符数量和排列与 v1.2.0 一致

---

### 任务 3.2：实现 BeatmapRepository 谱面仓库

**目标**：在 `features/game/src/main/ets/data/BeatmapRepository.ets` 中实现谱面仓库单例

**操作**：
1. 实现模块级单例模式
2. 内置3首曲目数据（引用 beatmaps/ 中的数据）
3. 实现 `getAllSongs(source?)`：返回曲目列表，支持按 SongSource 过滤
4. 实现 `getSongById(songId)`：按ID查找曲目
5. 实现 `getBeatmap(songId, difficulty)`：获取谱面
6. 预留 `addSong(song)` / `removeSong(songId)` / `checkOfficialUpdates()` 空实现
7. 在 `features/game/Index.ets` 中导出 BeatmapRepository

**验收**：可正确查询内置曲目和谱面，预留方法可调用不报错

---

### 任务 3.3：实现 ScoreStore 分数持久化

**目标**：在 `features/game/src/main/ets/data/ScoreStore.ets` 中实现分数持久化

**操作**：
1. 使用 `@kit.ArkData` 的 `preferences` API
2. 实现 `init(context)`：初始化 Preferences 存储（存储名 fingerbeat_scores）
3. 实现 `getBestScore(songId, difficulty)`：获取最佳分数，读取失败返回 null
4. 实现 `updateBestScore(songId, difficulty, result)`：仅当新分数更高时更新，返回是否为新纪录
5. 实现 `getAllBestScores()`：获取所有最佳分数
6. 所有操作 try-catch 包裹，失败时记录日志使用默认值
7. 模块级单例模式
8. 在 `features/game/Index.ets` 中导出 ScoreStore

**验收**：分数可正确持久化和读取，异常时不崩溃

---

### 任务 3.4：实现 SettingsStore 设置持久化

**目标**：在 `features/game/src/main/ets/data/SettingsStore.ets` 中实现设置持久化

**操作**：
1. 使用 `@kit.ArkData` 的 `preferences` API
2. 实现 `init(context)`：初始化 Preferences 存储（存储名 fingerbeat_settings）
3. 实现 `getSettings()`：获取当前设置，默认值 musicVolume=0.8, sfxVolume=0.8, scrollSpeed=1.0
4. 实现 `updateSettings(partial)`：部分更新设置并持久化
5. 实现 `resetToDefault()`：重置为默认值并持久化
6. 所有操作 try-catch 包裹，失败时记录日志使用默认值
7. 模块级单例模式
8. 在 `features/game/Index.ets` 中导出 SettingsStore

**验收**：设置可正确持久化和读取，异常时不崩溃

---

## 阶段四：游戏引擎层

### 任务 4.1：实现 GameEventBus 事件总线

**目标**：在 `features/game/src/main/ets/engine/GameEventBus.ets` 中实现发布-订阅事件总线

**操作**：
1. 使用 Map<GameEventType, callback[]> 存储订阅关系
2. 实现 `on(eventType, callback)`：注册订阅
3. 实现 `off(eventType, callback)`：取消订阅
4. 实现 `emit(eventType, data?)`：发布事件，通知所有订阅者
5. 实现 `clear()`：清除所有订阅
6. 模块级单例模式

**验收**：事件可正确发布和接收，取消订阅后不再收到事件

---

### 任务 4.2：实现 JudgeSystem 判定系统

**目标**：在 `features/game/src/main/ets/engine/JudgeSystem.ets` 中实现判定逻辑

**操作**：
1. 构造函数接收 JudgmentWindows 配置
2. 实现 `judge(timeOffset)`：根据偏差绝对值返回 JudgmentGrade
   - |offset| <= perfectWindow → PERFECT
   - |offset| <= greatWindow → GREAT
   - |offset| <= goodWindow → GOOD
   - 其他 → MISS
3. 实现 `findNearestNote(lane, currentTime, notes, goodWindow)`：在指定轨道查找 goodWindow 内最近的未判定 TAP 音符

**验收**：判定结果与 v1.2.0 一致，边界值正确

---

### 任务 4.3：实现 ScoreSystem 评分系统

**目标**：在 `features/game/src/main/ets/engine/ScoreSystem.ets` 中实现评分逻辑

**操作**：
1. 构造函数接收 totalNoteCount（用于计算最大可能分数）
2. 内部状态：score, combo, maxCombo, judgmentCounts
3. 实现 `onJudgment(grade)`：
   - 计算基础分（Perfect=300, Great=200, Good=100, Miss=0）
   - 计算连击倍率（10连=1.1x, 30连=1.2x, 50连=1.3x）
   - 更新连击（非MISS: combo+1, MISS: combo=0）
   - 更新 maxCombo
   - 返回分数增量
4. 实现 `getAccuracy()`：总分/最大可能分数 * 100
5. 实现 `getResult()`：返回完整 GameResult（含字母评级计算）

**验收**：评分计算与 v1.2.0 一致，连击和评级正确

---

### 任务 4.4：实现 NoteScheduler 音符调度器

**目标**：在 `features/game/src/main/ets/engine/NoteScheduler.ets` 中实现音符位置更新和MISS检测

**操作**：
1. 构造函数接收 scrollSpeed, judgmentLineY
2. 实现 `update(currentTime, screenHeight)`：
   - 遍历所有音符，计算 currentY = judgmentLineY - (targetTime - currentTime) * scrollSpeed
   - 根据 [targetTime - NOTE_VISIBLE_AHEAD_TIME, targetTime + NOTE_VISIBLE_BEHIND_TIME] 设置 isVisible
3. 实现 `checkMissedNotes(currentTime, goodWindow)`：
   - 检测 targetTime + goodWindow < currentTime 且未判定的 TAP 音符
   - 返回 MISS 音符ID列表
4. 实现 `markNoteJudged(noteId)`：标记音符 isJudged = true

**验收**：音符位置计算与 v1.2.0 一致，MISS 检测正确

---

### 任务 4.5：实现 AudioPlayer 音频播放器

**目标**：在 `features/game/src/main/ets/engine/AudioPlayer.ets` 中实现音频播放

**操作**：
1. 使用 `@kit.MediaKit` 的 `media.AVPlayer`
2. 实现 `initBGM(filePath, context)`：创建 BGM AVPlayer，通过 resourceManager.getRawFdSync() 加载
3. 实现 `initSFX(name, filePath, context)`：创建音效 AVPlayer 并加入 SFX 池
4. 实现 BGM 控制：playBGM, pauseBGM, resumeBGM, stopBGM
5. 实现 `playSFX(name)`：播放指定音效
6. 实现 `getCurrentTime()`：返回 BGM 当前播放位置（毫秒）
7. 实现 `release()`：释放所有 AVPlayer 资源
8. 所有操作 try-catch 包裹，失败时记录日志但不阻塞
9. 设置 volume 属性控制音量

**验收**：BGM 和音效可正常播放，音频初始化失败时游戏不崩溃

---

### 任务 4.6：实现 GameEngine 游戏引擎

**目标**：在 `features/game/src/main/ets/engine/GameEngine.ets` 中实现游戏主控制器

**操作**：
1. 持有 JudgeSystem, ScoreSystem, NoteScheduler, AudioPlayer, GameEventBus 实例
2. 持有 GameUIUpdater 引用用于回调 UI
3. 实现 `start(config, context)`：
   - 从 BeatmapRepository 加载谱面
   - 初始化 JudgeSystem（根据难度设置判定窗口）
   - 初始化 ScoreSystem（传入音符总数）
   - 初始化 NoteScheduler（计算 scrollSpeed = BASE_SCROLL_SPEED * difficultyMultiplier * userScrollSpeed）
   - 初始化 AudioPlayer（加载 BGM 和音效）
   - 播放 BGM
   - 启动游戏循环 setInterval(gameLoop, 16)
4. 实现 `gameLoop()`：
   - 获取当前时间（优先 AudioPlayer.getCurrentTime()，降级 Date.now() - startTime）
   - NoteScheduler.update(currentTime, screenHeight)
   - 检测 MISS 音符并处理
   - 回调 UI 更新
   - 检查是否所有音符已判定，若是则 endGame()
5. 实现 `onLaneTap(laneIndex)`：
   - JudgeSystem.findNearestNote() 查找最近音符
   - 若找到：JudgeSystem.judge() → ScoreSystem.onJudgment() → AudioPlayer.playSFX() → 回调UI
   - 若未找到：不处理
6. 实现 `pause()` / `resume()`：暂停/恢复游戏循环和BGM
7. 实现 `endGame()`：生成 GameResult，回调 UI onGameEnd
8. 实现 `quit()`：清除定时器，AudioPlayer.release()，重置状态

**验收**：游戏可正常启动、进行、暂停、恢复、结束，与 v1.2.0 行为一致

---

## 阶段五：UI 页面层

### 任务 5.1：实现 MainPage 主菜单页面

**目标**：在 `products/default/src/main/ets/pages/Index.ets` 中实现主菜单

**操作**：
1. `@Entry @ComponentV2` 入口页面
2. 使用 `Navigation` + `NavPathStack` 管理页面栈
3. UI 布局：
   - 应用图标（icon.png）
   - 标题 "FingerBeat"（大号字体）
   - 副标题 "节奏指尖游戏"（小号字体）
   - "开始游戏" 按钮 → 导航至 SongSelectPage
   - "设置" 按钮 → 导航至 SettingsPage
4. 渐变背景（#F0F4FF → #FFFFFF）
5. 注册 NavDestination：SongSelectPage, GamePage, ResultPage, SettingsPage
6. 配置 route_map.json 路由映射

**验收**：主菜单显示正确，按钮可导航至对应页面

---

### 任务 5.2：实现 SongSelectPage 曲目选择页面

**目标**：在 `features/game/src/main/ets/pages/SongSelectPage.ets` 中实现曲目选择

**操作**：
1. `@ComponentV2` 组件，NavDestination 页面
2. 初始化 ScoreStore 和 SettingsStore
3. 曲目列表（ForEach 渲染 BeatmapRepository.getAllSongs()）：
   - 每项显示：标题、艺术家
   - 各难度最佳分数（从 ScoreStore 获取，无记录显示 "--"）
4. 难度选择器：Easy/Normal/Hard 三按钮，默认选中 Easy
5. 选中曲目高亮显示
6. "开始游戏" 按钮 → 导航至 GamePage，传递 GamePageParams
7. 返回按钮

**验收**：曲目列表显示正确，可选择曲目和难度，最佳分数正确显示

---

### 任务 5.3：实现 GamePage 游戏进行页面

**目标**：在 `features/game/src/main/ets/pages/GamePage.ets` 中实现游戏核心页面

**操作**：
1. `@ComponentV2` 组件，NavDestination 页面
2. 从路由参数获取 GamePageParams
3. 页面状态：score, combo, notes, judgmentGrade, judgmentLane, isPaused, laneHighlights[]
4. 实现 GamePageUIUpdater（extends GameUIUpdater）桥接 GameEngine 回调到页面状态
5. aboutToAppear 中初始化 GameEngine.start()
6. aboutToDisappear 中调用 GameEngine.quit()
7. UI 布局：
   - 顶部信息栏：Score + Combo
   - 音符下落区域：
     - 4 条轨道（支持多点触控）
     - 判定线（85% 位置）
     - 音符渲染（Circle 组件，根据 RuntimeNote.currentY 定位）
     - 判定结果显示（PERFECT/GREAT/GOOD/MISS 文字 + 特效）
   - 底部：进度条 + 暂停按钮
8. 暂停菜单弹窗（CustomDialog 或 bindSheet）：继续/退出
9. 轨道触控处理：onLaneTap → GameEngine.onLaneTap()
10. 轨道高亮效果：点击时高亮 100ms
11. 判定视觉特效：
    - PERFECT/GREAT：扩散爆炸（1.5x→1.0x, 300ms）
    - GOOD：轻微缩放（1.2x→1.0x, 200ms）
    - MISS：红色文字
12. 系统返回键拦截 → 触发暂停
13. 游戏结束时保存最佳分数并导航至 ResultPage

**验收**：游戏可正常进行，触控响应正确，判定特效显示正确，暂停/继续/退出正常

---

### 任务 5.4：实现 ResultPage 结算页面

**目标**：在 `features/game/src/main/ets/pages/ResultPage.ets` 中实现游戏结算

**操作**：
1. `@ComponentV2` 组件，NavDestination 页面
2. 从路由参数获取 ResultPageParams
3. UI 布局：
   - 字母评级（大号彩色文字，颜色根据 LetterGrade）
   - NEW 标识（新纪录时闪烁动画）
   - 总分
   - 准确率（百分比）
   - 最大连击
   - 判定统计表：Perfect/Great/Good/Miss 数量
   - "重试" 按钮 → 导航至 GamePage（相同参数）
   - "返回曲目列表" 按钮 → 导航至 SongSelectPage

**验收**：结算信息显示正确，NEW 标识闪烁正确，重试和返回导航正确

---

### 任务 5.5：实现 SettingsPage 设置页面

**目标**：在 `features/game/src/main/ets/pages/SettingsPage.ets` 中实现游戏设置

**操作**：
1. `@ComponentV2` 组件，NavDestination 页面
2. 初始化 SettingsStore
3. UI 布局：
   - 音乐音量 Slider（0-1，步长 0.01）
   - 音效音量 Slider（0-1，步长 0.01）
   - 下落速度 Slider（0.5-2.0，步长 0.1）
   - "恢复默认设置" 按钮
4. Slider onChange 实时保存到 SettingsStore
5. 恢复默认调用 SettingsStore.resetToDefault()
6. 返回按钮

**验收**：设置可正确调节和保存，恢复默认功能正确

---

## 阶段六：扩展预留实现

### 任务 6.1：实现 BeatmapEditor 预留接口

**目标**：在 `features/game/src/main/ets/engine/BeatmapEditor.ets` 中实现谱面编辑器预留类

**操作**：
1. 创建 BeatmapEditor 类，实现所有预留方法（空实现，记录"未实现"日志）
2. createNote/deleteNote/moveNote：返回空或默认值
3. undo/redo：返回 false
4. preview：空实现
5. save：返回空 Beatmap
6. detectBPM：返回 0
7. 在 `features/game/Index.ets` 中导出 BeatmapEditor

**验收**：BeatmapEditor 所有方法可调用不报错，日志记录"未实现"

---

### 任务 6.2：实现 MultiplayerService 预留接口

**目标**：在 `features/game/src/main/ets/engine/MultiplayerService.ets` 中实现多人游戏预留类

**操作**：
1. 创建 MultiplayerService 类，实现所有预留方法（空实现，记录"未实现"日志）
2. createRoom/joinRoom/leaveRoom：返回空 RoomInfo
3. setReady/startGame/syncState：空实现
4. getRanking：返回空 MultiplayerResult
5. 在 `features/game/Index.ets` 中导出 MultiplayerService

**验收**：MultiplayerService 所有方法可调用不报错，日志记录"未实现"

---

## 阶段七：项目文档与收尾

### 任务 7.1：创建 README.md

**目标**：创建符合 GitHub 规范的中文 README.md

**操作**：
1. 标题：实现音乐节奏游戏功能
2. 项目简介：FingerBeat 是一款基于 HarmonyOS 的音乐节奏游戏，v1.3.0 是在保持 v1.2.0 全部功能的基础上，完全重构代码以修复问题的新版本
3. 效果预览：多设备截图表格（手机/平板/PC）
4. 相关概念：ArkUI 声明式开发范式、Navigation 导航、AVPlayer 音频播放、Preferences 数据持久化
5. 使用说明：选择曲目 → 选择难度 → 游玩 → 查看结算
6. 工程目录：树形目录结构（关键文件加注释）
7. 具体实现：游戏引擎架构、判定系统、评分系统说明
8. 相关权限：不涉及
9. 约束与限制：支持设备、SDK 版本、DevEco Studio 版本

**验收**：README.md 格式规范，无拼写错误，无符号错误，表格格式合法

---

### 任务 7.2：创建 README.en.md

**目标**：创建英文版 README

**操作**：
1. 翻译 README.md 全部内容为英文
2. 保持相同的格式结构
3. 确保英文表达自然，无语法错误

**验收**：英文 README 格式规范，内容与中文版一致

---

### 任务 7.3：创建 LICENSE 和 OAT.xml

**目标**：添加 Apache 2.0 许可证和 OAT 审查配置

**操作**：
1. 从 v1.2.0 复制 LICENSE 文件（Apache 2.0）
2. 从 v1.2.0 复制 OAT.xml 文件

**验收**：LICENSE 和 OAT.xml 存在且内容正确

---

### 任务 6.4：创建 screenshots 戺张目录

**目标**：添加应用截图

**操作**：
1. 创建 `screenshots/` 目录
2. 从 v1.2.0 复制截图文件（phone.png, tablet.png, pc.png）

**验收**：screenshots 目录包含多设备截图

---

### 任务 7.5：最终验证与构建

**目标**：确保项目可正常编译和运行

**操作**：
1. 检查所有文件无语法错误
2. 检查所有导入路径正确
3. 检查路由配置正确
4. 检查资源引用正确
5. 执行项目构建，修复所有编译错误
6. 验证所有页面可正常导航
7. 验证游戏核心功能可正常运行

**验收**：项目可正常编译构建，所有功能与 v1.2.0 一致
