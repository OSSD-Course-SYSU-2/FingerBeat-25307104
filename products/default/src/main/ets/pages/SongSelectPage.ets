import router from '@ohos.router';
import { Difficulty } from '@ohos/game';
import { languageManager, themeManager, DarkAppearanceColors, LightAppearanceColors } from '@ohos/common';
import { GearIconButton } from '../components/GearIconButton';
import { SettingsDialog } from '../components/SettingsDialog';

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

const DIFFICULTY_COLORS_DARK: string[] = ['#00FF00', '#FFD700', '#FF4500'];
const DIFFICULTY_COLORS_LIGHT: string[] = ['#2E8B57', '#C8960A', '#FF4500'];
const DIFFICULTY_KEYS: string[] = ['difficulty_easy', 'difficulty_normal', 'difficulty_hard'];

@Entry
@Component
struct SongSelectPage {
  @State selectedDifficulty: number = 1;
  @State currentLang: string = 'zh';
  @State appearanceMode: string = 'dark';
  @State chartColorMode: string = 'dark';
  @State showSettings: boolean = false;

  aboutToAppear(): void {
    this.syncFromManager();
  }

  onPageShow(): void {
    this.syncFromManager();
  }

  private syncFromManager(): void {
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

  private diffColors(): string[] {
    return this.appearanceMode === 'light' ? DIFFICULTY_COLORS_LIGHT : DIFFICULTY_COLORS_DARK;
  }

  private getLevelDescription(item: LevelItem): string {
    const noBgmText: string = this.t('no_bgm');
    const bgmPart: string = item.hasBGMFlag ? '' : ` · ${noBgmText}`;
    return `${item.descriptionBpm}${bgmPart} · ${item.duration}`;
  }

  build() {
    Stack() {
      Column() {
        Row() {
          Text('<')
            .fontSize(24)
            .fontColor(this.colors().primaryText)
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              router.back();
            })
          Blank()
          Text(this.t('song_select'))
            .fontSize(20)
            .fontColor(this.colors().primaryText)
            .fontWeight(FontWeight.Bold)
          Blank()
        }
        .width('100%')
        .height(56)
        .padding({ left: 16, right: 16 })
        .alignItems(VerticalAlign.Center)

        Row() {
          ForEach([0, 1, 2], (idx: number) => {
            Text(this.t(DIFFICULTY_KEYS[idx]))
              .fontSize(14)
              .fontColor(this.selectedDifficulty === idx ? '#0D0D1A' : this.diffColors()[idx])
              .fontWeight(FontWeight.Bold)
              .padding({ left: 16, right: 16, top: 6, bottom: 6 })
              .borderRadius(4)
              .backgroundColor(this.selectedDifficulty === idx ? this.diffColors()[idx] : '#00000000')
              .borderWidth(1)
              .borderColor(this.diffColors()[idx])
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
                  .fontColor(this.colors().accent)
                  .fontWeight(FontWeight.Bold)
                  .width(36)
                  .height(36)
                  .textAlign(TextAlign.Center)
                  .borderRadius(18)
                  .backgroundColor(this.colors().levelBadgeBg)
                  .margin({ right: 16 })

                Column() {
                  Text(this.t(item.titleKey))
                    .fontSize(18)
                    .fontColor(this.colors().primaryText)
                    .fontWeight(FontWeight.Bold)
                  Text(this.getLevelDescription(item))
                    .fontSize(13)
                    .fontColor(this.colors().secondaryText)
                    .margin({ top: 4 })
                }
                .alignItems(HorizontalAlign.Start)

                Blank()

                Text(this.t(DIFFICULTY_KEYS[this.selectedDifficulty]))
                  .fontSize(12)
                  .fontColor(this.diffColors()[this.selectedDifficulty])
                  .fontWeight(FontWeight.Bold)
                  .padding({ left: 8, right: 8, top: 2, bottom: 2 })
                  .borderRadius(4)
                  .borderWidth(1)
                  .borderColor(this.diffColors()[this.selectedDifficulty])
                  .margin({ right: 8 })

                Text('>')
                  .fontSize(20)
                  .fontColor(this.colors().arrowColor)
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
        .divider({ strokeWidth: 1, color: this.colors().divider, startMargin: 68, endMargin: 16 })
      }
      .width('100%')
      .height('100%')
      .backgroundColor(this.colors().background)

      GearIconButton({
        iconColor: this.colors().primaryText,
        onGearClick: () => { this.showSettings = true; }
      })
        .position({ x: '88%', y: 16 })

      if (this.showSettings) {
        SettingsDialog({
          appearanceMode: $appearanceMode,
          chartColorMode: $chartColorMode,
          currentLang: this.currentLang,
          onClose: () => {
            themeManager.setAppearanceMode(this.appearanceMode as 'dark' | 'light');
            themeManager.setChartColorMode(this.chartColorMode as 'dark' | 'light');
            this.showSettings = false;
          }
        })
      }
    }
    .width('100%')
    .height('100%')
  }
}
