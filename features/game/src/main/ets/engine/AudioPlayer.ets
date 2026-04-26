/**
 * FingerBeat v1.3.0 - Audio Player
 * Manages BGM and SFX playback using HarmonyOS MediaKit.
 * All operations are wrapped in try-catch to prevent blocking on failure.
 */

import { media } from '@kit.MediaKit';
import { resourceManager } from '@kit.LocalizationKit';
import { Logger } from '@ohos/common';

class AudioPlayer {
  private bgmPlayer: media.AVPlayer | null = null;
  private sfxPool: Map<string, media.AVPlayer> = new Map();
  private isBGMReady: boolean = false;
  private isBGMPaused: boolean = false;

  /**
   * Initialize BGM from a raw resource file.
   * @param filePath - Raw resource file name (e.g., 'bgm.mp3')
   * @param context - Ability context for resource access
   */
  async initBGM(filePath: string, context: Context): Promise<void> {
    try {
      if (this.bgmPlayer !== null) {
        await this.releaseBGM();
      }

      this.bgmPlayer = await media.createAVPlayer();
      const resMgr: resourceManager.ResourceManager = context.resourceManager;
      const fileDescriptor: resourceManager.RawFileDescriptor = resMgr.getRawFdSync(filePath);
      const avFileDescriptor: media.AVFileDescriptor = {
        fd: fileDescriptor.fd,
        offset: fileDescriptor.offset,
        length: fileDescriptor.length,
      };
      this.bgmPlayer.fdSrc = avFileDescriptor;

      this.bgmPlayer.on('stateChange', (state: string) => {
        if (state === 'prepared') {
          this.isBGMReady = true;
          Logger.info('AudioPlayer.initBGM: BGM prepared');
        } else if (state === 'completed') {
          Logger.info('AudioPlayer.initBGM: BGM playback completed');
        }
      });

      await this.bgmPlayer.prepare();
      Logger.info(`AudioPlayer.initBGM: initialized - ${filePath}`);
    } catch (e) {
      Logger.error(`AudioPlayer.initBGM: failed - ${e}`);
    }
  }

  /**
   * Initialize a sound effect and add it to the SFX pool.
   * @param name - SFX identifier name
   * @param filePath - Raw resource file name
   * @param context - Ability context for resource access
   */
  async initSFX(name: string, filePath: string, context: Context): Promise<void> {
    try {
      const sfxPlayer = await media.createAVPlayer();
      const resMgr: resourceManager.ResourceManager = context.resourceManager;
      const fileDescriptor: resourceManager.RawFileDescriptor = resMgr.getRawFdSync(filePath);
      const avFileDescriptor: media.AVFileDescriptor = {
        fd: fileDescriptor.fd,
        offset: fileDescriptor.offset,
        length: fileDescriptor.length,
      };
      sfxPlayer.fdSrc = avFileDescriptor;
      sfxPlayer.loop = true;

      sfxPlayer.on('stateChange', (state: string) => {
        if (state === 'prepared') {
          Logger.info(`AudioPlayer.initSFX: ${name} prepared`);
        }
      });

      await sfxPlayer.prepare();
      this.sfxPool.set(name, sfxPlayer);
      Logger.info(`AudioPlayer.initSFX: initialized - ${name}`);
    } catch (e) {
      Logger.error(`AudioPlayer.initSFX: failed for ${name} - ${e}`);
    }
  }

  /**
   * Start BGM playback.
   */
  async playBGM(): Promise<void> {
    try {
      if (this.bgmPlayer === null || !this.isBGMReady) {
        Logger.warn('AudioPlayer.playBGM: BGM not ready');
        return;
      }
      this.bgmPlayer.loop = true;
      await this.bgmPlayer.play();
      this.isBGMPaused = false;
      Logger.info('AudioPlayer.playBGM: playing');
    } catch (e) {
      Logger.error(`AudioPlayer.playBGM: failed - ${e}`);
    }
  }

  /**
   * Pause BGM playback.
   */
  async pauseBGM(): Promise<void> {
    try {
      if (this.bgmPlayer === null) {
        return;
      }
      await this.bgmPlayer.pause();
      this.isBGMPaused = true;
      Logger.info('AudioPlayer.pauseBGM: paused');
    } catch (e) {
      Logger.error(`AudioPlayer.pauseBGM: failed - ${e}`);
    }
  }

  /**
   * Resume BGM playback.
   */
  async resumeBGM(): Promise<void> {
    try {
      if (this.bgmPlayer === null || !this.isBGMPaused) {
        return;
      }
      await this.bgmPlayer.play();
      this.isBGMPaused = false;
      Logger.info('AudioPlayer.resumeBGM: resumed');
    } catch (e) {
      Logger.error(`AudioPlayer.resumeBGM: failed - ${e}`);
    }
  }

  /**
   * Stop BGM playback.
   */
  async stopBGM(): Promise<void> {
    try {
      if (this.bgmPlayer === null) {
        return;
      }
      await this.bgmPlayer.stop();
      this.isBGMReady = false;
      this.isBGMPaused = false;
      Logger.info('AudioPlayer.stopBGM: stopped');
    } catch (e) {
      Logger.error(`AudioPlayer.stopBGM: failed - ${e}`);
    }
  }

  /**
   * Play a sound effect by name.
   * @param name - SFX identifier name
   */
  async playSFX(name: string): Promise<void> {
    try {
      const sfxPlayer = this.sfxPool.get(name);
      if (sfxPlayer === undefined) {
        Logger.warn(`AudioPlayer.playSFX: SFX not found - ${name}`);
        return;
      }
      // Reset to start and play
      sfxPlayer.seek(0);
      await sfxPlayer.play();
    } catch (e) {
      Logger.error(`AudioPlayer.playSFX: failed for ${name} - ${e}`);
    }
  }

  /**
   * Get current BGM playback position in milliseconds.
   * @returns Current time in ms, or 0 if not available
   */
  getCurrentTime(): number {
    try {
      if (this.bgmPlayer === null || !this.isBGMReady) {
        return 0;
      }
      return this.bgmPlayer.currentTime;
    } catch (e) {
      Logger.error(`AudioPlayer.getCurrentTime: failed - ${e}`);
      return 0;
    }
  }

  /**
   * Set BGM volume.
   * @param volume - Volume level from 0.0 to 1.0
   */
  setVolume(volume: number): void {
    try {
      if (this.bgmPlayer === null) {
        return;
      }
      const clampedVolume = Math.max(0, Math.min(1, volume));
      this.bgmPlayer.setVolume(clampedVolume);
      Logger.info(`AudioPlayer.setVolume: ${clampedVolume}`);
    } catch (e) {
      Logger.error(`AudioPlayer.setVolume: failed - ${e}`);
    }
  }

  /**
   * Release BGM player resources.
   */
  private async releaseBGM(): Promise<void> {
    try {
      if (this.bgmPlayer !== null) {
        this.bgmPlayer.off('stateChange');
        await this.bgmPlayer.release();
        this.bgmPlayer = null;
        this.isBGMReady = false;
        this.isBGMPaused = false;
      }
    } catch (e) {
      Logger.error(`AudioPlayer.releaseBGM: failed - ${e}`);
    }
  }

  /**
   * Release all audio resources (BGM and all SFX).
   */
  async release(): Promise<void> {
    try {
      // Release BGM
      await this.releaseBGM();

      // Release all SFX
      const sfxNames = Array.from(this.sfxPool.keys());
      for (const name of sfxNames) {
        const sfxPlayer = this.sfxPool.get(name);
        if (sfxPlayer !== undefined) {
          try {
            sfxPlayer.off('stateChange');
            await sfxPlayer.release();
          } catch (e) {
            Logger.error(`AudioPlayer.release: SFX ${name} release failed - ${e}`);
          }
        }
      }
      this.sfxPool.clear();
      Logger.info('AudioPlayer.release: all resources released');
    } catch (e) {
      Logger.error(`AudioPlayer.release: failed - ${e}`);
    }
  }
}

export default AudioPlayer;
