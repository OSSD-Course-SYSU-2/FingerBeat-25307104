import { languageManager } from '@ohos/common';

@Component
export struct SettingsDialog {
  @Prop appearanceMode: string = 'dark';
  @Prop chartColorMode: string = 'dark';
  @Prop currentLang: string = 'zh';
  @Prop primaryText: string = '#FFFFFF';
  @Prop dialogBackground: string = '#0D0D1A';
  @Prop accentColor: string = '#FFD700';
  onAppearanceChange: (mode: string) => void = () => {};
  onChartColorChange: (mode: string) => void = () => {};
  onClose: () => void = () => {};

  private t(key: string): string {
    const _: string = this.currentLang;
    return languageManager.getText(key);
  }

  @Builder
  buildOption(label: string, isSelected: boolean, onSelect: () => void) {
    Text(label)
      .fontSize(13)
      .fontColor(isSelected ? this.dialogBackground : this.primaryText)
      .fontWeight(FontWeight.Bold)
      .padding({ left: 12, right: 12, top: 5, bottom: 5 })
      .borderRadius(8)
      .borderWidth(1.5)
      .borderColor(this.primaryText)
      .backgroundColor(isSelected ? this.primaryText : Color.Transparent)
      .onClick(() => {
        onSelect();
      })
  }

  build() {
    Stack() {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('#80808080')
        .onClick(() => {
          this.onClose();
        })

      Column() {
        Row() {
          Text(this.t('settings_title'))
            .fontSize(18)
            .fontColor(this.primaryText)
            .fontWeight(FontWeight.Bold)
          Blank()
          Text('×')
            .fontSize(22)
            .fontColor(this.primaryText)
            .onClick(() => {
              this.onClose();
            })
        }
        .width('100%')
        .padding({ bottom: 16 })

        Row() {
          Text(this.t('appearance_label'))
            .fontSize(14)
            .fontColor(this.primaryText)
            .fontWeight(FontWeight.Bold)
          Blank()
          this.buildOption(this.t('dark_label'), this.appearanceMode === 'dark', () => {
            this.onAppearanceChange('dark');
          })
          this.buildOption(this.t('light_label'), this.appearanceMode === 'light', () => {
            this.onAppearanceChange('light');
          })
        }
        .width('100%')
        .margin({ bottom: 16 })

        Row() {
          Text(this.t('chart_color_label'))
            .fontSize(14)
            .fontColor(this.primaryText)
            .fontWeight(FontWeight.Bold)
          Blank()
          this.buildOption(this.t('dark_label'), this.chartColorMode === 'dark', () => {
            this.onChartColorChange('dark');
          })
          this.buildOption(this.t('light_label'), this.chartColorMode === 'light', () => {
            this.onChartColorChange('light');
          })
        }
        .width('100%')
      }
      .width('80%')
      .padding(20)
      .borderRadius(16)
      .backgroundColor(this.dialogBackground)
    }
    .width('100%')
    .height('100%')
  }
}
