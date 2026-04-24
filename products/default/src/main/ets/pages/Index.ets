/**
 * Index is the entry of application.
 * Main menu page with app title and start button.
 */
import router from '@ohos.router';

@Entry
@Component
struct Index {
  build() {
    Column() {
      Text('FingerBeat')
        .fontSize(32)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 24 })

      Button('开始游戏')
        .fontSize(18)
        .width('60%')
        .height(48)
        .onClick(() => {
          router.pushUrl({ url: 'pages/GamePage' });
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
  }
}
