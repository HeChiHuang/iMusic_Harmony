import { ChartItem, HeatCell, buildTodayReport, demoUserMemory, getEmotionChart, getSceneChart } from '../../../models/AiMusicKnowledgeBase'

interface StatCard {
  label: string
  value: string
  hint: string
}

interface CloudTag {
  label: string
  size: number
  color: string
}

@Component
export struct Mine {
  private logoImage: ResourceStr = $r('app.media.iMusic_icon')

  private stats: StatCard[] = [
    { label: '今日听歌', value: `${demoUserMemory.todayMinutes}分钟`, hint: '比昨天多 12 分钟' },
    { label: '播放歌曲', value: `${demoUserMemory.todaySongs}首`, hint: '周杰伦 9 首' },
    { label: '偏好状态', value: '放松', hint: '适合夜晚和学习' }
  ]

  private cloudTags: CloudTag[] = [
    { label: '周杰伦', size: 24, color: '#F6C85F' },
    { label: '放松', size: 22, color: '#72D6A0' },
    { label: '学习', size: 20, color: '#6BA7FF' },
    { label: '夜晚', size: 19, color: '#8C7BFF' },
    { label: '怀旧', size: 18, color: '#F6A35F' },
    { label: '钢琴', size: 16, color: '#B8D7FF' },
    { label: '华语', size: 17, color: '#FF9AA2' }
  ]

  private heatCells: HeatCell[] = [
    { label: '08', value: 10 },
    { label: '10', value: 18 },
    { label: '12', value: 6 },
    { label: '14', value: 22 },
    { label: '16', value: 12 },
    { label: '18', value: 25 },
    { label: '20', value: 42 },
    { label: '22', value: 68 }
  ]

  getHeatColor(value: number): string {
    if (value >= 55) {
      return '#F6C85F'
    }
    if (value >= 35) {
      return '#72D6A0'
    }
    if (value >= 18) {
      return '#3E6C64'
    }
    return '#26302E'
  }

  @Builder
  heroCard() {
    Column({ space: 14 }) {
      Row() {
        Column({ space: 6 }) {
          Text('今日音乐日记')
            .fontColor('#131313')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
          Text('夜晚放松型')
            .fontColor('#4B3B12')
            .fontSize(13)
        }
        .layoutWeight(1)
        Text(`${demoUserMemory.todayMinutes}`)
          .fontColor('#131313')
          .fontSize(42)
          .fontWeight(FontWeight.Bold)
        Text('min')
          .fontColor('#4B3B12')
          .fontSize(13)
          .margin({ top: 18 })
      }
      .width('100%')

      Row({ space: 8 }) {
        Text(`听了 ${demoUserMemory.todaySongs} 首`)
          .fontColor('#131313')
          .fontSize(13)
          .fontWeight(FontWeight.Medium)
          .padding({ left: 10, right: 10, top: 5, bottom: 5 })
          .backgroundColor('#FFF2BF')
          .borderRadius(14)
        Text(`周杰伦 ${demoUserMemory.jayChouSongs} 首`)
          .fontColor('#131313')
          .fontSize(13)
          .fontWeight(FontWeight.Medium)
          .padding({ left: 10, right: 10, top: 5, bottom: 5 })
          .backgroundColor('#FFF2BF')
          .borderRadius(14)
      }
      .width('100%')
    }
    .width('100%')
    .padding(18)
    .backgroundColor('#F6C85F')
    .borderRadius(20)
  }

  @Builder
  insightCard(title: string, value: string, desc: string, color: string) {
    Column({ space: 5 }) {
      Text(title)
        .fontColor('#BDBDBD')
        .fontSize(11)
        .width('100%')
      Text(value)
        .fontColor(color)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .width('100%')
      Text(desc)
        .fontColor('#8A8A8A')
        .fontSize(10)
        .width('100%')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .layoutWeight(1)
    .height(78)
    .padding(10)
    .backgroundColor('#1B1B1B')
    .borderRadius(12)
  }

  @Builder
  artistCard() {
    Row({ space: 12 }) {
      Column({ space: 5 }) {
        Text('今日最常听')
          .fontColor('#A8A8A8')
          .fontSize(12)
        Text('周杰伦')
          .fontColor(Color.White)
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
        Text('9 首歌，占今天播放的一半以上')
          .fontColor('#8A8A8A')
          .fontSize(12)
      }
      .layoutWeight(1)
      Text('9')
        .fontColor('#131313')
        .fontSize(34)
        .fontWeight(FontWeight.Bold)
        .width(58)
        .height(58)
        .textAlign(TextAlign.Center)
        .backgroundColor('#F6C85F')
        .borderRadius(18)
    }
    .width('100%')
    .padding(14)
    .backgroundColor('#202020')
    .borderRadius(16)
  }

  @Builder
  sectionTitle(title: string, desc: string) {
    Column({ space: 4 }) {
      Text(title)
        .fontColor(Color.White)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .width('100%')
      Text(desc)
        .fontColor('#A8A8A8')
        .fontSize(12)
        .lineHeight(18)
        .width('100%')
    }
    .width('100%')
  }

  @Builder
  statCard(item: StatCard) {
    Column({ space: 5 }) {
      Text(item.label)
        .fontColor('#BDBDBD')
        .fontSize(12)
        .width('100%')
      Text(item.value)
        .fontColor('#F6C85F')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .width('100%')
      Text(item.hint)
        .fontColor('#8A8A8A')
        .fontSize(11)
        .width('100%')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .layoutWeight(1)
    .height(88)
    .padding(12)
    .backgroundColor('#202020')
    .borderRadius(12)
  }

  @Builder
  progressBar(item: ChartItem) {
    Column({ space: 6 }) {
      Row() {
        Text(item.label)
          .fontColor('#EFEFEF')
          .fontSize(13)
          .layoutWeight(1)
        Text(`${item.value}%`)
          .fontColor('#BDBDBD')
          .fontSize(12)
      }
      .width('100%')
      Stack({ alignContent: Alignment.Start }) {
        Row() {
        }
          .width('100%')
          .height(8)
          .backgroundColor('#303030')
          .borderRadius(4)
        Row() {
        }
          .width(`${item.value}%`)
          .height(8)
          .backgroundColor(item.color)
          .borderRadius(4)
      }
      .width('100%')
      .height(8)
    }
    .width('100%')
  }

  @Builder
  tagCloud() {
    Flex({ wrap: FlexWrap.Wrap }) {
      ForEach(this.cloudTags, (item: CloudTag) => {
        Text(item.label)
          .fontColor(item.color)
          .fontSize(item.size)
          .fontWeight(item.size >= 20 ? FontWeight.Bold : FontWeight.Medium)
          .margin({ right: 14, bottom: 12 })
      })
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#202020')
    .borderRadius(12)
  }

  @Builder
  heatMap() {
    Row({ space: 7 }) {
      ForEach(this.heatCells, (item: HeatCell) => {
        Column({ space: 3 }) {
          Text(item.label)
            .fontColor('#131313')
            .fontSize(11)
            .fontWeight(FontWeight.Bold)
          Text(`${item.value}`)
            .fontColor('#131313')
            .fontSize(10)
        }
        .layoutWeight(1)
        .height(42)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .backgroundColor(this.getHeatColor(item.value))
        .borderRadius(8)
      })
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#202020')
    .borderRadius(12)
  }

  build() {
    Scroll() {
      Column({ space: 16 }) {
        Row({ space: 14 }) {
          Image(this.logoImage)
            .width(68)
            .height(68)
            .borderRadius(18)
          Column({ space: 6 }) {
            Text('我的音乐')
              .fontSize(25)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
              .width('100%')
            Text('今天听了什么，偏好就藏在这里。')
              .fontSize(13)
              .fontColor('#A8A8A8')
              .width('100%')
            Text('今日状态：夜晚放松')
              .fontSize(13)
              .fontColor('#131313')
              .fontWeight(FontWeight.Bold)
              .padding({ left: 10, right: 10, top: 4, bottom: 4 })
              .backgroundColor('#F6C85F')
              .borderRadius(12)
          }
          .layoutWeight(1)
        }
        .width('100%')
        .padding({ top: 20 })

        this.heroCard()

        Row({ space: 8 }) {
          this.insightCard('最高峰', '22:00', '夜晚听歌最多', '#F6C85F')
          this.insightCard('主情绪', '放松', '适合轻音乐', '#72D6A0')
          this.insightCard('今日风格', '华语', '熟悉感更强', '#FF9AA2')
        }
        .width('100%')

        this.artistCard()

        Row({ space: 8 }) {
          ForEach(this.stats, (item: StatCard) => {
            this.statCard(item)
          })
        }
        .width('100%')

        this.sectionTitle('今日关键词', '根据今天的播放记录生成')
        this.tagCloud()

        this.sectionTitle('听歌时段', '今天每个时段的播放分钟数')
        this.heatMap()

        Column({ space: 12 }) {
          Text('情绪分布')
            .fontColor(Color.White)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .width('100%')
          ForEach(getEmotionChart(), (item: ChartItem) => {
            this.progressBar(item)
          })
        }
        .padding(12)
        .backgroundColor('#202020')
        .borderRadius(12)
        .width('100%')

        Column({ space: 12 }) {
          Text('场景分布')
            .fontColor(Color.White)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .width('100%')
          ForEach(getSceneChart(), (item: ChartItem) => {
            this.progressBar(item)
          })
        }
        .padding(12)
        .backgroundColor('#202020')
        .borderRadius(12)
        .width('100%')

        Column({ space: 8 }) {
          Text('今日小结')
            .fontColor('#F6C85F')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .width('100%')
          Text(buildTodayReport())
            .fontColor('#EFEFEF')
            .fontSize(13)
            .lineHeight(20)
            .width('100%')
        }
        .padding(14)
        .backgroundColor('#1B1B1B')
        .borderRadius(12)
        .width('100%')
      }
      .width('100%')
      .padding({ left: 14, right: 14, bottom: 92 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#131313')
    .scrollBar(BarState.Off)
  }
}
