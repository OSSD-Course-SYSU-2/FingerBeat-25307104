import router from '@ohos.router';
import { languageManager } from '@ohos/common';

@Component
export struct ResultOverlay {
  @Prop score: number = 0;
  @Prop accuracy: number = 0;
  @Prop maxCombo: number = 0;
  @Prop bestScore: number = 0;
  @Prop isNewRecord: boolean = false;
  @Prop lang: string = 'zh';

  private t(key: string): string {
    const _: string = this.lang;
    return languageManager.getText(key);
  }

  build() {
    Column() {
      Text(this.t('result_title'))
        .fontSize(32)
        .fontColor('#FFFFFF')
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 16 })
      Text(`${this.t('score_label')}: ${this.score}`)
        .fontSize(24)
        .fontColor('#FFD700')
        .margin({ bottom: 8 })
      if (this.isNewRecord) {
        Text(this.t('new_record_full'))
          .fontSize(18)
          .fontColor('#FF4500')
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 8 })
      }
      Text(`${this.t('best_label')}: ${this.bestScore}`)
        .fontSize(20)
        .fontColor('#AAAAAA')
        .margin({ bottom: 8 })
      Text(`${this.t('accuracy_label')}: ${(this.accuracy * 100).toFixed(1)}%`)
        .fontSize(20)
        .fontColor('#FFFFFF')
        .margin({ bottom: 8 })
      Text(`${this.t('max_combo_label')}: ${this.maxCombo}`)
        .fontSize(20)
        .fontColor('#FFFFFF')
        .margin({ bottom: 24 })
      Button(this.t('back'))
        .fontSize(18)
        .width('60%')
        .height(48)
        .onClick(() => {
          router.back();
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#CC000000')
  }
}
