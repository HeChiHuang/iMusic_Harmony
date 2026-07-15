let timeInterval: undefined|number = undefined

@Builder
export function SplashAdBuilder(){
  SplashAd()
}

@ComponentV2
struct SplashAd{
  // 控制跳转的对象
  pathStack: NavPathStack = new NavPathStack()
  @Local lastSecond: number = 3

  // 3s后自动跳转到布局页面
  aboutToAppear(): void {
      //  打开页面自动执行，生命周期函数
    if(timeInterval){
      clearTimeout(timeInterval)
      this.lastSecond = 3
    }

    timeInterval = setInterval(()=>{
      if(this.lastSecond <= 1){
        this.pathStack.replacePathByName('Layout', null, false)
        clearTimeout(timeInterval)
      }

      this.lastSecond--

    },1000)

  }

  build() {
    NavDestination(){
      Stack({alignContent:Alignment.TopEnd}){
        // 背景广告
        Image($r('app.media.ad'))
          .width('100%')
          .height('100%')
          .expandSafeArea([SafeAreaType.SYSTEM],[SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        // 跳转广告
        Button(`${this.lastSecond}s后跳过`)
          .backgroundColor(Color.Gray)
          .margin({
            right: 15
          })
          .onClick(()=>{
            if(timeInterval){
              clearTimeout(timeInterval)
              this.lastSecond = 3
            }

            this.pathStack.replacePathByName('Layout', null, false)
          })
      }
    }
    // .title('开屏广告')
    .onReady((context: NavDestinationContext)=>{
      this.pathStack = context.pathStack
    })
  }
}
