import { GameSettings } from '../model/GameTypes';
import { DEFAULT_SETTINGS, SETTINGS_STORE_NAME } from '../constants/GameConstants';
import { Logger } from '@ohos/common';
import { preferences } from '@kit.ArkData';

// 部分设置更新接口（替代Partial<GameSettings>）
export interface PartialGameSettings {
  musicVolume?: number;
  sfxVolume?: number;
  scrollSpeed?: number;
}

class SettingsStore {
  private preference: preferences.Preferences | null = null;

  /**
   * 初始化Preferences存储
   */
  init(context: Context): void {
    try {
      this.preference = preferences.getPreferencesSync(context, { name: SETTINGS_STORE_NAME });
      Logger.info('SettingsStore initialized');
    } catch (err) {
      Logger.error(`SettingsStore init failed: ${JSON.stringify(err)}`);
    }
  }

  /**
   * 获取当前设置（未初始化或读取失败时返回默认值）
   */
  getSettings(): GameSettings {
    if (this.preference === null) {
      return {
        musicVolume: DEFAULT_SETTINGS.musicVolume,
        sfxVolume: DEFAULT_SETTINGS.sfxVolume,
        scrollSpeed: DEFAULT_SETTINGS.scrollSpeed
      };
    }
    try {
      const musicVolume = this.preference.getSync('musicVolume', DEFAULT_SETTINGS.musicVolume) as number;
      const sfxVolume = this.preference.getSync('sfxVolume', DEFAULT_SETTINGS.sfxVolume) as number;
      const scrollSpeed = this.preference.getSync('scrollSpeed', DEFAULT_SETTINGS.scrollSpeed) as number;
      return { musicVolume, sfxVolume, scrollSpeed };
    } catch (err) {
      Logger.error(`SettingsStore getSettings failed: ${JSON.stringify(err)}`);
      return {
        musicVolume: DEFAULT_SETTINGS.musicVolume,
        sfxVolume: DEFAULT_SETTINGS.sfxVolume,
        scrollSpeed: DEFAULT_SETTINGS.scrollSpeed
      };
    }
  }

  /**
   * 部分更新设置
   */
  updateSettings(settings: PartialGameSettings): void {
    if (this.preference === null) {
      return;
    }
    try {
      if (settings.musicVolume !== undefined) {
        this.preference.putSync('musicVolume', settings.musicVolume);
      }
      if (settings.sfxVolume !== undefined) {
        this.preference.putSync('sfxVolume', settings.sfxVolume);
      }
      if (settings.scrollSpeed !== undefined) {
        this.preference.putSync('scrollSpeed', settings.scrollSpeed);
      }
      this.preference.flush();
      Logger.info('SettingsStore updated');
    } catch (err) {
      Logger.error(`SettingsStore updateSettings failed: ${JSON.stringify(err)}`);
    }
  }

  /**
   * 重置为默认设置
   */
  resetToDefault(): void {
    if (this.preference === null) {
      return;
    }
    try {
      this.preference.putSync('musicVolume', DEFAULT_SETTINGS.musicVolume);
      this.preference.putSync('sfxVolume', DEFAULT_SETTINGS.sfxVolume);
      this.preference.putSync('scrollSpeed', DEFAULT_SETTINGS.scrollSpeed);
      this.preference.flush();
      Logger.info('SettingsStore reset to default');
    } catch (err) {
      Logger.error(`SettingsStore resetToDefault failed: ${JSON.stringify(err)}`);
    }
  }
}

export default new SettingsStore();
