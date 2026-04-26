/**
 * SongSelectPage - Song/level selection page.
 * Displays a scrollable list of available levels with difficulty selection and a back button.
 */
import router from '@ohos.router';
import { Difficulty } from '@ohos/game';

interface LevelItem {
  levelId: number;
  title: string;
  songId: string;
  hasBGM: boolean;
  description: string;
}

const LEVEL_LIST: LevelItem[] = [
  {
    levelId: 0,
    title: '牛刀小试',
    songId: 'song0',
    hasBGM: false,
    description: 'BPM 95 · 无BGM · 15s'
  },
  {
    levelId: 1,
    title: '星空旋律',
    songId: 'song1',
    hasBGM: false,
    description: 'BPM 120 · 无BGM · 20s'
  },
  {
    levelId: 2,
    title: '电子脉冲',
    songId: 'song2',
    hasBGM: false,
    description: 'BPM 140 · 无BGM · 25s'
  },
  {
    levelId: 3,
    title: '梦幻节拍',
    songId: 'song3',
    hasBGM: false,
    description: 'BPM 100 · 无BGM · 35s'
  }
];

const DIFFICULTY_LABELS: string[] = ['EASY', 'NORMAL', 'HARD'];
const DIFFICULTY_COLORS: string[] = ['#00FF00', '#FFD700', '#FF4500'];

@Entry
@Component
struct SongSelectPage {
  @State selectedDifficulty: number = 1; // 0=Easy, 1=Normal, 2=Hard

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

      // Global difficulty selector
      Row() {
        ForEach([0, 1, 2], (idx: number) => {
          Text(DIFFICULTY_LABELS[idx])
            .fontSize(14)
            .fontColor(this.selectedDifficulty === idx ? '#0D0D1A' : DIFFICULTY_COLORS[idx])
            .fontWeight(FontWeight.Bold)
            .padding({ left: 16, right: 16, top: 6, bottom: 6 })
            .borderRadius(4)
            .backgroundColor(this.selectedDifficulty === idx ? DIFFICULTY_COLORS[idx] : '#00000000')
            .borderWidth(1)
            .borderColor(DIFFICULTY_COLORS[idx])
            .margin({ left: idx === 0 ? 0 : 8, right: 0 })
            .onClick(() => {
              this.selectedDifficulty = idx;
            })
        }, (idx: number) => `${idx}`)
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .padding({ top: 8, bottom: 12 })

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

              // Difficulty badge on the right
              Text(DIFFICULTY_LABELS[this.selectedDifficulty])
                .fontSize(12)
                .fontColor(DIFFICULTY_COLORS[this.selectedDifficulty])
                .fontWeight(FontWeight.Bold)
                .padding({ left: 8, right: 8, top: 2, bottom: 2 })
                .borderRadius(4)
                .borderWidth(1)
                .borderColor(DIFFICULTY_COLORS[this.selectedDifficulty])
                .margin({ right: 8 })

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
                  difficulty: this.selectedDifficulty,
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
