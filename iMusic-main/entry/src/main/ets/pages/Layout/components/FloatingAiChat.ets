import { http } from '@kit.NetworkKit'
import {
  buildMusicAssistantContext,
  buildCatalogMemoryMd,
  getAssistantMemoryMd,
  getTagSchemaMd,
  rankSongs,
  ScoredMusic
} from '../../../models/AiMusicKnowledgeBase'

const MUSIC_AI_API_KEY = 'sk-37dad59843cf404d8248da6b06fbd81a'
const MUSIC_AI_MODEL = 'deepseek-chat'

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

@ComponentV2
export struct FloatingAiChat {
  @Local isOpen: boolean = false
  @Local isLoading: boolean = false
  @Local inputText: string = '我今晚有点焦虑，想听安静一点的歌'
  @Local replyText: string = '你好，我是智能音乐注释助手小乐。你可以告诉我现在的心情，我会结合你的听歌习惯，为你解释几首更合适的歌。'
  @Local history: ChatMessage[] = []

  getMessages(userInput: string): ChatMessage[] {
    const messages: ChatMessage[] = [
      {
        role: 'system',
        content: getAssistantMemoryMd()
      },
      {
        role: 'system',
        content: getTagSchemaMd()
      },
      {
        role: 'system',
        content: buildCatalogMemoryMd(100)
      }
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

  getFallbackReply(userInput: string): string {
    const songs = rankSongs(userInput).slice(0, 5)
    let reply = '小乐先为你挑这几首，整体会更贴近你现在的状态：\n\n'
    songs.forEach((item: ScoredMusic, index: number) => {
      reply += `${index + 1}. 《${item.song.clusterName}》-${item.song.author}\n${item.userReason}\n`
    })
    return reply
  }

  async callMusicAi() {
    if (this.inputText.trim().length === 0 || this.isLoading) {
      return
    }

    this.isLoading = true
    this.replyText = '小乐正在根据你的输入生成推荐解释...'
    const userInput = this.inputText
    const client = http.createHttp()

    const body: MusicAiRequestBody = {
      model: MUSIC_AI_MODEL,
      messages: this.getMessages(userInput),
      temperature: 0.6,
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
        this.replyText = this.getFallbackReply(userInput)
        return
      }
      const answer = result.choices[0].message.content
      this.replyText = answer
      this.history.push({ role: 'user', content: userInput })
      this.history.push({ role: 'assistant', content: answer })
    } catch (error) {
      this.replyText = this.getFallbackReply(userInput)
    } finally {
      client.destroy()
      this.isLoading = false
    }
  }

  build() {
    if (this.isOpen) {
      Column({ space: 10 }) {
        Row() {
          Row({ space: 8 }) {
            Image($r('app.media.iMusic_icon'))
              .width(28)
              .height(28)
              .borderRadius(8)
            Column({ space: 2 }) {
              Text('小乐')
                .fontColor(Color.White)
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
              Text('你的音乐助手')
                .fontColor('#F6C85F')
                .fontSize(11)
            }
          }
          .layoutWeight(1)
          Image($r('app.media.ic_close'))
            .width(20)
            .height(20)
            .fillColor('#CCCCCC')
            .onClick(() => {
              this.isOpen = false
            })
        }
        .width('100%')

        TextInput({ text: this.inputText, placeholder: '说说现在想听什么' })
          .height(38)
          .fontColor(Color.White)
          .placeholderColor('#8A8A8A')
          .backgroundColor('#303030')
          .borderRadius(10)
          .padding({ left: 10, right: 10 })
          .onChange((value: string) => {
            this.inputText = value
          })

        Button(this.isLoading ? '小乐分析中...' : '生成推荐解释')
          .height(38)
          .fontColor('#131313')
          .backgroundColor('#F6C85F')
          .borderRadius(19)
          .width('100%')
          .enabled(!this.isLoading)
          .onClick(() => {
            this.callMusicAi()
          })

        Column({ space: 6 }) {
          Text('推荐解释')
            .fontColor('#F6C85F')
            .fontSize(12)
            .width('100%')
          Scroll() {
            Text(this.replyText)
              .fontColor('#EFEFEF')
              .fontSize(13)
              .lineHeight(19)
              .width('100%')
          }
          .height(250)
          .scrollBar(BarState.Auto)
        }
        .padding(12)
        .backgroundColor('#242424')
        .borderRadius(10)
        .width('100%')
      }
      .width(340)
      .height(450)
      .padding(12)
      .backgroundColor('#191919')
      .borderRadius(18)
      .shadow({
        radius: 16,
        color: '#99000000',
        offsetX: 0,
        offsetY: 6
      })
      .clip(true)
    } else {
      Row({ space: 4 }) {
        Image($r('app.media.iMusic_icon'))
          .width(24)
          .height(24)
          .borderRadius(7)
        Text('小乐')
          .fontSize(13)
          .fontWeight(FontWeight.Bold)
          .fontColor('#131313')
      }
      .width(58)
      .height(58)
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .backgroundColor('#F6C85F')
      .borderRadius(29)
      .shadow({
        radius: 12,
        color: '#99000000',
        offsetX: 0,
        offsetY: 4
      })
      .onClick(() => {
        this.isOpen = true
      })
    }
  }
}
