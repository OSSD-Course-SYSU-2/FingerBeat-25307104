/**
 * FingerBeat v1.3.0 - Game Engine
 * Core game loop controller that orchestrates all subsystems.
 */

import {
  GameState,
  GameConfig,
  GameResult,
  GameUIUpdater,
  GameEventType,
  JudgmentGrade,
  JudgmentWindows,
  RuntimeNote,
  Difficulty,
} from '../model/GameTypes';
import {
  GAME_LOOP_INTERVAL,
  BASE_SCROLL_SPEED,
  JUDGMENT_LINE_RATIO,
  gameConstants,
} from '../constants/GameConstants';
import { Logger } from '@ohos/common';
import JudgeSystem from './JudgeSystem';
import ScoreSystem from './ScoreSystem';
import NoteScheduler from './NoteScheduler';
import AudioPlayer from './AudioPlayer';
import { gameEventBus } from './GameEventBus';
import BeatmapRepository from '../data/BeatmapRepository';

class GameEngine {
  // Subsystems
  private judgeSystem: JudgeSystem | null = null;
  private scoreSystem: ScoreSystem | null = null;
  private noteScheduler: NoteScheduler | null = null;
  private audioPlayer: AudioPlayer | null = null;

  // UI callback
  private uiUpdater: GameUIUpdater | null = null;

  // Game state
  private state: GameState = GameState.IDLE;
  private loopTimerId: number = -1;
  private startTime: number = 0;
  private pausedTime: number = 0;
  private totalPauseDuration: number = 0;
  private screenHeight: number = 0;
  private config: GameConfig | null = null;
  private judgmentWindows: JudgmentWindows | null = null;

  /**
   * Start the game: initialize all subsystems, load beatmap, play BGM, start game loop.
   */
  async start(config: GameConfig, context: Context, uiUpdater: GameUIUpdater, screenHeight: number): Promise<void> {
    try {
      this.config = config;
      this.uiUpdater = uiUpdater;
      this.screenHeight = screenHeight;
      this.state = GameState.PLAYING;
      this.totalPauseDuration = 0;

      // Load beatmap
      const beatmap = BeatmapRepository.getBeatmap(config.songId, config.difficulty);
      if (beatmap === null) {
        Logger.error('GameEngine.start: beatmap not found');
        this.state = GameState.ENDED;
        return;
      }

      // Setup judgment windows
      const windowsConfig = gameConstants.getJudgmentWindows(config.difficulty);
      this.judgmentWindows = {
        perfectWindow: windowsConfig.perfect,
        greatWindow: windowsConfig.great,
        goodWindow: windowsConfig.good,
      };

      // Initialize subsystems
      this.judgeSystem = new JudgeSystem(this.judgmentWindows);
      this.scoreSystem = new ScoreSystem(beatmap.notes.length);

      const scrollSpeed = BASE_SCROLL_SPEED * config.scrollSpeed * gameConstants.getDifficultySpeedMultiplier(config.difficulty);
      const judgmentLineY = screenHeight * JUDGMENT_LINE_RATIO;
      this.noteScheduler = new NoteScheduler(scrollSpeed, judgmentLineY);
      this.noteScheduler.loadNotes(beatmap.notes);

      this.audioPlayer = new AudioPlayer();

      // Load and play BGM
      const song = BeatmapRepository.getSongById(config.songId);
      if (song !== null) {
        await this.audioPlayer.initBGM(song.audioFilePath, context);
        this.audioPlayer.setVolume(config.musicVolume);
        await this.audioPlayer.playBGM();
      }

      // Record start time
      this.startTime = Date.now();

      // Emit game started event
      gameEventBus.emit(GameEventType.GAME_STARTED);

      // Start game loop
      this.startGameLoop();

      Logger.info(`GameEngine.start: game started - ${config.songId} ${Difficulty[config.difficulty]}`);
    } catch (e) {
      Logger.error(`GameEngine.start: failed - ${e}`);
      this.state = GameState.ENDED;
    }
  }

  /**
   * Start the game loop using setInterval.
   */
  private startGameLoop(): void {
    this.loopTimerId = setInterval(() => {
      this.gameLoop();
    }, GAME_LOOP_INTERVAL);
  }

  /**
   * Main game loop: get time → update notes → detect MISS → callback UI → check end.
   */
  private gameLoop(): void {
    if (this.state !== GameState.PLAYING) {
      return;
    }

    const currentTime = this.getCurrentTime();

    // Update note positions and visibility
    if (this.noteScheduler !== null) {
      this.noteScheduler.update(currentTime, this.screenHeight);
    }

    // Check for missed notes
    if (this.noteScheduler !== null && this.judgeSystem !== null && this.scoreSystem !== null) {
      const goodWindow = this.judgmentWindows !== null ? this.judgmentWindows.goodWindow : 150;
      const missedIds = this.noteScheduler.checkMissedNotes(currentTime, goodWindow);

      for (const noteId of missedIds) {
        const increment = this.scoreSystem.onJudgment(JudgmentGrade.MISS);
        gameEventBus.emit(GameEventType.NOTE_MISSED);

        if (this.uiUpdater !== null) {
          this.uiUpdater.onJudgmentShow(JudgmentGrade.MISS, -1);
          this.uiUpdater.onScoreUpdate(this.scoreSystem.getScore(), increment);
          this.uiUpdater.onComboUpdate(this.scoreSystem.getCombo());
        }
      }
    }

    // Callback UI with updated notes
    if (this.uiUpdater !== null && this.noteScheduler !== null) {
      this.uiUpdater.onNotesUpdate(this.noteScheduler.getNotes());
    }

    // Check if game should end
    if (this.noteScheduler !== null && this.noteScheduler.areAllNotesJudged()) {
      this.endGame();
    }
  }

  /**
   * Handle lane tap: find nearest note → judge → score → SFX → callback UI.
   */
  onLaneTap(laneIndex: number): void {
    if (this.state !== GameState.PLAYING) {
      return;
    }
    if (this.judgeSystem === null || this.scoreSystem === null || this.noteScheduler === null) {
      return;
    }

    const currentTime = this.getCurrentTime();
    const goodWindow = this.judgmentWindows !== null ? this.judgmentWindows.goodWindow : 150;

    // Find nearest unjudged TAP note in this lane
    const nearestNote = this.judgeSystem.findNearestNote(
      laneIndex,
      currentTime,
      this.noteScheduler.getNotes(),
      goodWindow,
    );

    if (nearestNote === null) {
      return;
    }

    // Judge the time offset
    const timeOffset = currentTime - nearestNote.targetTime;
    const grade = this.judgeSystem.judge(timeOffset);

    // Mark note as judged
    this.noteScheduler.markNoteJudged(nearestNote.id);

    // Update score
    const increment = this.scoreSystem.onJudgment(grade);

    // Play SFX for non-MISS judgments
    if (grade !== JudgmentGrade.MISS && this.audioPlayer !== null) {
      this.audioPlayer.playSFX('tap');
    }

    // Emit events
    gameEventBus.emit(GameEventType.NOTE_JUDGED);
    gameEventBus.emit(GameEventType.SCORE_UPDATED);
    gameEventBus.emit(GameEventType.COMBO_CHANGED);

    // Callback UI
    if (this.uiUpdater !== null) {
      this.uiUpdater.onJudgmentShow(grade, laneIndex);
      this.uiUpdater.onScoreUpdate(this.scoreSystem.getScore(), increment);
      this.uiUpdater.onComboUpdate(this.scoreSystem.getCombo());
    }
  }

  /**
   * Pause the game loop and BGM.
   */
  pause(): void {
    if (this.state !== GameState.PLAYING) {
      return;
    }
    this.state = GameState.PAUSED;
    this.pausedTime = Date.now();

    if (this.loopTimerId !== -1) {
      clearInterval(this.loopTimerId);
      this.loopTimerId = -1;
    }

    if (this.audioPlayer !== null) {
      this.audioPlayer.pauseBGM();
    }

    gameEventBus.emit(GameEventType.GAME_PAUSED);
    Logger.info('GameEngine.pause: game paused');
  }

  /**
   * Resume the game loop and BGM.
   */
  resume(): void {
    if (this.state !== GameState.PAUSED) {
      return;
    }
    this.totalPauseDuration += (Date.now() - this.pausedTime);
    this.state = GameState.PLAYING;

    if (this.audioPlayer !== null) {
      this.audioPlayer.resumeBGM();
    }

    this.startGameLoop();
    gameEventBus.emit(GameEventType.GAME_RESUMED);
    Logger.info('GameEngine.resume: game resumed');
  }

  /**
   * End the game: generate result and callback UI.
   */
  endGame(): void {
    if (this.state === GameState.ENDED) {
      return;
    }
    this.state = GameState.ENDED;

    if (this.loopTimerId !== -1) {
      clearInterval(this.loopTimerId);
      this.loopTimerId = -1;
    }

    let result: GameResult | null = null;
    if (this.scoreSystem !== null) {
      result = this.scoreSystem.getResult();
    }

    if (this.uiUpdater !== null && result !== null) {
      this.uiUpdater.onGameEnd(result);
    }

    gameEventBus.emit(GameEventType.GAME_ENDED);
    Logger.info('GameEngine.endGame: game ended');
  }

  /**
   * Quit the game and release all resources.
   */
  async quit(): Promise<void> {
    this.endGame();

    if (this.audioPlayer !== null) {
      await this.audioPlayer.release();
      this.audioPlayer = null;
    }

    gameEventBus.clear();

    this.judgeSystem = null;
    this.scoreSystem = null;
    this.noteScheduler = null;
    this.uiUpdater = null;
    this.config = null;

    Logger.info('GameEngine.quit: all resources released');
  }

  /**
   * Get current game time in ms.
   */
  private getCurrentTime(): number {
    if (this.audioPlayer !== null) {
      const audioTime = this.audioPlayer.getCurrentTime();
      if (audioTime > 0) {
        return audioTime;
      }
    }
    return Date.now() - this.startTime - this.totalPauseDuration;
  }

  /**
   * Get current game state.
   */
  getState(): GameState {
    return this.state;
  }
}

export default GameEngine;
