import { media } from '@kit.MediaKit'
import { GlobalMusic,PlayMode } from '../models/GlobalMusic'
import { SongItemType } from '../models/music'
import { AppStorageV2 } from '@kit.ArkUI'
import { sessionManager } from './AVSessionManager'

class AvPlayerManager {
  // 播放器
  player: media.AVPlayer | null = null

  // 共享播放数据
  currentSong: GlobalMusic = AppStorageV2.connect(GlobalMusic, 'SONG_KEY', ()=> new GlobalMusic())!

  // 定义方法  创建播放器 + 监听播放器的状态
  async init(){
    if(!this.player){
      this.player = await media.createAVPlayer()
    }

    // 监听播放器状态的变化
    this.player.on('stateChange', state => {
      if(state === 'initialized'){  //  初始化
        this.player?.prepare()
      }else if(state === 'prepared'){ //  准备好
        this.player?.play()
        this.currentSong.isPlay = true
      }else if(state === 'completed'){  //  播放完成
        switch (this.currentSong.playMode){
          case PlayMode.repeat:
            // 单曲循环播放完应该重新播放
            this.changeSong()
            break
          default :
            if(this.currentSong.playList?.length>1){
              //  随机/顺序模式，且歌曲大于1首，才要下一首
             this.prePlay()
            }else{
              // 只有一首的话应该要重置播放器
              this.seekPlay(0)
              this.paused()
            }
            break
        }
      }else if(state === 'released'){
        console.log('player===>', state)
        this.currentSong.reset() // 重置数据
      }
    })

    // 监听音乐总时长的变化
    this.player.on('durationUpdate', duration => {
      this.currentSong.duration = duration
      sessionManager.setAVMetadata(this.currentSong.playList[this.currentSong.playIndex])
    })

    // 监听播放时间的变化
    this.player.on('timeUpdate', time => {
      this.currentSong.time = time
      sessionManager.setAVPlayBackState()

      // if(this.currentSong.duration === time){
      //   // 歌曲播放完成
      //   switch (this.currentSong.playMode){
      //     case PlayMode.repeat:
      //      // 单曲循环播放完应该重新播放
      //      this.changeSong()
      //      break
      //     default :
      //       if(this.currentSong.playList?.length>1){
      //         //  随机/顺序模式，且歌曲大于1首，才要下一首
      //         this.prePlay()
      //       }else{
      //         // 只有一首的话应该要重置播放器
      //         this.seekPlay(0)
      //         this.paused()
      //       }
      //       break
      //   }
      // }
    })
  }

  // 播放歌曲 + 设置播放器资源
  // singPlay(song: SongItemType){
  //   this.player!.url = song.url
  //   this.currentSong.img = song.img
  // }
  singPlay(song: SongItemType){
    // 申请长时任务
    sessionManager.startBackgroundTask()
    // 设置播放状态
    sessionManager.setAVPlayBackState()

    if(this.currentSong.playList.some((item:SongItemType)=>item.id === song.id)){
      // 存在播放列表
      if(this.currentSong.url === song.url){
        // 如果是正在播的歌曲，那就继续播放
        this.player?.play()
        this.currentSong.isPlay = true
      }else{
        // 如果不是正在播放的歌曲,则播放当前歌曲
        this.currentSong.playIndex = this.currentSong.playList.findIndex(item=> item.id === song.id)
        this.changeSong()
      }
    }else{
      // 不存在播放列表，则把歌曲放入进去
      this.currentSong.playList.unshift(song)
      this.currentSong.playIndex = 0
      // 切换歌曲？
      this.changeSong()
    }
  }

  // 切换歌曲 => 重置播放器
  async changeSong(){
    await this.player?.reset() // 重置播放器
    this.currentSong.duration = 0
    this.currentSong.time = 0
    const _playIndex = this.currentSong.playIndex
    this.currentSong.img = this.currentSong.playList[_playIndex].img
    this.currentSong.name = this.currentSong.playList[_playIndex].name
    this.currentSong.author = this.currentSong.playList[_playIndex].author
    this.currentSong.url = this.currentSong.playList[_playIndex].url
    this.player!.url = this.currentSong.url
  }

  // 设置播放跳转进度
  seekPlay(val: number){
    this.player?.seek(val)
  }

  // 暂停播放
  paused(){
    this.player?.pause()
    this.currentSong.isPlay = false
    sessionManager.setAVPlayBackState()
  }

  // 上一首
  prePlay(){
    switch (this.currentSong.playMode){
      case PlayMode.auto:  //  顺序
        this.currentSong.playIndex--
        if(this.currentSong.playIndex < 0){
          this.currentSong.playIndex = this.currentSong.playList.length -1
        }
        break
      case PlayMode.random:  //  随机（如果生成的一样，则重新生成）
        const _playIndex = Math.floor(Math.random() * this.currentSong.playList.length)
        if(_playIndex === this.currentSong.playIndex && this.currentSong.playList.length !== 1){
          this.prePlay()
        }else{
          this.currentSong.playIndex = _playIndex
        }
        break
      default:  //  单曲
        break
    }
    this.singPlay(this.currentSong.playList[this.currentSong.playIndex])
  }

  // 下一首
  nextPlay(){
    switch (this.currentSong.playMode){
      case PlayMode.auto:  //  顺序
        this.currentSong.playIndex++
        if(this.currentSong.playIndex >= this.currentSong.playList.length){
          this.currentSong.playIndex = 0
        }
        break
      case PlayMode.random:   //  随机（如果生成的一样，则重新生成）
        const _playIndex = Math.floor(Math.random() * this.currentSong.playList.length)
        if(_playIndex === this.currentSong.playIndex && this.currentSong.playList.length !== 1){
          this.nextPlay()
        }else{
          this.currentSong.playIndex = _playIndex
        }
        break
      default:  //  单曲
        break
    }
    this.singPlay(this.currentSong.playList[this.currentSong.playIndex])
  }

  //  删除播放的歌曲
  removeSong(index:number){
    // 删除播放列表的歌曲
    this.currentSong.playList.splice(index, 1)

    if(this.currentSong.playIndex === index){
      // 如果删除的是当前播放
      if(this.currentSong.playList.length > 1){
        // 播放列表大于1首，删除后播放下一首
        switch (this.currentSong.playMode){
          case PlayMode.repeat:  // 单曲循环的话
            // 删除的是最后一首，则播放第一首；删除的不是最后一首，则播放下一首
            this.currentSong.playIndex = this.currentSong.playList.length === index ? 0 : index
          case PlayMode.auto: //  列表播放
            this.changeSong()
            break
          default : //  随机
            this.prePlay()
            break
        }
      }else if(this.currentSong.playList.length === 1){
        // 删除后只剩一首
        this.singPlay(this.currentSong.playList[0])
      }else{
        // 一首都没有，回到发现页面
        // this.paused() //  暂停播放
        this.player?.reset()  //  重置播放器
        this.currentSong.reset() // 重置数据
      }
    }
  }

  // 释放播放器 和 播放数据
  async release(){
    await this.player?.release()
  }

}

export const playerManager: AvPlayerManager = new AvPlayerManager()
