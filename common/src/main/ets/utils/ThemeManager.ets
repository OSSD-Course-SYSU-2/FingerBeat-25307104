import { preferences } from '@kit.ArkData';
import {
  AppearanceColors, ChartColors,
  DarkAppearanceColors, LightAppearanceColors,
  DarkChartColors, LightChartColors,
} from '../constants/ColorScheme';

export type AppearanceMode = 'dark' | 'light';
export type ChartColorMode = 'dark' | 'light';

class ThemeManager {
  private preference: preferences.Preferences | null = null;
  private appearanceMode: AppearanceMode = 'dark';
  private chartColorMode: ChartColorMode = 'dark';
  private static readonly STORE_NAME: string = 'fingerbeat_settings';
  private static readonly KEY_APPEARANCE: string = 'appearance_mode';
  private static readonly KEY_CHART_COLOR: string = 'chart_color';

  init(context: Context): void {
    try {
      this.preference = preferences.getPreferencesSync(context, { name: ThemeManager.STORE_NAME });
      const savedAppearance: string = this.preference.getSync(ThemeManager.KEY_APPEARANCE, '') as string;
      if (savedAppearance === 'dark' || savedAppearance === 'light') {
        this.appearanceMode = savedAppearance;
      }
      const savedChartColor: string = this.preference.getSync(ThemeManager.KEY_CHART_COLOR, '') as string;
      if (savedChartColor === 'dark' || savedChartColor === 'light') {
        this.chartColorMode = savedChartColor;
      }
    } catch (_e) {
      this.appearanceMode = 'dark';
      this.chartColorMode = 'dark';
    }
  }

  getAppearanceMode(): AppearanceMode {
    return this.appearanceMode;
  }

  getChartColorMode(): ChartColorMode {
    return this.chartColorMode;
  }

  setAppearanceMode(mode: AppearanceMode): void {
    this.appearanceMode = mode;
    if (this.preference !== null) {
      try {
        this.preference.putSync(ThemeManager.KEY_APPEARANCE, mode);
        this.preference.flush();
      } catch (_e) {
      }
    }
  }

  setChartColorMode(mode: ChartColorMode): void {
    this.chartColorMode = mode;
    if (this.preference !== null) {
      try {
        this.preference.putSync(ThemeManager.KEY_CHART_COLOR, mode);
        this.preference.flush();
      } catch (_e) {
      }
    }
  }

  getAppearanceColors(): AppearanceColors {
    return this.appearanceMode === 'light' ? LightAppearanceColors : DarkAppearanceColors;
  }

  getChartColors(): ChartColors {
    return this.chartColorMode === 'light' ? LightChartColors : DarkChartColors;
  }
}

export default new ThemeManager();
