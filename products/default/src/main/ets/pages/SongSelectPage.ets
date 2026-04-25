/**
 * SongSelectPage - Song/level selection page.
 * Displays a scrollable list of available levels with a back button.
 */
import router from '@ohos.router';
import { Difficulty } from '@ohos/game';

interface LevelItem {
  levelId: number;
  title: string;
  songId: string;
  difficulty: Difficulty;
  hasBGM: boolean;
  description: string;
}

const LEVEL_LIST: LevelItem[] = [
  {
    levelId: 0,
    title: '牛刀小试',
    songId: 'song1',
    difficulty: Difficulty.Normal,
    hasBGM: false,
    description: '无BGM · 纯击打练习'
  },
  {
    levelId: 1,
    title: '星空旋律',
    songId: 'song1',
    difficulty: Difficulty.Normal,
    hasBGM: true,
    description: 'BPM 120 · 30s'
  },
  {
    levelId: 2,
    title: '电子脉冲',
    songId: 'song2',
    difficulty: Difficulty.Normal,
    hasBGM: true,
    description: 'BPM 140 · 25s'
  },
  {
    levelId: 3,
    title: '梦幻节拍',
    songId: 'song3',
    difficulty: Difficulty.Normal,
    hasBGM: true,
    description: 'BPM 100 · 35s'
  }
];

@Entry
@Component
struct SongSelectPage {
  build() {
    Column() {
      // Top bar with back arrow
      Row() {
        Text('<')
          .fontSize(24)
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            router.back();
          })
        Blank()
        Text($r('app.string.song_select'))
          .fontSize(20)
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Bold)
        Blank()
        // Spacer to center the title
        Text('<')
          .fontSize(24)
          .fontColor('#00000000')
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .alignItems(VerticalAlign.Center)

      // Scrollable level list
      List() {
        ForEach(LEVEL_LIST, (item: LevelItem) => {
          ListItem() {
            Row() {
              // Level number badge
              Text(`${item.levelId}`)
                .fontSize(20)
                .fontColor('#FFD700')
                .fontWeight(FontWeight.Bold)
                .width(36)
                .height(36)
                .textAlign(TextAlign.Center)
                .borderRadius(18)
                .backgroundColor('#333366')
                .margin({ right: 16 })

              // Level info
              Column() {
                Text(item.title)
                  .fontSize(18)
                  .fontColor('#FFFFFF')
                  .fontWeight(FontWeight.Bold)
                Text(item.description)
                  .fontSize(13)
                  .fontColor('#AAAAAA')
                  .margin({ top: 4 })
              }
              .alignItems(HorizontalAlign.Start)

              Blank()

              // Play arrow
              Text('>')
                .fontSize(20)
                .fontColor('#666699')
            }
            .width('100%')
            .height(72)
            .padding({ left: 16, right: 16 })
            .alignItems(VerticalAlign.Center)
            .onClick(() => {
              router.pushUrl({
                url: 'pages/GamePage',
                params: {
                  songId: item.songId,
                  difficulty: item.difficulty,
                  hasBGM: item.hasBGM,
                  levelId: item.levelId
                }
              });
            })
          }
        }, (item: LevelItem) => `${item.levelId}`)
      }
      .width('100%')
      .layoutWeight(1)
      .divider({ strokeWidth: 1, color: '#333366', startMargin: 68, endMargin: 16 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#0D0D1A')
  }
}
