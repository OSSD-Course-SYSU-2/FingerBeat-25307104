/**
 * FingerBeat v1.3.0 - Game Constants
 * All game configuration constants centralized here.
 */

import { Difficulty, JudgmentGrade, LetterGrade } from '../model/GameTypes';

// ==================== Game Loop ====================
export const GAME_LOOP_INTERVAL: number = 16;
export const DEFAULT_LANE_COUNT: number = 4;
export const BASE_SCROLL_SPEED: number = 0.5;
export const JUDGMENT_LINE_RATIO: number = 0.85;
export const NOTE_VISIBLE_AHEAD_TIME: number = 2000;
export const NOTE_VISIBLE_BEHIND_TIME: number = 500;

// ==================== Judgment Windows ====================
export const JUDGMENT_WINDOWS: Record<string, { perfect: number; great: number; good: number }> = {
  [Difficulty.Easy]: { perfect: 50, great: 100, good: 150 },
  [Difficulty.Normal]: { perfect: 40, great: 80, good: 120 },
  [Difficulty.Hard]: { perfect: 30, great: 60, good: 100 },
};

// ==================== Difficulty Speed Multiplier ====================
export const DIFFICULTY_SPEED_MULTIPLIER: Record<string, number> = {
  [Difficulty.Easy]: 0.8,
  [Difficulty.Normal]: 1.0,
  [Difficulty.Hard]: 1.2,
};

// ==================== Score Weights ====================
export const SCORE_WEIGHTS: Record<string, number> = {
  [JudgmentGrade.PERFECT]: 300,
  [JudgmentGrade.GREAT]: 200,
  [JudgmentGrade.GOOD]: 100,
  [JudgmentGrade.MISS]: 0,
};

// ==================== Combo Multipliers ====================
export const COMBO_MULTIPLIERS: Array<{ threshold: number; multiplier: number }> = [
  { threshold: 50, multiplier: 1.3 },
  { threshold: 30, multiplier: 1.2 },
  { threshold: 10, multiplier: 1.1 },
];

// ==================== Letter Grade Thresholds ====================
export const LETTER_GRADE_THRESHOLDS: Record<string, number> = {
  [LetterGrade.S]: 95,
  [LetterGrade.A]: 85,
  [LetterGrade.B]: 70,
  [LetterGrade.C]: 50,
};

// ==================== Judgment Colors ====================
export const JUDGMENT_COLORS: Record<string, string> = {
  [JudgmentGrade.PERFECT]: '#FFD700',
  [JudgmentGrade.GREAT]: '#00FF00',
  [JudgmentGrade.GOOD]: '#00BFFF',
  [JudgmentGrade.MISS]: '#FF4500',
};

// ==================== Letter Grade Colors ====================
export const LETTER_GRADE_COLORS: Record<string, string> = {
  [LetterGrade.S]: '#FFD700',
  [LetterGrade.A]: '#00FF00',
  [LetterGrade.B]: '#00BFFF',
  [LetterGrade.C]: '#FFA500',
  [LetterGrade.D]: '#FF4500',
};

// ==================== Persistence Store Names ====================
export const SETTINGS_STORE_NAME: string = 'fingerbeat_settings';
export const SCORE_STORE_NAME: string = 'fingerbeat_scores';

// ==================== Default Settings ====================
export const DEFAULT_SETTINGS = {
  musicVolume: 0.8,
  sfxVolume: 0.8,
  scrollSpeed: 1.0,
};

// ==================== Export Helper ====================
export const gameConstants = {
  GAME_LOOP_INTERVAL,
  DEFAULT_LANE_COUNT,
  BASE_SCROLL_SPEED,
  JUDGMENT_LINE_RATIO,
  NOTE_VISIBLE_AHEAD_TIME,
  NOTE_VISIBLE_BEHIND_TIME,
  JUDGMENT_WINDOWS,
  DIFFICULTY_SPEED_MULTIPLIER,
  SCORE_WEIGHTS,
  COMBO_MULTIPLIERS,
  LETTER_GRADE_THRESHOLDS,
  JUDGMENT_COLORS,
  LETTER_GRADE_COLORS,
  SETTINGS_STORE_NAME,
  SCORE_STORE_NAME,
  DEFAULT_SETTINGS,
};
