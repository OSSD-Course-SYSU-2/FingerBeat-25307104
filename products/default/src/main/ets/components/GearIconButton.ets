@Component
export struct GearIconButton {
  @Prop iconColor: string = '#FFFFFF';
  onGearClick: () => void = () => {};

  build() {
    Image($r('app.media.gearshape'))
      .width(24)
      .height(24)
      .fillColor(this.iconColor)
      .onClick(() => {
        this.onGearClick();
      })
  }
}
