import { SongInfo, Beatmap, Difficulty, NoteData, SongSource } from '../model/GameTypes';
import { SONG1_INFO } from './beatmaps/Song1Info';
import { SONG1_EASY, SONG1_NORMAL, SONG1_HARD } from './beatmaps/Song1Beatmaps';
import { SONG2_INFO, SONG2_EASY, SONG2_NORMAL, SONG2_HARD } from './beatmaps/Song2Beatmaps';
import { SONG3_INFO, SONG3_EASY, SONG3_NORMAL, SONG3_HARD } from './beatmaps/Song3Beatmaps';
import { Logger } from '@ohos/common';

class BeatmapRepository {
  private songs: SongInfo[] = [];
  private beatmaps: Map<string, NoteData[]> = new Map();

  constructor() {
    this.songs = [SONG1_INFO, SONG2_INFO, SONG3_INFO];
    this.beatmaps.set(`${SONG1_INFO.id}_${Difficulty.Easy}`, SONG1_EASY);
    this.beatmaps.set(`${SONG1_INFO.id}_${Difficulty.Normal}`, SONG1_NORMAL);
    this.beatmaps.set(`${SONG1_INFO.id}_${Difficulty.Hard}`, SONG1_HARD);
    this.beatmaps.set(`${SONG2_INFO.id}_${Difficulty.Easy}`, SONG2_EASY);
    this.beatmaps.set(`${SONG2_INFO.id}_${Difficulty.Normal}`, SONG2_NORMAL);
    this.beatmaps.set(`${SONG2_INFO.id}_${Difficulty.Hard}`, SONG2_HARD);
    this.beatmaps.set(`${SONG3_INFO.id}_${Difficulty.Easy}`, SONG3_EASY);
    this.beatmaps.set(`${SONG3_INFO.id}_${Difficulty.Normal}`, SONG3_NORMAL);
    this.beatmaps.set(`${SONG3_INFO.id}_${Difficulty.Hard}`, SONG3_HARD);
  }

  /**
   * 获取所有曲目列表（可选按来源过滤）
   */
  getAllSongs(source?: SongSource): SongInfo[] {
    if (source === undefined) {
      return this.songs;
    }
    return this.songs.filter((song: SongInfo): boolean => song.source === source);
  }

  /**
   * 按ID查找曲目
   */
  getSongById(songId: string): SongInfo | null {
    for (const song of this.songs) {
      if (song.id === songId) {
        return song;
      }
    }
    return null;
  }

  /**
   * 获取指定曲目和难度的谱面
   */
  getBeatmap(songId: string, difficulty: Difficulty): Beatmap | null {
    const key = `${songId}_${difficulty}`;
    const notes = this.beatmaps.get(key);
    if (notes === undefined) {
      Logger.warn(`Beatmap not found: ${key}`);
      return null;
    }
    return {
      songId: songId,
      difficulty: difficulty,
      notes: notes
    };
  }

  /**
   * 预留：添加曲目（为官方更新和玩家导入扩展）
   */
  addSong(song: SongInfo, beatmaps: Beatmap[]): void {
    Logger.info(`BeatmapRepository.addSong: reserved for future extension - ${song.id}`);
  }

  /**
   * 预留：移除曲目（为玩家删除导入曲目扩展）
   */
  removeSong(songId: string): boolean {
    Logger.info(`BeatmapRepository.removeSong: reserved for future extension - ${songId}`);
    return false;
  }

  /**
   * 预留：检查官方更新（为后台更新通道扩展）
   */
  checkOfficialUpdates(): Promise<SongInfo[]> {
    Logger.info('BeatmapRepository.checkOfficialUpdates: reserved for future extension');
    return Promise.resolve([]);
  }
}

export default new BeatmapRepository();
