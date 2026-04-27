import router from '@ohos.router';
import { languageManager } from '@ohos/common';
import { LanguageSwitchButton } from '../components/LanguageSwitchButton';

@Entry
@Component
struct Index {
  @Provide currentLang: string = 'zh';

  aboutToAppear(): void {
    languageManager.init(getContext(this));
    this.currentLang = languageManager.getLanguage();
  }

  private t(key: string): string {
    const _: string = this.currentLang;
    return languageManager.getText(key);
  }

  build() {
    Stack() {
      Column() {
        Text(this.t('app_name'))
          .fontSize(32)
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 24 })

        Button(this.t('start_game'))
          .fontSize(18)
          .width('60%')
          .height(48)
          .fontColor('#FFFFFF')
          .onClick(() => {
            router.pushUrl({ url: 'pages/SongSelectPage' });
          })
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .backgroundColor('#0D0D1A')

      LanguageSwitchButton()
        .position({ x: 16, y: 16 })
    }
    .width('100%')
    .height('100%')
  }
}
