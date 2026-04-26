/**
 * FingerBeat v1.3.0 - Score System
 * Manages score, combo, accuracy calculation and game result generation.
 */

import { JudgmentGrade, LetterGrade, GameResult } from '../model/GameTypes';
import { COMBO_MULTIPLIERS, gameConstants } from '../constants/GameConstants';
import { Logger } from '@ohos/common';

class ScoreSystem {
  private totalNoteCount: number;
  private score: number = 0;
  private combo: number = 0;
  private maxCombo: number = 0;
  private judgmentCounts: Map<JudgmentGrade, number> = new Map();

  constructor(totalNoteCount: number) {
    this.totalNoteCount = totalNoteCount;
    this.judgmentCounts.set(JudgmentGrade.PERFECT, 0);
    this.judgmentCounts.set(JudgmentGrade.GREAT, 0);
    this.judgmentCounts.set(JudgmentGrade.GOOD, 0);
    this.judgmentCounts.set(JudgmentGrade.MISS, 0);
    Logger.info(`ScoreSystem: initialized with totalNoteCount=${totalNoteCount}`);
  }

  /**
   * Process a judgment grade: update score with combo multiplier, update combo chain.
   */
  onJudgment(grade: JudgmentGrade): number {
    // Update judgment counts
    const currentCount = this.judgmentCounts.get(grade) ?? 0;
    this.judgmentCounts.set(grade, currentCount + 1);

    // Update combo
    if (grade === JudgmentGrade.MISS) {
      this.combo = 0;
    } else {
      this.combo++;
      if (this.combo > this.maxCombo) {
        this.maxCombo = this.combo;
      }
    }

    // Calculate score increment with combo multiplier
    const baseWeight = gameConstants.getScoreWeight(grade);
    const comboMultiplier = this.getComboMultiplier();
    const increment = Math.floor(baseWeight * comboMultiplier);
    this.score += increment;

    Logger.info(`ScoreSystem.onJudgment: ${JudgmentGrade[grade]} combo=${this.combo} +${increment} total=${this.score}`);
    return increment;
  }

  /**
   * Get current accuracy as percentage (0-100).
   */
  getAccuracy(): number {
    if (this.totalNoteCount === 0) {
      return 0;
    }
    const maxPossibleScore = this.totalNoteCount * gameConstants.getScoreWeight(JudgmentGrade.PERFECT);
    if (maxPossibleScore === 0) {
      return 0;
    }
    return (this.score / maxPossibleScore) * 100;
  }

  /**
   * Generate the final GameResult with letter grade.
   */
  getResult(): GameResult {
    const accuracy = this.getAccuracy();
    const letterGrade = this.calculateLetterGrade(accuracy);

    Logger.info(`ScoreSystem.getResult: score=${this.score} accuracy=${accuracy.toFixed(1)}% grade=${LetterGrade[letterGrade]} maxCombo=${this.maxCombo}`);

    return {
      score: this.score,
      accuracy: accuracy,
      letterGrade: letterGrade,
      maxCombo: this.maxCombo,
      judgmentCounts: new Map(this.judgmentCounts),
    };
  }

  getScore(): number {
    return this.score;
  }

  getCombo(): number {
    return this.combo;
  }

  getMaxCombo(): number {
    return this.maxCombo;
  }

  private getComboMultiplier(): number {
    for (const entry of COMBO_MULTIPLIERS) {
      if (this.combo >= entry.threshold) {
        return entry.multiplier;
      }
    }
    return 1.0;
  }

  private calculateLetterGrade(accuracy: number): LetterGrade {
    if (accuracy >= gameConstants.getLetterGradeThreshold(LetterGrade.S)) {
      return LetterGrade.S;
    } else if (accuracy >= gameConstants.getLetterGradeThreshold(LetterGrade.A)) {
      return LetterGrade.A;
    } else if (accuracy >= gameConstants.getLetterGradeThreshold(LetterGrade.B)) {
      return LetterGrade.B;
    } else if (accuracy >= gameConstants.getLetterGradeThreshold(LetterGrade.C)) {
      return LetterGrade.C;
    } else {
      return LetterGrade.D;
    }
  }
}

export default ScoreSystem;
