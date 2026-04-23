import { BestScore, GameResult, Difficulty, LetterGrade } from '../model/GameTypes';
import { SCORE_STORE_NAME } from '../constants/GameConstants';
import { Logger } from '@ohos/common';
import { preferences } from '@kit.ArkData';

// 已知分数键列表，用于遍历所有得分记录
const KNOWN_SCORE_KEYS: string[] = [
  'song1_Easy', 'song1_Normal', 'song1_Hard',
  'song2_Easy', 'song2_Normal', 'song2_Hard',
  'song3_Easy', 'song3_Normal', 'song3_Hard'
];

class ScoreStore {
  private preference: preferences.Preferences | null = null;

  /**
   * 初始化Preferences存储
   */
  init(context: Context): void {
    try {
      this.preference = preferences.getPreferencesSync(context, { name: SCORE_STORE_NAME });
      Logger.info('ScoreStore initialized');
    } catch (err) {
      Logger.error(`ScoreStore init failed: ${JSON.stringify(err)}`);
    }
  }

  /**
   * 获取指定曲目和难度的最佳分数
   */
  getBestScore(songId: string, difficulty: Difficulty): BestScore | null {
    if (this.preference === null) {
      return null;
    }
    try {
      const key = `${songId}_${difficulty}`;
      const data: string = this.preference.getSync(key, '') as string;
      if (data === '') {
        return null;
      }
      return this.parseBestScore(data);
    } catch (err) {
      Logger.error(`ScoreStore getBestScore failed: ${JSON.stringify(err)}`);
      return null;
    }
  }

  /**
   * 更新最佳分数（仅当新分数更高时更新）
   */
  updateBestScore(songId: string, difficulty: Difficulty, result: GameResult): boolean {
    if (this.preference === null) {
      return false;
    }
    try {
      const key = `${songId}_${difficulty}`;
      const existing = this.getBestScore(songId, difficulty);
      if (existing !== null && existing.score >= result.score) {
        return false;
      }
      const bestScore: BestScore = {
        songId: songId,
        difficulty: difficulty,
        score: result.score,
        accuracy: result.accuracy,
        letterGrade: result.letterGrade,
        maxCombo: result.maxCombo
      };
      this.preference.putSync(key, JSON.stringify(bestScore));
      this.preference.flush();
      Logger.info(`ScoreStore updated: ${key} score=${result.score}`);
      return true;
    } catch (err) {
      Logger.error(`ScoreStore updateBestScore failed: ${JSON.stringify(err)}`);
      return false;
    }
  }

  /**
   * 获取所有最佳分数
   */
  getAllBestScores(): BestScore[] {
    if (this.preference === null) {
      return [];
    }
    try {
      const results: BestScore[] = [];
      for (const key of KNOWN_SCORE_KEYS) {
        const data: string = this.preference.getSync(key, '') as string;
        if (data !== '') {
          const score = this.parseBestScore(data);
          if (score !== null) {
            results.push(score);
          }
        }
      }
      return results;
    } catch (err) {
      Logger.error(`ScoreStore getAllBestScores failed: ${JSON.stringify(err)}`);
      return [];
    }
  }

  private parseBestScore(data: string): BestScore | null {
    try {
      const obj: Record<string, Object> = JSON.parse(data) as Record<string, Object>;
      return {
        songId: obj['songId'] as string,
        difficulty: obj['difficulty'] as Difficulty,
        score: obj['score'] as number,
        accuracy: obj['accuracy'] as number,
        letterGrade: obj['letterGrade'] as LetterGrade,
        maxCombo: obj['maxCombo'] as number
      };
    } catch (err) {
      return null;
    }
  }
}

export default new ScoreStore();
