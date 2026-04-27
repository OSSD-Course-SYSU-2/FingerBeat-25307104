import router from '@ohos.router';
import { Difficulty } from '@ohos/game';
import { languageManager } from '@ohos/common';

interface LevelItem {
  levelId: number;
  titleKey: string;
  songId: string;
  hasBGM: boolean;
  descriptionBpm: string;
  hasBGMFlag: boolean;
  duration: string;
}

const LEVEL_LIST: LevelItem[] = [
  {
    levelId: 0,
    titleKey: 'level_warm_up',
    songId: 'song0',
    hasBGM: false,
    descriptionBpm: 'BPM 95',
    hasBGMFlag: false,
    duration: '15s'
  },
  {
    levelId: 1,
    titleKey: 'level_starry_melody',
    songId: 'song1',
    hasBGM: false,
    descriptionBpm: 'BPM 120',
    hasBGMFlag: false,
    duration: '20s'
  },
  {
    levelId: 2,
    titleKey: 'level_electro_pulse',
    songId: 'song2',
    hasBGM: false,
    descriptionBpm: 'BPM 140',
    hasBGMFlag: false,
    duration: '25s'
  },
  {
    levelId: 3,
    titleKey: 'level_dream_beat',
    songId: 'song3',
    hasBGM: false,
    descriptionBpm: 'BPM 100',
    hasBGMFlag: false,
    duration: '35s'
  }
];

const DIFFICULTY_COLORS: string[] = ['#00FF00', '#FFD700', '#FF4500'];
const DIFFICULTY_KEYS: string[] = ['difficulty_easy', 'difficulty_normal', 'difficulty_hard'];

@Entry
@Component
struct SongSelectPage {
  @State selectedDifficulty: number = 1;
  @State currentLang: string = 'zh';

  aboutToAppear(): void {
    this.currentLang = languageManager.getLanguage();
  }

  private t(key: string): string {
    const _: string = this.currentLang;
    return languageManager.getText(key);
  }

  private getLevelDescription(item: LevelItem): string {
    const noBgmText: string = this.t('no_bgm');
    const bgmPart: string = item.hasBGMFlag ? '' : ` · ${noBgmText}`;
    return `${item.descriptionBpm}${bgmPart} · ${item.duration}`;
  }

  build() {
    Column() {
      Row() {
        Text('<')
          .fontSize(24)
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            router.back();
          })
        Blank()
        Text(this.t('song_select'))
          .fontSize(20)
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Bold)
        Blank()
        Text('<')
          .fontSize(24)
          .fontColor('#00000000')
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .alignItems(VerticalAlign.Center)

      Row() {
        ForEach([0, 1, 2], (idx: number) => {
          Text(this.t(DIFFICULTY_KEYS[idx]))
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

      List() {
        ForEach(LEVEL_LIST, (item: LevelItem) => {
          ListItem() {
            Row() {
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

              Column() {
                Text(this.t(item.titleKey))
                  .fontSize(18)
                  .fontColor('#FFFFFF')
                  .fontWeight(FontWeight.Bold)
                Text(this.getLevelDescription(item))
                  .fontSize(13)
                  .fontColor('#AAAAAA')
                  .margin({ top: 4 })
              }
              .alignItems(HorizontalAlign.Start)

              Blank()

              Text(this.t(DIFFICULTY_KEYS[this.selectedDifficulty]))
                .fontSize(12)
                .fontColor(DIFFICULTY_COLORS[this.selectedDifficulty])
                .fontWeight(FontWeight.Bold)
                .padding({ left: 8, right: 8, top: 2, bottom: 2 })
                .borderRadius(4)
                .borderWidth(1)
                .borderColor(DIFFICULTY_COLORS[this.selectedDifficulty])
                .margin({ right: 8 })

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
