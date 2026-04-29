import { languageManager, DarkAppearanceColors, LightAppearanceColors } from '@ohos/common';

@Component
struct RadioOption {
  @Prop label: string = '';
  @Prop isSelected: boolean = false;
  @Prop textColor: string = '#FFFFFF';
  onSelect: () => void = () => {};

  build() {
    Row() {
      Circle()
        .width(10)
        .height(10)
        .fill(this.isSelected ? '#007DFF' : Color.Transparent)
        .stroke(this.isSelected ? '#007DFF' : this.textColor)
        .strokeWidth(1)
        .margin({ right: 6 })
      Text(this.label)
        .fontSize(14)
        .fontColor(this.textColor)
        .fontWeight(this.isSelected ? FontWeight.Bold : FontWeight.Normal)
    }
    .margin({ left: '8%' })
    .onClick(() => {
      this.onSelect();
    })
  }
}

@Component
export struct SettingsDialog {
  @Link appearanceMode: string;
  @Link chartColorMode: string;
  @Prop currentLang: string = 'zh';
  onClose: () => void = () => {};

  private t(key: string): string {
    const _: string = this.currentLang;
    return languageManager.getText(key);
  }

  private colors() {
    return this.appearanceMode === 'light' ? LightAppearanceColors : DarkAppearanceColors;
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
            .fontColor(this.colors().primaryText)
            .fontWeight(FontWeight.Bold)
          Blank()
          Text('×')
            .fontSize(22)
            .fontColor(this.colors().primaryText)
            .onClick(() => {
              this.onClose();
            })
        }
        .width('100%')
        .padding({ bottom: 16 })

        Row() {
          Text(this.t('appearance_label'))
            .fontSize(14)
            .fontColor(this.colors().primaryText)
            .fontWeight(FontWeight.Bold)
            .width('35%')
          RadioOption({
            label: this.t('dark_label'),
            isSelected: this.appearanceMode === 'dark',
            textColor: this.colors().primaryText,
            onSelect: () => { this.appearanceMode = 'dark'; }
          })
          RadioOption({
            label: this.t('light_label'),
            isSelected: this.appearanceMode === 'light',
            textColor: this.colors().primaryText,
            onSelect: () => { this.appearanceMode = 'light'; }
          })
        }
        .width('100%')
        .margin({ bottom: 16 })

        Row() {
          Text(this.t('chart_color_label'))
            .fontSize(14)
            .fontColor(this.colors().primaryText)
            .fontWeight(FontWeight.Bold)
            .width('35%')
          RadioOption({
            label: this.t('dark_label'),
            isSelected: this.chartColorMode === 'dark',
            textColor: this.colors().primaryText,
            onSelect: () => { this.chartColorMode = 'dark'; }
          })
          RadioOption({
            label: this.t('light_label'),
            isSelected: this.chartColorMode === 'light',
            textColor: this.colors().primaryText,
            onSelect: () => { this.chartColorMode = 'light'; }
          })
        }
        .width('100%')
      }
      .width('80%')
      .padding(20)
      .borderRadius(16)
      .backgroundColor(this.colors().background)
    }
    .width('100%')
    .height('100%')
  }
}
