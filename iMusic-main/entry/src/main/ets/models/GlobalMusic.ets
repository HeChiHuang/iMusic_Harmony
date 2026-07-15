import { SongItemType } from "./music"

export enum PlayMode {
  auto = 'auto',
  random = 'random',
  repeat = 'repeat',
}

@ObservedV2
export class GlobalMusic {
  @Trace img: string = ''  //  音乐时间
  @Trace name: string = '' //  音乐名称
  @Trace author: string = '' //  作者
  @Trace url: string = ''  //  当前播放地址
  @Trace time: number = 0  //  播放时长
  @Trace duration: number = 0  //  音乐的播放时长

  // 歌曲列表
  @Trace playIndex: number = 0 // 当前播放的歌曲
  @Trace playList: SongItemType[] = []  //  播放列表

  // 歌曲播放状态
  @Trace isPlay: boolean = false

  // 歌曲播放模式
  @Trace playMode: PlayMode = PlayMode.auto  //  默认顺序播放

  // 重置数据
  reset(){
    this.img = ''
    this.name = ''
    this.author = ''
    this.url = ''
    this.time = 0
    this.duration = 0
    this.playIndex = 0
    this.playList = []
    this.isPlay = false
  }
}
