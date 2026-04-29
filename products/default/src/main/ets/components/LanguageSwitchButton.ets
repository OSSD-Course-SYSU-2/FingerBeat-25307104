import { languageManager } from '@ohos/common';

@Component
export struct LanguageSwitchButton {
  @Consume currentLang: string;
  @Prop textColor: string = '#FFFFFF';

  build() {
    Text(this.currentLang === 'zh' ? '中文' : 'EN')
      .fontSize(14)
      .fontColor(this.textColor)
      .fontWeight(FontWeight.Bold)
      .padding({ left: 12, right: 12, top: 6, bottom: 6 })
      .borderRadius(8)
      .borderWidth(1.5)
      .borderColor(this.textColor)
      .backgroundColor(Color.Transparent)
      .onClick(() => {
        languageManager.toggleLanguage();
        this.currentLang = languageManager.getLanguage();
      })
  }
}
