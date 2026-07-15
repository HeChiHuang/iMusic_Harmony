import { TitleBuilder } from "../../builder/TitleBuilder"


interface recommendDailyType {
  img: string
  title: string
  type: string
  top: string
  bottom: string
}

interface recommendListType {
  img: string
  title: string
  count: string
}

@ComponentV2
export struct Recommend{
  @Local inputVal:string|undefined = undefined
  controller: TextInputController = new TextInputController();
  swiperList: string[] = [
    'https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/banner1.png',
    'https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/banner2.png',
    'https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/banner3.png',
    'https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/banner4.png',
    'https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/banner5.png',
  ]
  dailyRecommend: recommendDailyType[] = [
    {
      img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/recommend1.png',
      title: '每日推荐 | 今天从《不得不爱》听起 | 私人雷达',
      type: '每日推荐',
      top: '#660000',
      bottom: '#382e2f'
    },
    {
      img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/recommend2.png',
      title: '从 [Nothing on Me] 开启无限漫游',
      type: '私人漫游',
      top: '#382e2f',
      bottom: '#a37862'
    },
    {
      img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/recommend3.png',
      title: '每日推荐 | 今天从《不得不爱》听起 | 私人雷达',
      type: '华语流行',
      top: '#a37862',
      bottom: '#174847'
    },
    {
      img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/recommend4.png',
      title: '每日推荐 | 今天从《不得不爱》听起 | 私人雷达',
      type: '私人雷达',
      top: '#174847',
      bottom: '#174847'
    }
  ]
  recommendList: recommendListType[] = [
    {
      img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/list1.jpg',
      title: '每日推荐 | 今天从《不得不爱》听起 | 私人雷达',
      count: '270.9万'
    },
    {
      img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/list2.jpg',
      title: 'Yasuo和更多好听的 | 华语私人雷达 | 回忆8090',
      count: '476.1万'
    },
    {
      img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/list3.jpg',
      title: 'Trap Remix丨当欧美热单遇上毒性低音',
      count: '186.3万'
    },
    {
      img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/list4.jpg',
      title: '满级人类进化之路必备BGM | 根本停不下来',
      count: '186.3万'
    },
    {
      img: 'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/list5.jpg',
      title: '认真去聆听这个世界的每一分每一秒 (强烈推荐)',
      count: '362.8万'
    }
  ]


  build() {
    Column({space:8}){
      // 搜索区域
      Row(){
        Image($r('app.media.search'))
          .width(22)
          .fillColor('#817D83')

        TextInput({
          placeholder: '只因你太美🔥',
          controller: this.inputVal?  this.controller : undefined
        })
          .placeholderColor('#817D83')
          .textIndent(2)
          .fontColor('#999')
          .layoutWeight(1)
          .cancelButton({
            style: CancelButtonStyle.INPUT,
            icon:{
              size: 22,
              color: '#817D83'
            }
          })
          .onChange(text=>{
            this.inputVal = text
          })

        Image($r('app.media.code'))
          .width(20)
          .fillColor('#817D83')
      }
      .width('100%')
      .backgroundColor('#2D2B29')
      .border({ radius: 20 })
      .padding({ left: 8, right: 8 })

      // swiper广告区域
      Swiper(){
        ForEach(this.swiperList,(item:string)=>{
          Image(item)
            .width('100%')
            .height(168)
            .borderRadius(10)
        })
      }
      .autoPlay(true)

      // 每日推荐
      TitleBuilder('每日推荐')

      // 每日推荐——内容
      List(){
        ForEach(this.dailyRecommend,(item:recommendDailyType)=>{
          ListItem(){
            Column(){
              Text(item.type)
                .width('100%')
                .height(40)
                .backgroundColor(item.top)
                .padding({left:5})
                .fontSize(14)
                .fontColor('#fff')
              Image(item.img)
                .width('100%')
              Text(item.title)
                .width('100%')
                .backgroundColor(item.bottom)
                .padding(5)
                .fontSize(14)
                .fontColor('#fff')
                .maxLines(2)  //  最多显示2行
                .textOverflow({overflow: TextOverflow.Ellipsis})  //  超出部分显示
            }
            .width('40%')
            // .height(200)
            // .backgroundColor(Color.Pink)
            .border({radius:10})
            .margin({right: 10})
            .clip(true) //  裁剪
          }
        })
      }
      .listDirection(Axis.Horizontal) //  调整布局方向，布局虽然改变，但还是占垂直方向的内容
      .height(230)
      .scrollBar(BarState.Off)  // 取消滚动条

      // 推荐歌单
      TitleBuilder('推荐歌单')
      List(){
        ForEach(this.recommendList,(item:recommendListType)=>{
          ListItem(){
            Column(){
              Stack({alignContent: Alignment.TopStart}){
                Image(item.img)
                  .width('100%')
                  .height(100)
                  .borderRadius(8)
                Text(item.count)
                  .width('100%')
                  .fontSize(12)
                  .fontColor('#fff')
                  .fontWeight(700)
                  .margin(5)
              }
              Text(item.title)
                .width('100%')
                .padding(5)
                .fontSize(14)
                .fontColor('#fff')
                .maxLines(2)  //  最多显示2行
                .textOverflow({overflow: TextOverflow.Ellipsis})  //  超出部分显示
            }
            .width('30%')
            // .height(200)
            .border({radius:10})
            .margin({right: 10})
            .clip(true) //  裁剪
          }
        })
      }
      .listDirection(Axis.Horizontal) //  调整布局方向，布局虽然改变，但还是占垂直方向的内容
      .height(230)
      .scrollBar(BarState.Off)  // 取消滚动条

    }
    .width('100%')
    .height('100%')
    .padding({
      left: 10,
      right: 10,
      top: 5,
      bottom: 5
    })
  }
}
