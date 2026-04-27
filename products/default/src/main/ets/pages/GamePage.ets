import {
  GameEngine, GameUIUpdater, gameConstants,
  Difficulty, GameState, JudgmentGrade, RuntimeNote, GameResult, GameConfig,
  NoteType,
} from '@ohos/game';
import router from '@ohos.router';
import { languageManager } from '@ohos/common';
import { ResultOverlay } from '../components/ResultOverlay';

const LANE_COUNT: number = 4;
const JUDGMENT_LINE_RATIO: number = 0.85;
const NOTE_WIDTH_RATIO: number = 0.9;
const NOTE_HEIGHT: number = 24;
const DRAW_INTERVAL: number = 16;
const MAX_MISS_DISPLAY: number = 2;

interface MissEntry {
  lane: number;
  timestamp: number;
}

@Entry
@Component
struct GamePage {
  private engine: GameEngine = new GameEngine();
  private ctx: CanvasRenderingContext2D = new CanvasRenderingContext2D(new RenderingContextSettings(true));
  private w: number = 0;
  private h: number = 0;
  private laneW: number = 0;
  private judgY: number = 0;
  private drawTimerId: number = -1;
  private gameStarted: boolean = false;
  private canvasReady: boolean = false;
  latestNotes: RuntimeNote[] = [];
  private countdownTimerId: number = -1;
  private routerParams: Record<string, Object> | null = null;

  @State score: number = 0;
  @State combo: number = 0;
  @State judgmentText: string = '';
  @State judgmentColor: string = '#FFFFFF';
  @State missEntries: MissEntry[] = [];
  @State isPaused: boolean = false;
  @State isEnded: boolean = false;
  @State isCountdownActive: boolean = false;
  @State countdownDisplayText: string = '';
  @State currentLang: string = 'zh';
  @State endScore: number = 0;
  @State endAccuracy: number = 0;
  @State endMaxCombo: number = 0;
  @State endBestScore: number = 0;
  @State endIsNewRecord: boolean = false;

  aboutToAppear(): void {
    this.currentLang = languageManager.getLanguage();
  }

  private t(key: string): string {
    const _: string = this.currentLang;
    return languageManager.getText(key);
  }

  aboutToDisappear(): void {
    if (this.drawTimerId !== -1) {
      clearInterval(this.drawTimerId);
    }
    this.cancelCountdown();
    this.engine.quit();
  }

  private tryStartGame(): void {
    if (this.gameStarted || !this.canvasReady || this.h === 0) {
      return;
    }
    this.gameStarted = true;
    this.routerParams = router.getParams() as Record<string, Object>;
    this.startCountdown();
  }

  private startCountdown(): void {
    this.isCountdownActive = true;
    this.countdownDisplayText = '3';
    this.countdownTimerId = setTimeout(() => {
      this.countdownDisplayText = '2';
      this.countdownTimerId = setTimeout(() => {
        this.countdownDisplayText = '1';
        this.countdownTimerId = setTimeout(() => {
          this.countdownDisplayText = 'BEAT';
          this.countdownTimerId = setTimeout(() => {
            this.isCountdownActive = false;
            this.countdownDisplayText = '';
            this.countdownTimerId = -1;
            this.onCountdownEnd();
          }, 500);
        }, 1000);
      }, 1000);
    }, 1000);
  }

  private cancelCountdown(): void {
    if (this.countdownTimerId !== -1) {
      clearTimeout(this.countdownTimerId);
      this.countdownTimerId = -1;
    }
    this.isCountdownActive = false;
    this.countdownDisplayText = '';
  }

  private onCountdownEnd(): void {
    const params = this.routerParams;
    const songId: string = params !== null && params['songId'] !== undefined ? params['songId'] as string : 'song1';
    const difficulty: Difficulty = params !== null && params['difficulty'] !== undefined ? params['difficulty'] as Difficulty : Difficulty.Normal;
    const hasBGM: boolean = params !== null && params['hasBGM'] !== undefined ? params['hasBGM'] as boolean : true;

    const config: GameConfig = {
      songId: songId,
      difficulty: difficulty,
      laneCount: LANE_COUNT,
      scrollSpeed: gameConstants.DEFAULT_SETTINGS.scrollSpeed,
      musicVolume: gameConstants.DEFAULT_SETTINGS.musicVolume,
      sfxVolume: gameConstants.DEFAULT_SETTINGS.sfxVolume,
      hasBGM: hasBGM,
    };

    const uiUpdater: GameUIUpdaterImpl = new GameUIUpdaterImpl(this);
    this.engine.start(config, getContext(this), uiUpdater, this.h);

    this.drawTimerId = setInterval(() => {
      this.draw();
    }, DRAW_INTERVAL);
  }

  onBackPress(): boolean {
    if (this.isCountdownActive) {
      this.cancelCountdown();
      router.back();
      return true;
    }
    return false;
  }

  private draw(): void {
    if (this.w === 0 || this.h === 0) {
      return;
    }

    const c = this.ctx;
    c.clearRect(0, 0, this.w, this.h);

    c.fillStyle = '#0D0D1A';
    c.fillRect(0, 0, this.w, this.h);

    c.strokeStyle = '#333366';
    c.lineWidth = 1;
    for (let i = 1; i < LANE_COUNT; i++) {
      const x = i * this.laneW;
      c.beginPath();
      c.moveTo(x, 0);
      c.lineTo(x, this.h);
      c.stroke();
    }

    c.strokeStyle = '#FFFFFF';
    c.lineWidth = 3;
    c.beginPath();
    c.moveTo(0, this.judgY);
    c.lineTo(this.w, this.judgY);
    c.stroke();

    const noteW = this.laneW * NOTE_WIDTH_RATIO;
    const noteOff = (this.laneW - noteW) / 2;
    const notes = this.latestNotes;

    for (let i = 0; i < notes.length; i++) {
      const n = notes[i];
      if (!n.isVisible) {
        continue;
      }

      const x = n.lane * this.laneW + noteOff;
      const y = n.currentY - NOTE_HEIGHT / 2;

      if (n.type === NoteType.TAP) {
        c.fillStyle = '#00BFFF';
      } else if (n.type === NoteType.HOLD) {
        c.fillStyle = '#FF6B6B';
      } else {
        c.fillStyle = '#FFD700';
      }

      c.globalAlpha = n.isJudged ? 0.3 : 1.0;
      c.fillRect(x, y, noteW, NOTE_HEIGHT);
      c.globalAlpha = 1.0;
    }
  }

  build() {
    Stack() {
      Canvas(this.ctx)
        .width('100%')
        .height('100%')
        .onReady(() => {
          this.canvasReady = true;
          this.tryStartGame();
        })
        .onAreaChange((_old: Area, newArea: Area) => {
          this.w = Number(newArea.width);
          this.h = Number(newArea.height);
          this.laneW = this.w / LANE_COUNT;
          this.judgY = this.h * JUDGMENT_LINE_RATIO;
          this.tryStartGame();
        })

      Column() {
        Row() {
          Text(`${this.t('score_label')}: ${this.score}`)
            .fontSize(20)
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Bold)
          Blank()
          if (this.combo > 1) {
            Text(`${this.combo}x`)
              .fontSize(24)
              .fontColor('#FFD700')
              .fontWeight(FontWeight.Bold)
          }
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 8 })

        if (this.judgmentText !== '') {
          Text(this.judgmentText)
            .fontSize(28)
            .fontColor(this.judgmentColor)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 20 })
        }

        Blank()

        Row() {
          ForEach(Array.from({ length: LANE_COUNT }, (_v: undefined, i: number) => i), (idx: number) => {
            Column()
              .width(`${100 / LANE_COUNT}%`)
              .height('100%')
              .onClick(() => {
                if (!this.isPaused && !this.isEnded && !this.isCountdownActive) {
                  this.engine.onLaneTap(idx);
                }
              })
          }, (idx: number) => `${idx}`)
        }
        .width('100%')
        .height('30%')
      }
      .width('100%')
      .height('100%')
      .hitTestBehavior(HitTestMode.Transparent)

      if (this.missEntries.length > 0) {
        ForEach(this.missEntries, (entry: MissEntry) => {
          Text('MISS')
            .fontSize(28)
            .fontColor('#FF4500')
            .fontWeight(FontWeight.Bold)
            .markAnchor({ x: '50%', y: '50%' })
            .position({
              x: `${entry.lane * 25 + 12.5}%`,
              y: `${JUDGMENT_LINE_RATIO * 100 - 6}%`
            })
        }, (entry: MissEntry) => `${entry.timestamp}`)
      }

      if (!this.isEnded && !this.isCountdownActive) {
        Button(this.isPaused ? this.t('resume_label') : this.t('pause_label'))
          .fontSize(14)
          .width(60)
          .height(32)
          .position({ x: 8, y: 40 })
          .onClick(() => {
            if (this.isPaused) {
              this.engine.resume();
              this.isPaused = false;
            } else {
              this.engine.pause();
              this.isPaused = true;
            }
          })
      }

      if (this.isCountdownActive) {
        Stack() {
          Column()
            .width('100%')
            .height('100%')
            .backgroundColor('#80000000')
            .hitTestBehavior(HitTestMode.Block)

          Text(this.countdownDisplayText)
            .fontSize(72)
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Center)
        }
        .width('100%')
        .height('100%')
      }

      if (this.isEnded) {
        ResultOverlay({
          score: this.endScore,
          accuracy: this.endAccuracy,
          maxCombo: this.endMaxCombo,
          bestScore: this.endBestScore,
          isNewRecord: this.endIsNewRecord,
          lang: this.currentLang
        })
      }
    }
    .width('100%')
    .height('100%')
  }
}

class GameUIUpdaterImpl extends GameUIUpdater {
  private page: GamePage;

  constructor(page: GamePage) {
    super();
    this.page = page;
  }

  onNotesUpdate(notes: RuntimeNote[]): void {
    this.page.latestNotes = notes;
  }

  onScoreUpdate(score: number, _increment: number): void {
    this.page.score = score;
  }

  onComboUpdate(combo: number): void {
    this.page.combo = combo;
  }

  onJudgmentShow(grade: JudgmentGrade, lane: number): void {
    if (grade === JudgmentGrade.MISS) {
      const current = this.page.missEntries;
      const newEntry: MissEntry = { lane: lane, timestamp: Date.now() };
      if (current.length >= MAX_MISS_DISPLAY) {
        this.page.missEntries = [current[current.length - 1], newEntry];
      } else {
        this.page.missEntries = [...current, newEntry];
      }
      this.page.judgmentText = '';
    } else {
      this.page.judgmentText = gameConstants.getJudgmentLabel(grade);
      this.page.judgmentColor = gameConstants.getJudgmentColor(grade);
      this.page.missEntries = [];
    }
  }

  onGameEnd(result: GameResult, bestScore: number, isNewRecord: boolean): void {
    this.page.isEnded = true;
    this.page.endScore = result.score;
    this.page.endAccuracy = result.accuracy;
    this.page.endMaxCombo = result.maxCombo;
    this.page.endBestScore = bestScore;
    this.page.endIsNewRecord = isNewRecord;
  }
}
