import { avSession } from '@kit.AVSessionKit'
import backgroundTaskManager from '@ohos.resourceschedule.backgroundTaskManager'
import { wantAgent } from '@kit.AbilityKit';
import { SongItemType } from '../models/music';
import { GlobalMusic } from '../models/GlobalMusic';
import { AppStorageV2 } from '@kit.ArkUI';
import { playerManager } from './AVPlayerManager';

class AvSessionManager {
  session: avSession.AVSession | null = null
  playSate: GlobalMusic = AppStorageV2.connect(GlobalMusic, 'SONG_KEY', ()=>new GlobalMusic())!

  // 初始化
  async init(content: Context){
    this.session = await avSession.createAVSession(content, 'BG_PLAY', 'audio')

    this.registerEvent()
  }

  // 申请长时任务
  async  startBackgroundTask(){
    let wantAgentInfo: wantAgent.WantAgentInfo = {
      // 点击通知后，将要执行的动作列表
      // 添加需要被拉起应用的bundleName和abilityName
      wants: [
        {
          bundleName: "com.example.imusic",
          abilityName: "EntryAbility"
        }
      ],
      // 指定点击通知栏消息后的动作是拉起ability
      actionType: wantAgent.OperationType.START_ABILITY,
      // 使用者自定义的一个私有值
      requestCode: 0,
      // 点击通知后，动作执行属性
      actionFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG],
      // 车钥匙长时任务子类型，从API version 16开始支持。只有申请bluetoothInteraction类型的长时任务，车钥匙子类型才能生效。
      // 确保extraInfo参数中的Key值为backgroundTaskManager.BackgroundModeType.SUB_MODE，否则子类型不生效。
      // extraInfo: { [backgroundTaskManager.BackgroundModeType.SUB_MODE] : backgroundTaskManager.BackgroundSubMode.CAR_KEY }
    };

    const want = await wantAgent.getWantAgent(wantAgentInfo)

    await backgroundTaskManager.startBackgroundRunning(getContext(), backgroundTaskManager.BackgroundMode.AUDIO_PLAYBACK, want)
  }

  // 设置元数据
  setAVMetadata (song: SongItemType){
    this.session?.setAVMetadata({
      assetId: song.id,
      title: song.name,
      mediaImage: song.img,
      artist: song.author,
      duration: this.playSate.duration
    })
  }

  // 设置播放状态
  setAVPlayBackState(){
    this.session?.setAVPlaybackState({
      state: this.playSate.isPlay? avSession.PlaybackState.PLAYBACK_STATE_PLAY:avSession.PlaybackState.PLAYBACK_STATE_PAUSE,
      speed: 1,
      position: {
        elapsedTime: this.playSate.time,
        updateTime: new Date().getTime()
      },
      duration: this.playSate.duration
    })
  }

  // 注册事件
  registerEvent(){
    this.session?.on('play',()=>{
      playerManager.singPlay(this.playSate.playList[this.playSate.playIndex])
    })
    this.session?.on('pause',()=>{
      playerManager.paused()
    })
    this.session?.on('playPrevious',()=>{
      playerManager.prePlay()
    })
    this.session?.on('playNext',()=>{
      playerManager.nextPlay()
    })
    this.session?.on('seek',(val:number)=>{
      playerManager.seekPlay(val)
    })

    // 激活session
    this.session?.activate()
  }

  // 注销会话
  async destroy(){
    await this.session?.destroy()
  }
}

export const sessionManager:AvSessionManager = new AvSessionManager()
