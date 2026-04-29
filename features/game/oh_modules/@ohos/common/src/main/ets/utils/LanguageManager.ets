import { preferences } from '@kit.ArkData';
import { resourceManager } from '@kit.LocalizationKit';
import { Logger } from './Logger';

type LanguageCode = 'zh' | 'en';

const TRANSLATIONS: Record<string, Record<string, string>> = {
  'zh': {
    'app_name': 'FingerBeat',
    'start_game': '开始击打！',
    'song_select': '选择曲目',
    'difficulty_easy': '简单',
    'difficulty_normal': '普通',
    'difficulty_hard': '困难',
    'score_label': '分数',
    'best_label': '最佳',
    'accuracy_label': '准确率',
    'max_combo_label': '最大连击',
    'result_title': '结算',
    'new_record_full': '新纪录！',
    'back': '返回',
    'pause_label': '暂停',
    'resume_label': '继续',
    'no_bgm': '无BGM',
    'level_warm_up': '牛刀小试',
    'level_starry_melody': '星空旋律',
    'level_electro_pulse': '电子脉冲',
    'level_dream_beat': '梦幻节拍',
    'settings_title': '设置',
    'appearance_label': '外观模式',
    'chart_color_label': '谱面颜色',
    'dark_label': '深色',
    'light_label': '浅色',
  },
  'en': {
    'app_name': 'FingerBeat',
    'start_game': 'Ready to Beat',
    'song_select': 'Select Song',
    'difficulty_easy': 'Easy',
    'difficulty_normal': 'Normal',
    'difficulty_hard': 'Hard',
    'score_label': 'Score',
    'best_label': 'Best',
    'accuracy_label': 'Accuracy',
    'max_combo_label': 'Max Combo',
    'result_title': 'Results',
    'new_record_full': 'NEW RECORD!',
    'back': 'Back',
    'pause_label': 'Pause',
    'resume_label': 'Resume',
    'no_bgm': 'No BGM',
    'level_warm_up': 'Warm Up',
    'level_starry_melody': 'Starry Melody',
    'level_electro_pulse': 'Electro Pulse',
    'level_dream_beat': 'Dream Beat',
    'settings_title': 'Settings',
    'appearance_label': 'Appearance',
    'chart_color_label': 'Chart Color',
    'dark_label': 'Dark',
    'light_label': 'Light',
  }
};

class LanguageManager {
  private preference: preferences.Preferences | null = null;
  private currentLang: LanguageCode = 'zh';
  private context: Context | null = null;
  private static readonly STORE_NAME: string = 'fingerbeat_language';
  private static readonly KEY_LANGUAGE: string = 'language';

  init(context: Context): void {
    this.context = context;
    try {
      this.preference = preferences.getPreferencesSync(context, { name: LanguageManager.STORE_NAME });
      const savedLang: string = this.preference.getSync(LanguageManager.KEY_LANGUAGE, '') as string;
      if (savedLang === 'zh' || savedLang === 'en') {
        this.currentLang = savedLang;
      } else {
        this.currentLang = this.detectSystemLanguage();
      }
    } catch (_e) {
      this.currentLang = this.detectSystemLanguage();
    }
  }

  private detectSystemLanguage(): LanguageCode {
    try {
      if (this.context !== null) {
        const resMgr: resourceManager.ResourceManager = this.context.resourceManager;
        const config: resourceManager.Configuration = resMgr.getConfigurationSync();
        if (config.locale !== undefined && config.locale !== null) {
          const localeStr: string = config.locale;
          if (localeStr.startsWith('zh')) {
            return 'zh';
          } else if (localeStr.startsWith('en')) {
            return 'en';
          }
        }
      }
    } catch (_e) {
    }
    return 'zh';
  }

  getLanguage(): LanguageCode {
    return this.currentLang;
  }

  toggleLanguage(): LanguageCode {
    const newLang: LanguageCode = this.currentLang === 'zh' ? 'en' : 'zh';
    this.setLanguage(newLang);
    return newLang;
  }

  setLanguage(lang: LanguageCode): void {
    this.currentLang = lang;
    if (this.preference !== null) {
      try {
        this.preference.putSync(LanguageManager.KEY_LANGUAGE, lang);
        this.preference.flush();
      } catch (_e) {
      }
    }
  }

  getSwitchButtonText(): string {
    return this.currentLang === 'zh' ? '中文' : 'EN';
  }

  getText(key: string): string {
    const langMap: Record<string, string> | undefined = TRANSLATIONS[this.currentLang];
    if (langMap !== undefined && langMap[key] !== undefined) {
      return langMap[key];
    }
    const enMap: Record<string, string> | undefined = TRANSLATIONS['en'];
    if (enMap !== undefined && enMap[key] !== undefined) {
      return enMap[key];
    }
    return key;
  }
}

export default new LanguageManager();
