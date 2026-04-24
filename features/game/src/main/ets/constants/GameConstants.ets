/**
 * FingerBeat v1.3.0 - Game Constants
 * All game configuration constants centralized here.
 * Rewritten to comply with ArkTS strict mode (no Record, no computed property names).
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
export interface JudgmentWindowConfig {
  perfect: number;
  great: number;
  good: number;
}

export const JUDGMENT_WINDOWS_EASY: JudgmentWindowConfig = { perfect: 50, great: 100, good: 150 };
export const JUDGMENT_WINDOWS_NORMAL: JudgmentWindowConfig = { perfect: 40, great: 80, good: 120 };
export const JUDGMENT_WINDOWS_HARD: JudgmentWindowConfig = { perfect: 30, great: 60, good: 100 };

function getJudgmentWindows(difficulty: Difficulty): JudgmentWindowConfig {
  if (difficulty === Difficulty.Easy) {
    return JUDGMENT_WINDOWS_EASY;
  } else if (difficulty === Difficulty.Normal) {
    return JUDGMENT_WINDOWS_NORMAL;
  } else {
    return JUDGMENT_WINDOWS_HARD;
  }
}

// ==================== Difficulty Speed Multiplier ====================
export const DIFFICULTY_SPEED_EASY: number = 0.8;
export const DIFFICULTY_SPEED_NORMAL: number = 1.0;
export const DIFFICULTY_SPEED_HARD: number = 1.2;

function getDifficultySpeedMultiplier(difficulty: Difficulty): number {
  if (difficulty === Difficulty.Easy) {
    return DIFFICULTY_SPEED_EASY;
  } else if (difficulty === Difficulty.Normal) {
    return DIFFICULTY_SPEED_NORMAL;
  } else {
    return DIFFICULTY_SPEED_HARD;
  }
}

// ==================== Score Weights ====================
export const SCORE_WEIGHT_PERFECT: number = 300;
export const SCORE_WEIGHT_GREAT: number = 200;
export const SCORE_WEIGHT_GOOD: number = 100;
export const SCORE_WEIGHT_MISS: number = 0;

function getScoreWeight(grade: JudgmentGrade): number {
  if (grade === JudgmentGrade.PERFECT) {
    return SCORE_WEIGHT_PERFECT;
  } else if (grade === JudgmentGrade.GREAT) {
    return SCORE_WEIGHT_GREAT;
  } else if (grade === JudgmentGrade.GOOD) {
    return SCORE_WEIGHT_GOOD;
  } else {
    return SCORE_WEIGHT_MISS;
  }
}

// ==================== Combo Multipliers ====================
export interface ComboMultiplierEntry {
  threshold: number;
  multiplier: number;
}

export const COMBO_MULTIPLIER_50: ComboMultiplierEntry = { threshold: 50, multiplier: 1.3 };
export const COMBO_MULTIPLIER_30: ComboMultiplierEntry = { threshold: 30, multiplier: 1.2 };
export const COMBO_MULTIPLIER_10: ComboMultiplierEntry = { threshold: 10, multiplier: 1.1 };
export const COMBO_MULTIPLIERS: ComboMultiplierEntry[] = [
  COMBO_MULTIPLIER_50,
  COMBO_MULTIPLIER_30,
  COMBO_MULTIPLIER_10,
];

// ==================== Letter Grade Thresholds ====================
export const LETTER_GRADE_THRESHOLD_S: number = 95;
export const LETTER_GRADE_THRESHOLD_A: number = 85;
export const LETTER_GRADE_THRESHOLD_B: number = 70;
export const LETTER_GRADE_THRESHOLD_C: number = 50;

function getLetterGradeThreshold(grade: LetterGrade): number {
  if (grade === LetterGrade.S) {
    return LETTER_GRADE_THRESHOLD_S;
  } else if (grade === LetterGrade.A) {
    return LETTER_GRADE_THRESHOLD_A;
  } else if (grade === LetterGrade.B) {
    return LETTER_GRADE_THRESHOLD_B;
  } else if (grade === LetterGrade.C) {
    return LETTER_GRADE_THRESHOLD_C;
  } else {
    return 0;
  }
}

// ==================== Judgment Colors ====================
export const JUDGMENT_COLOR_PERFECT: string = '#FFD700';
export const JUDGMENT_COLOR_GREAT: string = '#00FF00';
export const JUDGMENT_COLOR_GOOD: string = '#00BFFF';
export const JUDGMENT_COLOR_MISS: string = '#FF4500';

function getJudgmentColor(grade: JudgmentGrade): string {
  if (grade === JudgmentGrade.PERFECT) {
    return JUDGMENT_COLOR_PERFECT;
  } else if (grade === JudgmentGrade.GREAT) {
    return JUDGMENT_COLOR_GREAT;
  } else if (grade === JudgmentGrade.GOOD) {
    return JUDGMENT_COLOR_GOOD;
  } else {
    return JUDGMENT_COLOR_MISS;
  }
}

// ==================== Letter Grade Colors ====================
export const LETTER_GRADE_COLOR_S: string = '#FFD700';
export const LETTER_GRADE_COLOR_A: string = '#00FF00';
export const LETTER_GRADE_COLOR_B: string = '#00BFFF';
export const LETTER_GRADE_COLOR_C: string = '#FFA500';
export const LETTER_GRADE_COLOR_D: string = '#FF4500';

// ==================== Judgment Labels ====================
export const JUDGMENT_LABEL_PERFECT: string = 'PERFECT';
export const JUDGMENT_LABEL_GREAT: string = 'GREAT';
export const JUDGMENT_LABEL_GOOD: string = 'GOOD';
export const JUDGMENT_LABEL_MISS: string = 'MISS';

function getJudgmentLabel(grade: JudgmentGrade): string {
  if (grade === JudgmentGrade.PERFECT) {
    return JUDGMENT_LABEL_PERFECT;
  } else if (grade === JudgmentGrade.GREAT) {
    return JUDGMENT_LABEL_GREAT;
  } else if (grade === JudgmentGrade.GOOD) {
    return JUDGMENT_LABEL_GOOD;
  } else {
    return JUDGMENT_LABEL_MISS;
  }
}

function getLetterGradeColor(grade: LetterGrade): string {
  if (grade === LetterGrade.S) {
    return LETTER_GRADE_COLOR_S;
  } else if (grade === LetterGrade.A) {
    return LETTER_GRADE_COLOR_A;
  } else if (grade === LetterGrade.B) {
    return LETTER_GRADE_COLOR_B;
  } else if (grade === LetterGrade.C) {
    return LETTER_GRADE_COLOR_C;
  } else {
    return LETTER_GRADE_COLOR_D;
  }
}

// ==================== Persistence Store Names ====================
export const SETTINGS_STORE_NAME: string = 'fingerbeat_settings';
export const SCORE_STORE_NAME: string = 'fingerbeat_scores';

// ==================== Default Settings ====================
export interface DefaultSettings {
  musicVolume: number;
  sfxVolume: number;
  scrollSpeed: number;
}

export const DEFAULT_SETTINGS: DefaultSettings = {
  musicVolume: 0.8,
  sfxVolume: 0.8,
  scrollSpeed: 1.0,
};

// ==================== Export Helper ====================
export interface GameConstantsType {
  GAME_LOOP_INTERVAL: number;
  DEFAULT_LANE_COUNT: number;
  BASE_SCROLL_SPEED: number;
  JUDGMENT_LINE_RATIO: number;
  NOTE_VISIBLE_AHEAD_TIME: number;
  NOTE_VISIBLE_BEHIND_TIME: number;
  COMBO_MULTIPLIERS: ComboMultiplierEntry[];
  SETTINGS_STORE_NAME: string;
  SCORE_STORE_NAME: string;
  DEFAULT_SETTINGS: DefaultSettings;
  getJudgmentWindows: (difficulty: Difficulty) => JudgmentWindowConfig;
  getDifficultySpeedMultiplier: (difficulty: Difficulty) => number;
  getScoreWeight: (grade: JudgmentGrade) => number;
  getLetterGradeThreshold: (grade: LetterGrade) => number;
  getJudgmentColor: (grade: JudgmentGrade) => string;
  getJudgmentLabel: (grade: JudgmentGrade) => string;
  getLetterGradeColor: (grade: LetterGrade) => string;
}

export const gameConstants: GameConstantsType = {
  GAME_LOOP_INTERVAL: GAME_LOOP_INTERVAL,
  DEFAULT_LANE_COUNT: DEFAULT_LANE_COUNT,
  BASE_SCROLL_SPEED: BASE_SCROLL_SPEED,
  JUDGMENT_LINE_RATIO: JUDGMENT_LINE_RATIO,
  NOTE_VISIBLE_AHEAD_TIME: NOTE_VISIBLE_AHEAD_TIME,
  NOTE_VISIBLE_BEHIND_TIME: NOTE_VISIBLE_BEHIND_TIME,
  COMBO_MULTIPLIERS: COMBO_MULTIPLIERS,
  SETTINGS_STORE_NAME: SETTINGS_STORE_NAME,
  SCORE_STORE_NAME: SCORE_STORE_NAME,
  DEFAULT_SETTINGS: DEFAULT_SETTINGS,
  getJudgmentWindows: getJudgmentWindows,
  getDifficultySpeedMultiplier: getDifficultySpeedMultiplier,
  getScoreWeight: getScoreWeight,
  getLetterGradeThreshold: getLetterGradeThreshold,
  getJudgmentColor: getJudgmentColor,
  getJudgmentLabel: getJudgmentLabel,
  getLetterGradeColor: getLetterGradeColor,
};
