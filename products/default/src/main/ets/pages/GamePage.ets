/**
 * GamePage - FingerBeat game play page.
 * Renders the rhythm game using GameEngine with Canvas.
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
const NOTE_HEIGHT: number = 20;

@Entry
@Component
struct GamePage {
  private engine: GameEngine = new GameEngine();

  @State score: number = 0;
  @State combo: number = 0;
  @State judgmentText: string = '';
  @State judgmentColor: string = '#FFFFFF';
  @State isPaused: boolean = false;
  @State isEnded: boolean = false;
  @State endScore: number = 0;
  @State endAccuracy: number = 0;
  @State endMaxCombo: number = 0;
  @State notes: RuntimeNote[] = [];

  private canvasWidth: number = 0;
  private canvasHeight: number = 0;
  private laneWidth: number = 0;
  private judgmentLineY: number = 0;
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(new RenderingContextSettings(true));

  aboutToDisappear(): void {
    this.engine.quit();
  }

  private startGame(): void {
    const songId: string = 'song1';
    const difficulty: Difficulty = Difficulty.Normal;
    const config: GameConfig = {
      songId: songId,
      difficulty: difficulty,
      laneCount: LANE_COUNT,
      scrollSpeed: gameConstants.DEFAULT_SETTINGS.scrollSpeed,
      musicVolume: gameConstants.DEFAULT_SETTINGS.musicVolume,
      sfxVolume: gameConstants.DEFAULT_SETTINGS.sfxVolume,
    };

    const uiUpdater: GameUIUpdaterImpl = new GameUIUpdaterImpl(this);
    this.engine.start(config, getContext(this), uiUpdater, this.canvasHeight);
  }

  build() {
    Stack() {
      // Game canvas
      Canvas(this.context)
        .width('100%')
        .height('100%')
        .onReady(() => {
          this.startGame();
        })
        .onAreaChange((_oldArea: Area, newArea: Area) => {
          this.canvasWidth = Number(newArea.width);
          this.canvasHeight = Number(newArea.height);
          this.laneWidth = this.canvasWidth / LANE_COUNT;
          this.judgmentLineY = this.canvasHeight * JUDGMENT_LINE_RATIO;
        })

      // HUD overlay
      Column() {
        // Top bar: score + combo
        Row() {
          Text(`Score: ${this.score}`)
            .fontSize(20)
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Bold)
            .layoutWeight(1)

          if (this.combo > 1) {
            Text(`${this.combo}x`)
              .fontSize(24)
              .fontColor('#FFD700')
              .fontWeight(FontWeight.Bold)
          }
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 8 })

        // Judgment display
        if (this.judgmentText !== '') {
          Text(this.judgmentText)
            .fontSize(28)
            .fontColor(this.judgmentColor)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 20 })
        }

        Blank()

        // Lane tap zones
        Row() {
          ForEach(Array.from({ length: LANE_COUNT }, (_v: undefined, i: number) => i), (laneIndex: number) => {
            Column()
              .width(`${100 / LANE_COUNT}%`)
              .height('100%')
              .backgroundColor('#1A1A2E')
              .borderWidth({ left: 0.5, right: 0.5 })
              .borderColor('#333366')
              .onClick(() => {
                if (!this.isPaused && !this.isEnded) {
                  this.engine.onLaneTap(laneIndex);
                }
              })
          }, (laneIndex: number) => `${laneIndex}`)
        }
        .width('100%')
        .height('30%')
      }
      .width('100%')
      .height('100%')

      // Pause button
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

      // Result overlay
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
    .backgroundColor('#0D0D1A')
  }

  /**
   * Redraw the canvas with current notes.
   */
  renderNotes(notes: RuntimeNote[]): void {
    const ctx = this.context;
    ctx.clearRect(0, 0, this.canvasWidth, this.canvasHeight);

    // Draw lane dividers
    ctx.strokeStyle = '#333366';
    ctx.lineWidth = 1;
    for (let i = 1; i < LANE_COUNT; i++) {
      const x = i * this.laneWidth;
      ctx.beginPath();
      ctx.moveTo(x, 0);
      ctx.lineTo(x, this.canvasHeight);
      ctx.stroke();
    }

    // Draw judgment line
    ctx.strokeStyle = '#FFFFFF';
    ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.moveTo(0, this.judgmentLineY);
    ctx.lineTo(this.canvasWidth, this.judgmentLineY);
    ctx.stroke();

    // Draw notes
    const noteWidth = this.laneWidth * NOTE_WIDTH_RATIO;
    const noteOffset = (this.laneWidth - noteWidth) / 2;

    for (const note of notes) {
      if (!note.isVisible) {
        continue;
      }
      const x = note.lane * this.laneWidth + noteOffset;
      const y = note.currentY - NOTE_HEIGHT / 2;

      // Color by type
      if (note.type === NoteType.TAP) {
        ctx.fillStyle = '#00BFFF';
      } else if (note.type === NoteType.HOLD) {
        ctx.fillStyle = '#FF6B6B';
      } else {
        ctx.fillStyle = '#FFD700';
      }

      if (note.isJudged) {
        ctx.globalAlpha = 0.3;
      } else {
        ctx.globalAlpha = 1.0;
      }

      ctx.fillRect(x, y, noteWidth, NOTE_HEIGHT);
      ctx.globalAlpha = 1.0;
    }
  }
}

/**
 * Concrete GameUIUpdater that delegates to GamePage state updates.
 */
class GameUIUpdaterImpl extends GameUIUpdater {
  private page: GamePage;

  constructor(page: GamePage) {
    super();
    this.page = page;
  }

  onNotesUpdate(notes: RuntimeNote[]): void {
    this.page.notes = notes;
    this.page.renderNotes(notes);
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

  onGameEnd(result: GameResult): void {
    this.page.isEnded = true;
    this.page.endScore = result.score;
    this.page.endAccuracy = result.accuracy;
    this.page.endMaxCombo = result.maxCombo;
  }
}
