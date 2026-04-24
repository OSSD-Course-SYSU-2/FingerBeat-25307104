import { hilog } from '@kit.PerformanceAnalysisKit';

const LOG_DOMAIN: number = 0xFF00;
const LOG_PREFIX: string = 'FingerBeat';
const LOG_FORMAT: string = '%{public}s, %{public}s';

export class Logger {
  private readonly prefix: string = 'testTag';
  private readonly domain: number = 0xFF00;
  private readonly format: string = '%{public}s, %{public}s';

  public debug(...args: string[]): void {
    hilog.debug(this.domain, this.prefix, this.format, args);
  }

  public info(...args: string[]): void {
    hilog.info(this.domain, this.prefix, this.format, args);
  }

  public warn(...args: string[]): void {
    hilog.warn(this.domain, this.prefix, this.format, args);
  }

  public error(...args: string[]): void {
    hilog.error(this.domain, this.prefix, this.format, args);
  }

  // Static convenience methods for module-level logging
  public static debug(...args: string[]): void {
    hilog.debug(LOG_DOMAIN, LOG_PREFIX, LOG_FORMAT, args);
  }

  public static info(...args: string[]): void {
    hilog.info(LOG_DOMAIN, LOG_PREFIX, LOG_FORMAT, args);
  }

  public static warn(...args: string[]): void {
    hilog.warn(LOG_DOMAIN, LOG_PREFIX, LOG_FORMAT, args);
  }

  public static error(...args: string[]): void {
    hilog.error(LOG_DOMAIN, LOG_PREFIX, LOG_FORMAT, args);
  }
}