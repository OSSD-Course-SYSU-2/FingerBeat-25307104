import { SongInfo, Difficulty, SongSource } from '../../model/GameTypes';

export const SONG1_INFO: SongInfo = {
  id: 'song1',
  title: '星空旋律',
  artist: 'FingerBeat',
  difficulties: [Difficulty.Easy, Difficulty.Normal, Difficulty.Hard],
  audioFilePath: 'bgm_song1.wav',
  coverImagePath: 'icon.png',
  duration: 30000,
  bpm: 120,
  source: SongSource.BUILTIN
};
