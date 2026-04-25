/**
 * GamePage - FingerBeat game play page.
 * Uses Canvas for game rendering with a separate draw timer.
 */
import {
  GameEngine, GameUIUpdater, gameConstants,
  Difficulty, GameState, JudgmentGrade, RuntimeNote, GameResult, GameConfig,
  NoteType,
} from '@ohos/game';
import router from '@ohos.router';

const LANE_COUNT: number = 4;
const JUDGMENT_LINE_RATIO: number = 0.85;
const NOTE_WIDTH_RATIO: number = 0.9;
const NOTE_HEIGHT: number = 24;
const DRAW_INTERVAL: number = 16; // ~60fps

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

  @State score: number = 0;
  @State combo: number = 0;
  @State judgmentText: string = '';
  @State judgmentColor: string = '#FFFFFF';
  @State isPaused: boolean = false;
  @State isEnded: boolean = false;
  @State endScore: number = 0;
  @State endAccuracy: number = 0;
  @State endMaxCombo: number = 0;
  @State endBestScore: number = 0;
  @State endIsNewRecord: boolean = false;

  aboutToDisappear(): void {
    if (this.drawTimerId !== -1) {
      clearInterval(this.drawTimerId);
    }
    this.engine.quit();
  }

  private tryStartGame(): void {
    // Only start when both canvas is ready AND we have valid screen dimensions
    if (this.gameStarted || !this.canvasReady || this.h === 0) {
      return;
    }
    this.gameStarted = true;

    const config: GameConfig = {
      songId: 'song1',
      difficulty: Difficulty.Normal,
      laneCount: LANE_COUNT,
      scrollSpeed: gameConstants.DEFAULT_SETTINGS.scrollSpeed,
      musicVolume: gameConstants.DEFAULT_SETTINGS.musicVolume,
      sfxVolume: gameConstants.DEFAULT_SETTINGS.sfxVolume,
    };

    const uiUpdater: GameUIUpdaterImpl = new GameUIUpdaterImpl(this);
    this.engine.start(config, getContext(this), uiUpdater, this.h);

    // Start independent draw loop
    this.drawTimerId = setInterval(() => {
      this.draw();
    }, DRAW_INTERVAL);
  }

  private draw(): void {
    if (this.w === 0 || this.h === 0) {
      return;
    }

    const c = this.ctx;
    c.clearRect(0, 0, this.w, this.h);

    // Background
    c.fillStyle = '#0D0D1A';
    c.fillRect(0, 0, this.w, this.h);

    // Lane dividers
    c.strokeStyle = '#333366';
    c.lineWidth = 1;
    for (let i = 1; i < LANE_COUNT; i++) {
      const x = i * this.laneW;
      c.beginPath();
      c.moveTo(x, 0);
      c.lineTo(x, this.h);
      c.stroke();
    }

    // Judgment line
    c.strokeStyle = '#FFFFFF';
    c.lineWidth = 3;
    c.beginPath();
    c.moveTo(0, this.judgY);
    c.lineTo(this.w, this.judgY);
    c.stroke();

    // Notes
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
      // Canvas - renders the game field
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

      // HUD overlay - fully transparent, click-through
      Column() {
        // Score bar
        Row() {
          Text(`Score: ${this.score}`)
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

        // Judgment text
        if (this.judgmentText !== '') {
          Text(this.judgmentText)
            .fontSize(28)
            .fontColor(this.judgmentColor)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 20 })
        }

        Blank()

        // Tap zones at bottom
        Row() {
          ForEach(Array.from({ length: LANE_COUNT }, (_v: undefined, i: number) => i), (idx: number) => {
            Column()
              .width(`${100 / LANE_COUNT}%`)
              .height('100%')
              .onClick(() => {
                if (!this.isPaused && !this.isEnded) {
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

      // Pause
      if (!this.isEnded) {
        Button(this.isPaused ? '继续' : '暂停')
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

      // Result
      if (this.isEnded) {
        Column() {
          Text('游戏结束')
            .fontSize(32)
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 16 })
          Text(`Score: ${this.endScore}`)
            .fontSize(24)
            .fontColor('#FFD700')
            .margin({ bottom: 8 })
          if (this.endIsNewRecord) {
            Text('新纪录!')
              .fontSize(18)
              .fontColor('#FF4500')
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 8 })
          }
          Text(`Best: ${this.endBestScore}`)
            .fontSize(20)
            .fontColor('#AAAAAA')
            .margin({ bottom: 8 })
          Text(`Accuracy: ${(this.endAccuracy * 100).toFixed(1)}%`)
            .fontSize(20)
            .fontColor('#FFFFFF')
            .margin({ bottom: 8 })
          Text(`Max Combo: ${this.endMaxCombo}`)
            .fontSize(20)
            .fontColor('#FFFFFF')
            .margin({ bottom: 24 })
          Button('返回主页')
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

  onJudgmentShow(grade: JudgmentGrade, _lane: number): void {
    this.page.judgmentText = gameConstants.getJudgmentLabel(grade);
    this.page.judgmentColor = gameConstants.getJudgmentColor(grade);
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
