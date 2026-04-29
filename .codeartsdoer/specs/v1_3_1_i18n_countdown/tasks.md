# FingerBeat v1.3.1 — 编码任务规划

> 基于 spec.md（需求规格）和 design.md（实现方案）拆解的可执行编码任务。
> 版本：v1.3.0 → v1.3.1 | 功能：双语界面切换（i18n）+ 游戏启动3秒倒计时

---

## 1. 资源文件词条补充

> 依赖：无 | 优先级：最高（后续所有任务的基础）

- [ ] 在 `products/default/src/main/resources/zh_CN/element/string.json` 中新增以下词条：
  - `result_title`：结算
  - `new_record_full`：新纪录！
  - `back`：返回
  - `pause_label`：暂停
  - `resume_label`：继续
  - `score_label`：分数
  - `best_label`：最佳
  - `accuracy_label`：准确率
  - `max_combo_label`：最大连击
  - `countdown_beat`：BEAT
  - `level_warm_up`：牛刀小试
  - `level_starry_melody`：星空旋律
  - `level_electro_pulse`：电子脉冲
  - `level_dream_beat`：梦幻节拍
  - `no_bgm`：无BGM
  - 验收：词条键与 en_US、base 完全一致，值正确

- [ ] 在 `products/default/src/main/resources/en_US/element/string.json` 中新增对应英文词条：
  - `result_title`：Results
  - `new_record_full`：NEW RECORD!
  - `back`：Back
  - `pause_label`：Pause
  - `resume_label`：Resume
  - `score_label`：Score
  - `best_label`：Best
  - `accuracy_label`：Accuracy
  - `max_combo_label`：Max Combo
  - `countdown_beat`：BEAT
  - `level_warm_up`：Warm Up
  - `level_starry_melody`：Starry Melody
  - `level_electro_pulse`：Electro Pulse
  - `level_dream_beat`：Dream Beat
  - `no_bgm`：No BGM
  - 验收：词条键集合与 zh_CN 完全一致

- [ ] 在 `products/default/src/main/resources/base/element/string.json` 中新增对应 base 词条（默认值与 en_US 一致）
  - 验收：三份资源文件的词条键集合完全一致，满足 spec 规则 5.1.1-9

---

## 2. LanguageManager 语言偏好管理器

> 依赖：任务1（资源词条） | 优先级：高

- [ ] 创建 `common/src/main/ets/utils/LanguageManager.ets`，实现语言偏好管理器单例：
  - 定义 `LanguageCode` 类型（'zh' | 'en'）
  - 实现 `init(context: Context): void`：读取 Preferences 持久化偏好 → 若无则调用 `detectSystemLanguage()` → 调用 `applyLanguageConfig()` 更新资源配置
  - 实现 `detectSystemLanguage(): LanguageCode`：通过 `context.resourceManager.getConfiguration()` 获取系统语言，以 'zh' 开头返回 'zh'，以 'en' 开头返回 'en'，其他回退 'zh'
  - 实现 `getLanguage(): LanguageCode`：返回当前语言
  - 实现 `toggleLanguage(): void`：zh↔en 来回切换，持久化到 Preferences，调用 `applyLanguageConfig()` 刷新资源配置
  - 实现 `setLanguage(lang: LanguageCode): void`：设置指定语言并持久化+刷新
  - 实现 `getSwitchButtonText(): string`：zh 时返回 '中文'，en 时返回 'EN'
  - 实现 `applyLanguageConfig(lang: LanguageCode): void`：调用 `context.resourceManager.updateConfiguration({ language: lang, region: '' })` 触发全局 $r() 刷新
  - 导出单例实例 `export default new LanguageManager()`
  - 验收：初始化逻辑正确（持久化 > 系统语言 > 默认中文回退），切换后 $r() 引用自动刷新

- [ ] 修改 `common/Index.ets`，新增 LanguageManager 导出：
  - 添加 `export { default as languageManager } from './src/main/ets/utils/LanguageManager'`
  - 验收：其他模块可通过 `import { languageManager } from '@ohos/common'` 引入

---

## 3. LanguageSwitchButton 语言切换按钮组件

> 依赖：任务2（LanguageManager） | 优先级：高

- [ ] 创建 `products/default/src/main/ets/components/` 目录（如不存在）

- [ ] 创建 `products/default/src/main/ets/components/LanguageSwitchButton.ets`，实现语言切换按钮：
  - 引入 `languageManager` from '@ohos/common'
  - 使用 `@Consume currentLang: string` 消费父组件语言状态
  - UI 规格：圆角矩形（borderRadius=8）、透明填充（backgroundColor=Color.Transparent）、边框颜色=文字颜色='#FFFFFF'、borderWidth=1.5、fontSize=14、padding={left:12,right:12,top:6,bottom:6}
  - 显示文字：currentLang==='zh' 时显示 '中文'，否则显示 'EN'
  - onClick 事件：调用 `languageManager.toggleLanguage()`，同时更新 `currentLang` 状态
  - 验收：按钮样式符合 spec 5.1.1-4，点击可来回切换中英文

---

## 4. Index 首页集成语言切换按钮、国际化与深色背景改造

> 依赖：任务2、任务3 | 优先级：高

- [ ] 修改 `products/default/src/main/ets/pages/Index.ets`，集成语言切换按钮与国际化：
  - 引入 `languageManager` from '@ohos/common'，引入 `LanguageSwitchButton`
  - 添加 `@Provide currentLang: string = 'zh'` 状态变量
  - 在 `aboutToAppear()` 中调用 `languageManager.init(getContext(this))`，初始化后读取 `languageManager.getLanguage()` 设置 `currentLang`
  - 将硬编码 `Text('FingerBeat')` 替换为 `Text($r('app.string.app_name'))`
  - 使用 `Stack` 包裹布局，将 `LanguageSwitchButton` 以 `.position({ x: 16, y: 16 })` 固定在左上角
  - 语言切换后同步更新 `currentLang` 状态（可使用定时器轮询或回调机制）
  - 验收：首页显示语言切换按钮，点击切换后界面文本实时更新，按钮位置固定左上角不受滚动影响

- [ ] 修改 `products/default/src/main/ets/pages/Index.ets`，深色背景色替换：
  - 将页面背景色从系统浅色 `$r('sys.color.ohos_id_color_sub_background')` 替换为深色 `'#0D0D1A'`
  - 在包含首页内容的 Column/Stack 容器上设置 `.backgroundColor('#0D0D1A')`
  - 确保移除所有系统浅色背景引用，代码中不再出现 `$r('sys.color.ohos_id_color_sub_background')` 或等效系统浅色背景引用
  - 验收：首页背景色为 '#0D0D1A'，与 SongSelectPage、GamePage 背景色视觉一致，无浅色背景残留

- [ ] 修改 `products/default/src/main/ets/pages/Index.ets`，首页标题文字颜色适配深色背景：
  - 将首页标题文字颜色改为 `'#FFFFFF'`（白色），设置 `.fontColor('#FFFFFF')`
  - 确认 '#FFFFFF' 与 '#0D0D1A' 背景的对比度 ≈ 17.4:1，远超 WCAG 2.1 AA 级标准（4.5:1）
  - 验收：首页标题在深色背景上清晰可读，文字颜色为白色

- [ ] 修改 `products/default/src/main/ets/pages/Index.ets`，首页按钮文字颜色适配深色背景：
  - 将首页按钮文字颜色改为 `'#FFFFFF'`（白色），设置 `.fontColor('#FFFFFF')`
  - 按钮背景色调整为与深色主题协调的样式（如渐变色、强调色等），确保按钮在深色背景上视觉层次分明
  - 辅助说明文字（如有）颜色改为 `'#AAAAAA'`（浅灰色），确保在深色背景上可读
  - 验收：首页按钮文字在深色背景上清晰可读，按钮整体视觉效果与深色主题协调

- [ ] 确保首页深色背景与 SongSelectPage/GamePage 视觉一致性：
  - 对比首页背景色（'#0D0D1A'）与 SongSelectPage 背景色，确认色值完全一致
  - 对比首页背景色（'#0D0D1A'）与 GamePage 背景色，确认色值完全一致
  - 确认从首页跳转至关卡选择页或游戏页时，背景色无跳变，页面过渡视觉平滑
  - 确认语言切换按钮在深色背景上保持圆角矩形、透明填充、文字颜色与边框颜色一致的样式，且清晰可辨
  - 验收：三个页面背景色统一为 '#0D0D1A'，跨页面过渡无背景色跳变，首页所有文字在深色背景上对比度≥4.5:1

---

## 5. SongSelectPage 关卡选择页国际化

> 依赖：任务1、任务2 | 优先级：高

- [ ] 修改 `products/default/src/main/ets/pages/SongSelectPage.ets`：
  - 引入 `languageManager` from '@ohos/common'
  - 添加 `@State currentLang: string = 'zh'` 并在 `aboutToAppear()` 中初始化
  - 新增关卡标题翻译映射 `LEVEL_TITLE_MAP`：
    ```
    levelId 0: zh='牛刀小试', en='Warm Up'
    levelId 1: zh='星空旋律', en='Starry Melody'
    levelId 2: zh='电子脉冲', en='Electro Pulse'
    levelId 3: zh='梦幻节拍', en='Dream Beat'
    ```
  - 新增 `getLevelTitle(levelId: number, lang: string): string` 辅助函数
  - 将关卡列表 `LEVEL_LIST` 中的 `title` 字段改为根据 `currentLang` 动态获取翻译标题
  - 将硬编码难度标签 `DIFFICULTY_LABELS` 替换为 `$r()` 引用：`$r('app.string.difficulty_easy')`、`$r('app.string.difficulty_normal')`、`$r('app.string.difficulty_hard')`
  - 将描述文本中的 `'无BGM'` 替换为 `$r('app.string.no_bgm')` 引用
  - 语言切换时同步更新 `currentLang` 状态以触发界面重渲染
  - 验收：中英文切换后关卡标题、难度标签、描述文本均正确显示对应语言版本

---

## 6. GameTypes 枚举扩展

> 依赖：无 | 优先级：中

- [ ] 修改 `features/game/src/main/ets/model/GameTypes.ets`：
  - 在 `GameState` 枚举中 IDLE 与 PLAYING 之间新增 `COUNTDOWN` 状态：
    ```typescript
    export enum GameState {
      IDLE,
      COUNTDOWN,  // 新增：倒计时阶段
      PLAYING,
      PAUSED,
      ENDED
    }
    ```
  - 确认 `features/game/Index.ets` 的导出已包含 GameState（当前已有，无需修改）
  - 验收：GameState.COUNTDOWN 可被外部模块正常引用，不影响现有枚举值

---

## 7. CountdownOverlay 倒计时遮罩组件

> 依赖：任务1（countdown_beat词条） | 优先级：中

- [ ] 创建 `products/default/src/main/ets/components/CountdownOverlay.ets`，实现倒计时遮罩组件：
  - 定义 `CountdownPhase` 枚举：THREE、TWO、ONE、BEAT、DONE
  - 组件状态：`@State phase: CountdownPhase`、`@State isActive: boolean`、`private timerId: number`、`private onEndCallback: () => void`
  - 实现 `start(onEnd: () => void): void`：设置 isActive=true，phase=THREE，保存回调，启动 setTimeout 链
  - 实现 `advance(): void`：根据当前 phase 推进到下一阶段（THREE→TWO→ONE→BEAT→DONE），每个数字阶段 1000ms，BEAT 阶段 500ms，DONE 时调用 onEndCallback
  - 实现 `cancel(): void`：清理所有定时器（clearTimeout），重置 isActive=false
  - 实现 `getDisplayText(): string`：THREE→'3'，TWO→'2'，ONE→'1'，BEAT→'BEAT'（固定英文，中英文均不翻译）
  - UI 实现：半透明遮罩层（backgroundColor='#80000000'）+ 居中大字号文字（fontSize=72，fontColor='#FFFFFF'，fontWeight=Bold）
  - 遮罩层设置 `.hitTestBehavior(HitTestMode.Block)` 屏蔽底层触摸事件
  - 验收：倒计时依次显示 3→2→1→BEAT，各阶段时间间隔正确，BEAT 固定不翻译，遮罩屏蔽触摸

---

## 8. ResultOverlay 结算页面组件提取与国际化

> 依赖：任务1（结算相关词条） | 优先级：中

- [ ] 创建 `products/default/src/main/ets/components/ResultOverlay.ets`，从 GamePage 中提取结算遮罩逻辑为独立组件：
  - 属性接口：`@Prop score: number`、`@Prop accuracy: number`、`@Prop maxCombo: number`、`@Prop bestScore: number`、`@Prop isNewRecord: boolean`
  - 所有硬编码文本替换为 `$r()` 引用：
    - '结算' → `$r('app.string.result_title')`
    - 'Score:' → `$r('app.string.score_label')` + ': '
    - '新纪录！' → `$r('app.string.new_record_full')`
    - 'Best:' → `$r('app.string.best_label')` + ': '
    - 'Accuracy:' → `$r('app.string.accuracy_label')` + ': '
    - 'Max Combo:' → `$r('app.string.max_combo_label')` + ': '
    - '返回' → `$r('app.string.back')`
  - 保持原有视觉样式（字号、颜色、布局）
  - 验收：结算页面所有文本通过 $r() 引用，中英文切换后标签文本正确更新，数值不变

---

## 9. GamePage 集成倒计时与国际化改造

> 依赖：任务6、任务7、任务8 | 优先级：高

- [ ] 修改 `products/default/src/main/ets/pages/GamePage.ets`，集成倒计时组件：
  - 引入 `CountdownOverlay` 和 `ResultOverlay` 组件
  - 新增 `@State isCountdownActive: boolean = false` 状态变量
  - 改造 `tryStartGame()`：不再直接启动游戏引擎，改为设置 `gameStarted=true` + `isCountdownActive=true`，启动倒计时
  - 新增 `onCountdownEnd()` 回调方法：倒计时结束后设置 `isCountdownActive=false`，执行原 `tryStartGame()` 中的引擎启动逻辑（解析路由参数、构建 GameConfig、调用 `engine.start()`、启动 drawTimer）
  - 在 `build()` 的 `Stack` 中添加 `CountdownOverlay` 组件，当 canvasReady 后自动调用 `countdownOverlay.start(this.onCountdownEnd.bind(this))`
  - 暂停按钮条件改为 `!this.isEnded && !this.isCountdownActive`（倒计时期间不显示暂停按钮）
  - 在 `aboutToDisappear()` 中添加倒计时清理逻辑（调用 `countdownOverlay.cancel()`）
  - 验收：游戏页面加载后先显示倒计时，倒计时结束后游戏引擎启动、音符下落、BGM播放；倒计时期间暂停按钮不可见

- [ ] 修改 `products/default/src/main/ets/pages/GamePage.ets`，替换结算区域为 ResultOverlay 组件：
  - 删除原有的结算遮罩内联代码（第253-295行的 Column 结算区域）
  - 替换为 `<ResultOverlay score={this.endScore} accuracy={this.endAccuracy} maxCombo={this.endMaxCombo} bestScore={this.endBestScore} isNewRecord={this.endIsNewRecord} />`
  - 验收：结算页面显示效果与改造前一致，所有文本支持双语切换

- [ ] 修改 `products/default/src/main/ets/pages/GamePage.ets`，HUD 区域国际化：
  - `'Score:'` → `$r('app.string.score_label')` + ': '
  - 暂停按钮文字：暂停时显示 `$r('app.string.resume_label')`，非暂停时显示 `$r('app.string.pause_label')`
  - 验收：HUD 区域文本通过 $r() 引用，中英文切换后正确更新

---

## 10. 异常场景与边界处理

> 依赖：任务7、任务9 | 优先级：中

- [ ] 倒计时期间用户返回处理：
  - 在 GamePage 的系统返回键拦截（`onBackPress()`）中，若 `isCountdownActive` 为 true，调用 `countdownOverlay.cancel()` 并返回关卡选择页
  - 验收：倒计时中按返回键，定时器清理，返回 SongSelectPage，游戏引擎未启动

- [ ] 倒计时期间应用切至后台/前台处理：
  - 在 CountdownOverlay 中记录倒计时暂停时间戳，应用 `onPageShow`/`onPageHide` 生命周期中暂停/恢复倒计时
  - 验收：切后台后回来，倒计时从离开时的数字继续

- [ ] 画布初始化延迟处理：
  - 确保 GamePage 中倒计时仅在 `canvasReady=true` 后才启动（在 `onReady` 回调中触发）
  - 验收：画布未就绪时不显示倒计时，就绪后立即开始

- [ ] 语言偏好读取失败降级：
  - LanguageManager.init() 中 Preferences 读取异常时，回退使用 `detectSystemLanguage()` 判定
  - 验收：Preferences 初始化失败时界面仍正常显示，语言为系统默认或中文回退

- [ ] 非支持语言默认回退中文：
  - `detectSystemLanguage()` 中对非 zh/en 系统语言一律返回 'zh'
  - 验收：系统语言为 ja_JP、ko_KR 等时，界面默认显示中文

---

## 11. 验证与测试

> 依赖：所有前置任务 | 优先级：最终

- [ ] 验证双语界面切换：
  - 首页点击语言切换按钮，确认中英文来回切换正常，界面文本实时更新
  - 确认语言切换按钮位于首页左上角，圆角矩形、透明填充、文字颜色与边框颜色一致
  - 确认中文模式按钮显示"中文"，英文模式按钮显示"EN"

- [ ] 验证关卡选择页国际化：
  - 切换语言后关卡标题显示对应翻译（牛刀小试↔Warm Up 等）
  - 难度标签切换（简单↔Easy、普通↔Normal、困难↔Hard）

- [ ] 验证游戏启动倒计时：
  - 选择关卡进入游戏页后显示 3→2→1→BEAT 倒计时动画
  - 倒计时期间点击游戏区域无击打判定
  - 倒计时期间暂停按钮不显示
  - 倒计时结束后游戏引擎启动、音符下落、BGM 播放
  - 中英文模式下 BEAT 均显示为 "BEAT"

- [ ] 验证结算页面双语显示：
  - 游戏结束后结算页面标签按语言偏好显示（结算↔Results、分数↔Score 等）
  - 新纪录标识按语言偏好显示（新纪录！↔NEW RECORD!）
  - 返回按钮按语言偏好显示（返回↔Back）
  - 数值（得分、准确率、连击）不随语言切换改变

- [ ] 验证语言偏好持久化：
  - 切换语言后关闭应用，重新启动后界面恢复上次选择的语言

- [ ] 验证资源文件词条完整性：
  - zh_CN、en_US、base 三份 string.json 的词条键集合完全一致

- [ ] 验证性能约束：
  - 语言切换后界面文本刷新延迟 ≤100ms
  - 倒计时动画流畅无卡顿
  - 倒计时各阶段时间间隔误差 ≤±50ms

- [ ] 验证首页深色背景一致性：
  - 首页背景色为 '#0D0D1A'，非系统浅色背景
  - 首页标题文字颜色为 '#FFFFFF'，在深色背景上清晰可读
  - 首页按钮文字颜色为 '#FFFFFF'，在深色背景上清晰可读
  - 首页与 SongSelectPage 背景色一致（均为 '#0D0D1A'），无视觉差异
  - 首页与 GamePage 背景色一致（均为 '#0D0D1A'），无视觉差异
  - 从首页跳转至关卡选择页/游戏页，背景色无跳变，过渡平滑
  - 语言切换按钮在深色背景上样式正确（圆角矩形、透明填充、文字颜色与边框颜色一致）
  - 首页所有文字与 '#0D0D1A' 背景的对比度均≥4.5:1（WCAG 2.1 AA 级标准）
