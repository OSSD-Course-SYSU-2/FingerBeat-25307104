/**
 * FingerBeat v1.3.0 - Game Types
 * All type definitions, enums, and interfaces for the game core module.
 */

// ==================== Enums ====================

export enum GameState {
  IDLE,
  PLAYING,
  PAUSED,
  ENDED
}

export enum JudgmentGrade {
  PERFECT,
  GREAT,
  GOOD,
  MISS
}

export enum LetterGrade {
  S,
  A,
  B,
  C,
  D
}

export enum Difficulty {
  Easy,
  Normal,
  Hard
}

export enum NoteType {
  TAP,
  HOLD,
  SLIDE
}

export enum SongSource {
  BUILTIN,
  OFFICIAL_UPDATE,
  PLAYER_IMPORT
}

export enum GameEventType {
  NOTE_JUDGED,
  COMBO_CHANGED,
  SCORE_UPDATED,
  GAME_STARTED,
  GAME_PAUSED,
  GAME_RESUMED,
  GAME_ENDED,
  NOTE_MISSED,
  FULL_COMBO
}

export enum GameMode {
  SINGLE,
  MULTI_VERSUS,
  MULTI_COOP
}

export enum RoomStatus {
  WAITING,
  PLAYING,
  FINISHED
}

// ==================== Interfaces ====================

export interface NoteData {
  id: string;
  lane: number;
  targetTime: number;
  type: NoteType;
  holdDuration?: number;
  endLane?: number;
}

export interface RuntimeNote extends NoteData {
  currentY: number;
  isJudged: boolean;
  isVisible: boolean;
  holdProgress?: number;
}

export interface JudgmentWindows {
  perfectWindow: number;
  greatWindow: number;
  goodWindow: number;
}

export interface JudgmentResult {
  grade: JudgmentGrade;
  timeOffset: number;
  noteId: string;
}

export interface GameConfig {
  songId: string;
  difficulty: Difficulty;
  laneCount: number;
  scrollSpeed: number;
  musicVolume: number;
  sfxVolume: number;
}

export interface GameResult {
  score: number;
  accuracy: number;
  letterGrade: LetterGrade;
  maxCombo: number;
  judgmentCounts: Map<JudgmentGrade, number>;
}

export interface SongInfo {
  id: string;
  title: string;
  artist: string;
  difficulties: Difficulty[];
  audioFilePath: string;
  coverImagePath?: string;
  duration: number;
  bpm: number;
  source: SongSource;
  version?: string;
}

export interface Beatmap {
  songId: string;
  difficulty: Difficulty;
  notes: NoteData[];
  version?: string;
}

export interface GameSettings {
  musicVolume: number;
  sfxVolume: number;
  scrollSpeed: number;
}

export interface BestScore {
  songId: string;
  difficulty: Difficulty;
  score: number;
  accuracy: number;
  letterGrade: LetterGrade;
  maxCombo: number;
}

export interface GamePageParams {
  songId: string;
  difficulty: Difficulty;
}

export interface ResultPageParams {
  score: number;
  accuracy: number;
  letterGrade: LetterGrade;
  maxCombo: number;
  perfect: number;
  great: number;
  good: number;
  miss: number;
  songId: string;
  difficulty: Difficulty;
}

export interface BeatmapPackage {
  version: string;
  song: SongInfo;
  beatmaps: Beatmap[];
  audioFileName: string;
  coverImageFileName?: string;
}

// ==================== Editor Reserved (v1.4+) ====================

export interface EditorProject {
  song: SongInfo;
  draft: Beatmap;
  history: EditorAction[];
  historyIndex: number;
  selectedNoteId?: string;
  isModified: boolean;
}

export interface EditorAction {
  type: string;
  noteId: string;
  before?: NoteData;
  after?: NoteData;
}

// ==================== Multiplayer Reserved (v1.4+) ====================

export interface RoomInfo {
  roomId: string;
  hostId: string;
  players: PlayerState[];
  songId: string;
  difficulty: Difficulty;
  maxPlayers: number;
  status: RoomStatus;
}

export interface PlayerState {
  playerId: string;
  playerName: string;
  score: number;
  combo: number;
  isReady: boolean;
  isPlaying: boolean;
}

export interface MultiplayerResult {
  roomId: string;
  songId: string;
  difficulty: Difficulty;
  rankings: PlayerState[];
}

// ==================== Abstract Class ====================

export abstract class GameUIUpdater {
  abstract onNotesUpdate(notes: RuntimeNote[]): void;
  abstract onScoreUpdate(score: number, increment: number): void;
  abstract onComboUpdate(combo: number): void;
  abstract onJudgmentShow(grade: JudgmentGrade, lane: number): void;
  abstract onGameEnd(result: GameResult, bestScore: number, isNewRecord: boolean): void;
}

// ==================== Type Helpers ====================
// Enums are already exported above with `export enum`. No re-export needed.
