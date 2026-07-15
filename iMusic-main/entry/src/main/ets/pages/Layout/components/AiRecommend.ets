import { AppStorageV2 } from '@kit.ArkUI'
import { http } from '@kit.NetworkKit'
import {
  buildMusicAssistantContext,
  buildCatalogMemoryMd,
  getAssistantMemoryMd,
  getTagSchemaMd,
  ScoredMusic,
  inferIntent,
  rankSongs
} from '../../../models/AiMusicKnowledgeBase'
import { playerManager } from '../../../utils/AVPlayerManager'

interface QuickScene {
  label: string
  query: string
}

interface ChatMessage {
  role: string
  content: string
}

interface MusicAiChoice {
  message: ChatMessage
}

interface MusicAiResponse {
  choices: MusicAiChoice[]
  error?: MusicAiError
}

interface MusicAiError {
  message: string
}

interface MusicAiRequestBody {
  model: string
  messages: ChatMessage[]
  temperature: number
  max_tokens: number
  stream: boolean
}

const MUSIC_AI_API_KEY = 'sk-37dad59843cf404d8248da6b06fbd81a'
const MUSIC_AI_MODEL = 'deepseek-chat'

@ComponentV2
export struct AiRecommend {
  pathStack: NavPathStack = AppStorageV2.connect(NavPathStack, 'navStack', () => new NavPathStack())!
  @Local inputText: string = '想听周杰伦或者校园感强一点的歌'
  @Local isAiLoading: boolean = false
  @Local xiaoLeReply: string = '告诉小乐你现在的心情，我会先理解你的状态，再给你解释几首更合适的歌。'
  @Local updateText: string = '已根据你今天的听歌偏好准备推荐'
  @Local intentTitle: string = '怀旧回忆'
  @Local intentSubtitle: string = '熟悉一点的旋律'
  @Local rankedSongs: ScoredMusic[] = rankSongs('想听周杰伦或者校园感强一点的歌').slice(0, 4)
  @Local history: ChatMessage[] = []

  quickScenes: QuickScene[] = [
    { label: '睡前放松', query: '我今晚有点焦虑，想听安静一点的歌' },
    { label: '学习专注', query: '我在学习，想听低干扰背景音乐' },
    { label: '运动高能', query: '我要跑步，想听节奏强一点的歌' },
    { label: '怀旧回忆', query: '想听周杰伦或者校园感强一点的歌' }
  ]

  buildMessages(userInput: string): ChatMessage[] {
    const messages: ChatMessage[] = [
      { role: 'system', content: getAssistantMemoryMd() },
      { role: 'system', content: getTagSchemaMd() },
      { role: 'system', content: buildCatalogMemoryMd(100) }
    ]
    this.history.slice(-4).forEach((item: ChatMessage) => {
      messages.push(item)
    })
    messages.push({
      role: 'user',
      content: buildMusicAssistantContext(userInput, 6)
    })
    return messages
  }

  getLocalReply(userInput: string): string {
    const songs = rankSongs(userInput).slice(0, 5)
    let reply = '小乐先为你挑这几首，整体会更贴近你现在的状态：\n\n'
    songs.forEach((item: ScoredMusic, index: number) => {
      reply += `${index + 1}. 《${item.song.clusterName}》-${item.song.author}\n${item.userReason}\n`
    })
    return reply
  }

  updateRecommendState(userInput: string) {
    const intent = inferIntent(userInput)
    this.intentTitle = intent.title
    this.intentSubtitle = intent.subtitle
    this.rankedSongs = rankSongs(userInput).slice(0, 4)
    this.updateText = `已切换到：${intent.title}`
  }

  async askXiaoLe() {
    if (this.inputText.trim().length === 0 || this.isAiLoading) {
      return
    }

    const userInput = this.inputText
    this.updateRecommendState(userInput)
    this.isAiLoading = true
    this.xiaoLeReply = '小乐正在为你分析...'

    const client = http.createHttp()
    const body: MusicAiRequestBody = {
      model: MUSIC_AI_MODEL,
      messages: this.buildMessages(userInput),
      temperature: 0.75,
      max_tokens: 760,
      stream: false
    }

    try {
      const response = await client.request('https://api.deepseek.com/chat/completions', {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${MUSIC_AI_API_KEY}`
        },
        extraData: JSON.stringify(body),
        connectTimeout: 10000,
        readTimeout: 18000
      })
      const result = JSON.parse(response.result as string) as MusicAiResponse
      if (result.error || !result.choices || result.choices.length === 0 || !result.choices[0].message.content) {
        this.xiaoLeReply = this.getLocalReply(userInput)
        return
      }
      const answer = result.choices[0].message.content
      this.xiaoLeReply = answer
      this.history.push({ role: 'user', content: userInput })
      this.history.push({ role: 'assistant', content: answer })
    } catch (error) {
      this.xiaoLeReply = this.getLocalReply(userInput)
    } finally {
      client.destroy()
      this.isAiLoading = false
    }
  }

  @Builder
  sceneButton(item: QuickScene) {
    Button(item.label)
      .height(34)
      .fontSize(13)
      .fontColor('#F2F2F2')
      .backgroundColor('#2B2B2B')
      .borderRadius(17)
      .margin({ right: 8 })
      .onClick(() => {
        this.inputText = item.query
        this.updateRecommendState(item.query)
        this.xiaoLeReply = '已切换心情场景，点“问小乐”可以生成新的推荐解释。'
      })
  }

  @Builder
  tagChip(text: string) {
    Text(text)
      .fontColor('#F6C85F')
      .fontSize(11)
      .padding({ left: 8, right: 8, top: 4, bottom: 4 })
      .backgroundColor('#2C2A22')
      .borderRadius(10)
      .margin({ right: 6 })
  }

  @Builder
  songCard(item: ScoredMusic) {
    Row({ space: 12 }) {
      Image(item.song.img)
        .width(74)
        .height(74)
        .borderRadius(12)

      Column({ space: 7 }) {
        Row() {
          Text(item.song.clusterName)
            .fontColor(Color.White)
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .layoutWeight(1)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          Text(`${item.score}%`)
            .fontColor('#F6C85F')
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
        }
        .width('100%')

        Text(item.song.author)
          .fontColor('#929292')
          .fontSize(12)
          .width('100%')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Row() {
          ForEach(item.chips, (tag: string) => {
            this.tagChip(tag)
          })
        }
        .width('100%')

        Text(item.userReason)
          .fontColor('#D2D2D2')
          .fontSize(13)
          .lineHeight(18)
          .width('100%')
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .layoutWeight(1)
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#202020')
    .borderRadius(14)
    .onClick(() => {
      playerManager.singPlay(item.song)
      this.pathStack.pushPathByName('Play', null, false)
    })
  }

  build() {
    Scroll() {
      Column({ space: 16 }) {
        Column({ space: 6 }) {
          Text('小乐想听')
            .fontColor(Color.White)
            .fontSize(26)
            .fontWeight(FontWeight.Bold)
            .width('100%')
          Text('说一句现在的心情，我来帮你挑几首。')
            .fontColor('#A8A8A8')
            .fontSize(13)
            .width('100%')
        }
        .width('100%')
        .margin({ top: 18 })

        Column({ space: 10 }) {
          Row({ space: 8 }) {
            TextInput({ text: this.inputText, placeholder: '例如：我想听安静一点的歌' })
              .height(46)
              .fontColor('#F4F4F4')
              .placeholderColor('#777777')
              .backgroundColor('#242424')
              .borderRadius(14)
              .padding({ left: 12, right: 12 })
              .layoutWeight(1)
              .onChange((value: string) => {
                this.inputText = value
              })

            Button(this.isAiLoading ? '分析中' : '问小乐')
              .height(46)
              .width(82)
              .fontColor('#131313')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .backgroundColor('#F6C85F')
              .borderRadius(14)
              .enabled(!this.isAiLoading)
              .onClick(() => {
                this.askXiaoLe()
              })
          }
          .width('100%')

          Text(this.updateText)
            .fontColor('#F6C85F')
            .fontSize(13)
            .fontWeight(FontWeight.Medium)
            .width('100%')

          List() {
            ForEach(this.quickScenes, (item: QuickScene) => {
              ListItem() {
                this.sceneButton(item)
              }
            })
          }
          .height(40)
          .listDirection(Axis.Horizontal)
          .scrollBar(BarState.Off)

          Column({ space: 8 }) {
            Row({ space: 8 }) {
              Image($r('app.media.iMusic_icon'))
                .width(26)
                .height(26)
                .borderRadius(8)
              Text('小乐')
                .fontColor(Color.White)
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
            }
            .width('100%')

            Scroll() {
              Text(this.xiaoLeReply)
                .fontColor('#EFEFEF')
                .fontSize(14)
                .lineHeight(21)
                .width('100%')
            }
            .height(176)
            .scrollBar(BarState.Auto)
          }
          .width('100%')
          .padding(14)
          .backgroundColor('#1F1F1F')
          .borderRadius(14)
        }
        .width('100%')

        Column({ space: 8 }) {
          Text(this.intentTitle)
            .fontColor('#F6C85F')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .width('100%')
          Text(this.intentSubtitle)
            .fontColor('#D4D4D4')
            .fontSize(13)
            .width('100%')
        }
        .width('100%')
        .padding(14)
        .backgroundColor('#1B1B1B')
        .borderRadius(14)

        Text('为你推荐')
          .fontColor(Color.White)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .width('100%')

        ForEach(this.rankedSongs, (item: ScoredMusic) => {
          this.songCard(item)
        })
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
