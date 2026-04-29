export interface AppearanceColors {
  background: string;
  primaryText: string;
  secondaryText: string;
  divider: string;
  accent: string;
  accentDim: string;
  levelBadgeBg: string;
  arrowColor: string;
}

export interface ChartColors {
  background: string;
  laneLine: string;
  judgmentLine: string;
  tapNote: string;
  holdNote: string;
  slideNote: string;
  scoreText: string;
  comboText: string;
  judgmentText: string;
  missText: string;
  pauseBtnBg: string;
  pauseBtnText: string;
  countdownText: string;
}

export const DarkAppearanceColors: AppearanceColors = {
  background: '#0D0D1A',
  primaryText: '#FFFFFF',
  secondaryText: '#AAAAAA',
  divider: '#333366',
  accent: '#FFD700',
  accentDim: '#AAAAAA',
  levelBadgeBg: '#333366',
  arrowColor: '#666699',
};

export const LightAppearanceColors: AppearanceColors = {
  background: '#EDEDED',
  primaryText: '#1A1A2E',
  secondaryText: '#666666',
  divider: '#CCCCCC',
  accent: '#D4A800',
  accentDim: '#666666',
  levelBadgeBg: '#DDDDDD',
  arrowColor: '#999999',
};

export const DarkChartColors: ChartColors = {
  background: '#0D0D1A',
  laneLine: '#333366',
  judgmentLine: '#FFFFFF',
  tapNote: '#00BFFF',
  holdNote: '#FF6B6B',
  slideNote: '#FFD700',
  scoreText: '#FFFFFF',
  comboText: '#FFD700',
  judgmentText: '#FFFFFF',
  missText: '#FF4500',
  pauseBtnBg: '#333366',
  pauseBtnText: '#FFFFFF',
  countdownText: '#FFFFFF',
};

export const LightChartColors: ChartColors = {
  background: '#F0F0F0',
  laneLine: '#BBBBBB',
  judgmentLine: '#333333',
  tapNote: '#006699',
  holdNote: '#CC3333',
  slideNote: '#B8860B',
  scoreText: '#1A1A2E',
  comboText: '#B8860B',
  judgmentText: '#333333',
  missText: '#CC3300',
  pauseBtnBg: '#DDDDDD',
  pauseBtnText: '#1A1A2E',
  countdownText: '#1A1A2E',
};
