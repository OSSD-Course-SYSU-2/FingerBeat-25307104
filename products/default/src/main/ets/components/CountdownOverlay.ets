enum CountdownPhase {
  THREE,
  TWO,
  ONE,
  BEAT,
  DONE
}

@Component
export struct CountdownOverlay {
  @Link isActive: boolean;
  private phase: CountdownPhase = CountdownPhase.THREE;
  private timerId: number = -1;
  private onEndCallback: () => void = () => {};
  @State displayText: string = '';

  start(onEnd: () => void): void {
    this.onEndCallback = onEnd;
    this.isActive = true;
    this.phase = CountdownPhase.THREE;
    this.displayText = '3';
    this.scheduleNext(1000);
  }

  cancel(): void {
    if (this.timerId !== -1) {
      clearTimeout(this.timerId);
      this.timerId = -1;
    }
    this.isActive = false;
    this.phase = CountdownPhase.DONE;
    this.displayText = '';
  }

  private scheduleNext(delay: number): void {
    this.timerId = setTimeout(() => {
      this.advance();
    }, delay);
  }

  private advance(): void {
    if (!this.isActive) {
      return;
    }
    switch (this.phase) {
      case CountdownPhase.THREE:
        this.phase = CountdownPhase.TWO;
        this.displayText = '2';
        this.scheduleNext(1000);
        break;
      case CountdownPhase.TWO:
        this.phase = CountdownPhase.ONE;
        this.displayText = '1';
        this.scheduleNext(1000);
        break;
      case CountdownPhase.ONE:
        this.phase = CountdownPhase.BEAT;
        this.displayText = 'BEAT';
        this.scheduleNext(500);
        break;
      case CountdownPhase.BEAT:
        this.phase = CountdownPhase.DONE;
        this.isActive = false;
        this.displayText = '';
        this.timerId = -1;
        this.onEndCallback();
        break;
      default:
        break;
    }
  }

  build() {
    if (this.isActive) {
      Stack() {
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor('#80000000')
          .hitTestBehavior(HitTestMode.Block)

        Text(this.displayText)
          .fontSize(72)
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .height('100%')
    }
  }
}
