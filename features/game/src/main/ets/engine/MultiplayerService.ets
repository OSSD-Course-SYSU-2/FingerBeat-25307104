/**
 * FingerBeat v1.3.0 - Multiplayer Service
 * Reserved interface for v1.4+. All methods are stub implementations with logging.
 */

import { RoomInfo, PlayerState, MultiplayerResult, Difficulty } from '../model/GameTypes';
import { Logger } from '@ohos/common';

class MultiplayerService {
  /**
   * Create a multiplayer room.
   */
  createRoom(songId: string, difficulty: Difficulty, maxPlayers: number): RoomInfo | null {
    Logger.info('MultiplayerService.createRoom: 未实现');
    return null;
  }

  /**
   * Join an existing room.
   */
  joinRoom(roomId: string, playerId: string, playerName: string): boolean {
    Logger.info('MultiplayerService.joinRoom: 未实现');
    return false;
  }

  /**
   * Leave the current room.
   */
  leaveRoom(roomId: string, playerId: string): boolean {
    Logger.info('MultiplayerService.leaveRoom: 未实现');
    return false;
  }

  /**
   * Set player ready status.
   */
  setReady(roomId: string, playerId: string, isReady: boolean): boolean {
    Logger.info('MultiplayerService.setReady: 未实现');
    return false;
  }

  /**
   * Start the multiplayer game (host only).
   */
  startGame(roomId: string): boolean {
    Logger.info('MultiplayerService.startGame: 未实现');
    return false;
  }

  /**
   * Sync game state to other players.
   */
  syncState(roomId: string, playerId: string, score: number, combo: number): void {
    Logger.info('MultiplayerService.syncState: 未实现');
  }

  /**
   * Get final ranking after game ends.
   */
  getRanking(roomId: string): MultiplayerResult | null {
    Logger.info('MultiplayerService.getRanking: 未实现');
    return null;
  }
}

export default MultiplayerService;
