import router from '@ohos.router';
import { languageManager, themeManager } from '@ohos/common';
import { LanguageSwitchButton } from '../components/LanguageSwitchButton';
import { GearIconButton } from '../components/GearIconButton';
import { SettingsDialog } from '../components/SettingsDialog';
import { DarkAppearanceColors, LightAppearanceColors } from '@ohos/common';

@Entry
@Component
struct Index {
  @Provide currentLang: string = 'zh';
  @State appearanceMode: string = 'dark';
  @State chartColorMode: string = 'dark';
  @State showSettings: boolean = false;

  aboutToAppear(): void {
    languageManager.init(getContext(this));
    themeManager.init(getContext(this));
    this.currentLang = languageManager.getLanguage();
    this.appearanceMode = themeManager.getAppearanceMode();
    this.chartColorMode = themeManager.getChartColorMode();
  }

  private t(key: string): string {
    const _: string = this.currentLang;
    return languageManager.getText(key);
  }

  private colors() {
    return this.appearanceMode === 'light' ? LightAppearanceColors : DarkAppearanceColors;
  }

  build() {
    Stack() {
      Column() {
        Text(this.t('app_name'))
          .fontSize(32)
          .fontColor(this.colors().primaryText)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 24 })

        Button(this.t('start_game'))
          .fontSize(18)
          .width('60%')
          .height(48)
          .fontColor(this.colors().primaryText)
          .onClick(() => {
            router.pushUrl({ url: 'pages/SongSelectPage' });
          })
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .backgroundColor(this.colors().background)

      LanguageSwitchButton()
        .position({ x: 16, y: 16 })

      GearIconButton({
        iconColor: this.colors().primaryText,
        onGearClick: () => { this.showSettings = true; }
      })
        .position({ x: '100%', y: 16 })
        .translate({ x: -52 })

      if (this.showSettings) {
        SettingsDialog({
          appearanceMode: this.appearanceMode,
          chartColorMode: this.chartColorMode,
          currentLang: this.currentLang,
          primaryText: this.colors().primaryText,
          dialogBackground: this.colors().background,
          accentColor: this.colors().accent,
          onAppearanceChange: (mode: string) => {
            themeManager.setAppearanceMode(mode as 'dark' | 'light');
            this.appearanceMode = mode;
          },
          onChartColorChange: (mode: string) => {
            themeManager.setChartColorMode(mode as 'dark' | 'light');
            this.chartColorMode = mode;
          },
          onClose: () => { this.showSettings = false; }
        })
      }
    }
    .width('100%')
    .height('100%')
  }
}
