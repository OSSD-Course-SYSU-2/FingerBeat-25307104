# FingerBeat v1.3.2 编码任务规划

## 1. 基础设施层：配色方案定义与外观管理器

- [ ] 创建 `common/src/main/ets/constants/ColorScheme.ets`，定义 `AppearanceColors` 和 `ChartColors` 接口，以及深色/浅色外观配色常量（`DarkAppearanceColors`、`LightAppearanceColors`）和深色/浅色谱面颜色常量（`DarkChartColors`、`LightChartColors`），包含所有色值属性
  - 验收：四个配色常量对象完整定义，色值与 design.md 中色值定义表一致
  - 涉及文件：`common/src/main/ets/constants/ColorScheme.ets`（新建）

- [ ] 创建 `common/src/main/ets/utils/ThemeManager.ets`，实现外观模式与谱面颜色偏好的读写、切换、持久化，配色方案分发
  - 实现 `init(context)` 从 Preferences 读取偏好，默认深色
  - 实现 `getAppearanceMode()` / `setAppearanceMode(mode)` 并持久化
  - 实现 `getChartColorMode()` / `setChartColorMode(mode)` 并持久化
  - 实现 `getAppearanceColors()` / `getChartColors()` 根据 mode 返回对应配色
  - 持久化键：`appearance_mode` / `chart_color`，Store：`fingerbeat_settings`
  - 读取失败安全降级为深色默认值，保存失败不崩溃
  - 导出单例 `themeManager`
  - 验收：可读写偏好并持久化，配色分发正确
  - 涉及文件：`common/src/main/ets/utils/ThemeManager.ets`（新建）

- [ ] 更新 `common/Index.ets`，导出 `themeManager` 和 ColorScheme 相关类型（`AppearanceMode`、`ChartColorMode`、`AppearanceColors`、`ChartColors`）
  - 验收：其他模块可通过 `@ohos/common` 导入 ThemeManager 和 ColorScheme 类型
  - 涉及文件：`common/Index.ets`

## 2. 翻译词条扩展

- [ ] 在 `common/src/main/ets/utils/LanguageManager.ets` 的 `TRANSLATIONS` 对象中新增 5 个翻译词条
  - 中文：`settings_title`→设置、`appearance_label`→外观模式、`chart_color_label`→谱面颜色、`dark_label`→深色、`light_label`→浅色
  - 英文：`settings_title`→Settings、`appearance_label`→Appearance、`chart_color_label`→Chart Color、`dark_label`→Dark、`light_label`→Light
  - 验收：`languageManager.getText('settings_title')` 等可正确返回对应语言文本
  - 涉及文件：`common/src/main/ets/utils/LanguageManager.ets`

## 3. UI 组件：齿轮图标与设置弹窗

- [ ] 创建 `products/default/src/main/ets/components/GearIconButton.ets`，实现极简描边轮廓齿轮图标组件
  - 使用 `Shape` + `Path` 绘制 6 齿简笔齿轮，仅描边无填充
  - 属性：`iconColor`（描边色，由父组件传入）、`onGearClick`（点击回调）
  - 尺寸 24x24，描边宽度 1.5，外层 36x36 可点击区域
  - 验收：图标正确渲染，点击触发回调
  - 涉及文件：`products/default/src/main/ets/components/GearIconButton.ets`（新建）

- [ ] 创建 `products/default/src/main/ets/components/SettingsDialog.ets`，实现设置弹窗组件
  - 属性：`appearanceMode`、`chartColorMode`、`currentLang`、`primaryText`、`onAppearanceChange`、`onChartColorChange`、`onClose`
  - 布局：半透明遮罩 `#80808080` + 圆角矩形弹窗主体（宽度 80%、圆角 16、内边距 20）
  - 标题栏 + 关闭按钮（叉号 ×）
  - "外观模式"标签 + 深色/浅色选项（圆角矩形样式：未选中=透明填充+描边文字；选中=填充背景色+对比文字色）
  - "谱面颜色"标签 + 深色/浅色选项（同上样式）
  - 选项使用 LanguageManager 翻译词条
  - 验收：弹窗正确渲染，切换选项触发回调，样式与 LanguageSwitchButton 风格一致
  - 涉及文件：`products/default/src/main/ets/components/SettingsDialog.ets`（新建）

## 4. Bug 修正：准确率显示、暂停按钮宽度、倒计时遮罩

- [ ] 修正 `ResultOverlay.ets` 第 40 行准确率显示公式，移除双重百分比转换
  - 将 `${(this.accuracy * 100).toFixed(1)}%` 改为 `${this.accuracy.toFixed(1)}%`
  - 验收：accuracy 为 85.5 时显示 "85.5%" 而非 "8550.0%"
  - 涉及文件：`products/default/src/main/ets/components/ResultOverlay.ets`

- [ ] 修正 `GamePage.ets` 暂停/继续按钮宽度，从 60 调整为 72
  - 验收：英文 "Resume" 完整显示无截断
  - 涉及文件：`products/default/src/main/ets/pages/GamePage.ets`（第 277 行 `.width(60)` → `.width(72)`）

- [ ] 修正 `GamePage.ets` 倒计时遮罩色值
  - 将 `.backgroundColor('#80000000')` 改为 `.backgroundColor('#80808080')`（中灰色 50% 不透明度）
  - 验收：倒计时遮罩为中灰色半透明，非纯黑半透明
  - 涉及文件：`products/default/src/main/ets/pages/GamePage.ets`（第 296 行）

## 5. 页面集成：Index 首页外观模式适配与齿轮图标

- [ ] 改造 `Index.ets`，接入 ThemeManager 外观配色 + 新增齿轮图标与设置弹窗
  - 初始化 `themeManager.init(getContext(this))`（在 `aboutToAppear` 中调用）
  - 新增 `@State appearanceMode` / `@State chartColorMode` 状态，从 ThemeManager 读取初始值
  - 将背景色 `#0D0D1A` 替换为 `themeManager.getAppearanceColors().background`
  - 将主文字色 `#FFFFFF` 替换为 `themeManager.getAppearanceColors().primaryText`
  - 将按钮文字色 `#FFFFFF` 替换为外观配色
  - LanguageSwitchButton 的 fontColor/borderColor 也跟随外观配色
  - 右上角新增 `GearIconButton`，点击弹出 `SettingsDialog`
  - 设置弹窗回调中更新状态并调用 ThemeManager setter
  - 验收：深色外观与现有一致，浅色外观即时切换生效，齿轮图标可打开设置弹窗
  - 涉及文件：`products/default/src/main/ets/pages/Index.ets`

## 6. 页面集成：SongSelectPage 曲目选择页外观模式适配与齿轮图标

- [ ] 改造 `SongSelectPage.ets`，接入 ThemeManager 外观配色 + 新增齿轮图标与设置弹窗
  - 初始化 `themeManager.init(getContext(this))`（在 `aboutToAppear` 中调用）
  - 新增 `@State appearanceMode` / `@State chartColorMode` 状态
  - 替换所有硬编码色值：背景 `#0D0D1A`、主文字 `#FFFFFF`、次文字 `#AAAAAA`、分割线 `#333366`、金色 `#FFD700`、关卡编号背景 `#333366`、箭头 `#666699` → 从 `themeManager.getAppearanceColors()` 获取
  - 右上角新增 `GearIconButton`，点击弹出 `SettingsDialog`
  - 验收：浅色外观下所有文字/背景/装饰元素正确渲染，对比度满足 WCAG 2.1
  - 涉及文件：`products/default/src/main/ets/pages/SongSelectPage.ets`

## 7. 页面集成：GamePage 游戏页面谱面颜色适配与齿轮图标

- [ ] 改造 `GamePage.ets`，接入 ThemeManager 谱面颜色配色 + 新增齿轮图标与设置弹窗
  - 初始化 `themeManager.init(getContext(this))`
  - 新增 `@State appearanceMode` / `@State chartColorMode` 状态
  - `draw()` 方法中所有硬编码色值替换为 `themeManager.getChartColors()` 对应属性
    - 背景 `#0D0D1A` → chartColors.background
    - 轨道线 `#333366` → chartColors.laneLine
    - 判定线 `#FFFFFF` → chartColors.judgmentLine
    - TAP 音符 `#00BFFF` → chartColors.tapNote
    - HOLD 音符 `#FF6B6B` → chartColors.holdNote
    - SLIDE 音符 `#FFD700` → chartColors.slideNote
  - HUD 文字色（分数、连击、判定）从 chartColors 获取
  - MISS 文字色从 chartColors.missText 获取
  - 暂停按钮背景色/文字色从 chartColors 获取
  - 倒计时文字色适配谱面颜色（深色谱面用白色文字，浅色谱面用深色文字）
  - 右上角新增 `GearIconButton`（倒计时/结算期间不显示，与暂停按钮逻辑一致）
  - 点击齿轮图标：暂停游戏引擎 + 弹出 SettingsDialog；关闭弹窗：恢复游戏引擎
  - 验收：深色谱面与现有一致，浅色谱面即时切换生效，齿轮图标可暂停游戏并打开设置弹窗
  - 涉及文件：`products/default/src/main/ets/pages/GamePage.ets`

## 8. 页面集成：ResultOverlay 结算界面外观配色适配

- [ ] 改造 `ResultOverlay.ets`，接入 ThemeManager 外观配色
  - 新增 `@Prop primaryText` / `@Prop accentColor` / `@Prop secondaryText` / `@Prop background` 等配色属性（由 GamePage 传入）
  - 替换硬编码色值：标题 `#FFFFFF`、分数 `#FFD700`、新纪录 `#FF4500`、最佳 `#AAAAAA`、背景 `#CC000000`
  - 验收：结算界面在不同外观模式下正确显示配色
  - 涉及文件：`products/default/src/main/ets/components/ResultOverlay.ets`

## 9. 验证与测试

- [ ] 验证准确率显示修正：模拟 accuracy=85.5，确认显示 "85.5%"
- [ ] 验证暂停按钮宽度：切换英文语言，确认 "Resume" 完整显示
- [ ] 验证倒计时遮罩：进入游戏页面，确认遮罩为中灰色半透明
- [ ] 验证外观模式切换：在首页/曲目选择页切换深色↔浅色，确认即时生效且所有色值正确
- [ ] 验证谱面颜色切换：在游戏页面切换深色↔浅色，确认即时生效且所有色值正确
- [ ] 验证外观与谱面独立性：切换外观模式后进入游戏页面，谱面颜色不受影响；反之亦然
- [ ] 验证偏好持久化：切换设置后重启应用，确认偏好恢复
- [ ] 验证齿轮图标与设置弹窗：在三个页面点击齿轮图标，确认弹窗正常弹出/关闭
- [ ] 验证游戏页面设置弹窗暂停逻辑：游戏中打开设置弹窗，确认游戏暂停；关闭弹窗，确认游戏恢复
