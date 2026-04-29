@Component
export struct GearIconButton {
  @Prop iconColor: string = '#FFFFFF';
  onGearClick: () => void = () => {};

  build() {
    Stack() {
      Shape() {
        Path()
          .commands(
            'M12,2 L13.5,5.5 L17,4.5 L16.5,8 L20,9 L18,11.5 L21,12 L18,12.5 L20,15 L16.5,16 L17,19.5 L13.5,18.5 L12,22 L10.5,18.5 L7,19.5 L7.5,16 L4,15 L6,12.5 L3,12 L6,11.5 L4,9 L7.5,8 L7,4.5 L10.5,5.5 Z'
          )
          .stroke(this.iconColor)
          .strokeWidth(1.5)
          .fill(Color.Transparent)
        Circle()
          .width(7)
          .height(7)
          .stroke(this.iconColor)
          .strokeWidth(1.5)
          .fill(Color.Transparent)
      }
      .width(24)
      .height(24)
      .viewPort({ x: 0, y: 0, width: 24, height: 24 })
    }
    .width(44)
    .height(44)
    .alignContent(Alignment.Center)
    .onClick(() => {
      this.onGearClick();
    })
  }
}
