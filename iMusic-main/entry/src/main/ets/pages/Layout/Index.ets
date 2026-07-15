import { AiRecommend } from "./components/AiRecommend"
import { Find } from "./components/Find"
import { FloatingAiChat } from "./components/FloatingAiChat"
import { Mine } from "./components/Mine"
import { Moment } from "./components/Moment"
import { Recommend } from "./components/Recommend"

interface ITabItem {
  title: string,
  icon: ResourceStr,
}

@Builder
export function LayoutBuilder() {
  Layout()
}

@ComponentV2
struct Layout {
  pathStack: NavPathStack = new NavPathStack()

  tabData: ITabItem[] = [
    {
      title: 'Recommend',
      icon: $r('app.media.tab_tuijian')
    },
    {
      title: 'Find',
      icon: $r('app.media.tab_faxian')
    },
    {
      title: 'AI',
      icon: $r('app.media.search')
    },
    {
      title: 'Moment',
      icon: $r('app.media.tab_dongtai')
    },
    {
      title: 'Mine',
      icon: $r('app.media.tab_self')
    }
  ]

  @Local currentIndex: number = 0

  @Builder
  tabBarBuilder(tabItem: ITabItem, index: number) {
    Column({ space: 5 }) {
      Image(tabItem.icon)
        .width(24)
        .height(24)
        .fillColor(this.currentIndex === index ? '#f6716f' : '#eaca7f')
      Text(tabItem.title)
        .fontColor(this.currentIndex === index ? '#f6716f' : '#eaca7f')
        .fontSize(12)
        .fontWeight(this.currentIndex === index ? 600 : 300)
    }
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.BottomEnd }) {
        Tabs({ barPosition: BarPosition.End }) {
          ForEach(this.tabData, (item: ITabItem, index: number) => {
            TabContent() {
              if (index === 0) {
                Recommend()
              } else if (index === 1) {
                Find()
              } else if (index === 2) {
                AiRecommend()
              } else if (index === 3) {
                Moment()
              } else if (index === 4) {
                Mine()
              }
            }
            .tabBar(this.tabBarBuilder(item, index))
            .backgroundColor('#131215')
            .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
          })
        }
        .backgroundColor('#3B3F42')
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        .scrollable(false)
        .onChange((index: number) => {
          this.currentIndex = index
        })

        FloatingAiChat()
          .margin({ right: 12, bottom: 98 })
      }
    }
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
    })
  }
}
