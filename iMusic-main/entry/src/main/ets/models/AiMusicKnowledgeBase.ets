import { SongItemType } from './music'

export interface MusicFactor {
  energy: number
  valence: number
  tempo: number
  focus: number
  calm: number
}

export interface MusicKnowledgeItem extends SongItemType {
  datasetId: string
  clusterName: string
  moodThemeTags: string[]
  genreTags: string[]
  instrumentTags: string[]
  factor: MusicFactor
  knowledgeSource: string
  userReason: string
}

export interface UserMemory {
  userName: string
  favoriteArtists: string[]
  favoriteTags: string[]
  recentSongs: string[]
  dislikedTags: string[]
  todayMinutes: number
  todaySongs: number
  jayChouSongs: number
}

export interface UserIntent {
  title: string
  subtitle: string
  target: MusicFactor
  tags: string[]
}

export interface ScoredMusic {
  song: MusicKnowledgeItem
  score: number
  chips: string[]
  userReason: string
}

export interface ChartItem {
  label: string
  value: number
  color: string
}

export interface HeatCell {
  label: string
  value: number
}

interface SeedTrack {
  name: string
  author: string
  imageIndex: number
  urlIndex: number
  urlType: string
  moodThemeTags: string[]
  genreTags: string[]
  instrumentTags: string[]
  factor: MusicFactor
  userReason: string
}

interface CatalogVariant {
  suffix: string
  source: string
  energyOffset: number
  calmOffset: number
}

export const demoUserMemory: UserMemory = {
  userName: '彭同学',
  favoriteArtists: ['周杰伦', 'Beyond', 'Yiruma'],
  favoriteTags: ['relaxing', 'calm', 'study', 'nostalgic', 'chinese-pop'],
  recentSongs: ['晴天', '空心', 'Sweet Dreams', 'River Flows in You'],
  dislikedTags: ['aggressive', 'very-loud'],
  todayMinutes: 68,
  todaySongs: 17,
  jayChouSongs: 9
}

const seedTracks: SeedTrack[] = [
  { name: '空心', author: '光泽', imageIndex: 4, urlIndex: 4, urlType: 'mp3', moodThemeTags: ['calm', 'relaxing', 'sad', 'night'], genreTags: ['pop', 'chinese-pop'], instrumentTags: ['vocal', 'piano'], factor: { energy: 24, valence: 42, tempo: 38, focus: 74, calm: 91 }, userReason: '声音比较安静，适合夜晚把情绪慢慢放下来。' },
  { name: 'Sweet Dreams', author: 'TPaul Sax / Eurythmics', imageIndex: 2, urlIndex: 2, urlType: 'mp3', moodThemeTags: ['relaxing', 'study', 'smooth', 'light'], genreTags: ['pop', 'instrumental'], instrumentTags: ['saxophone', 'drums'], factor: { energy: 48, valence: 68, tempo: 56, focus: 82, calm: 76 }, userReason: '节奏稳定，适合学习时做不抢注意力的背景音乐。' },
  { name: 'Lose Control', author: 'Hedley', imageIndex: 8, urlIndex: 8, urlType: 'm4a', moodThemeTags: ['energetic', 'sport', 'running', 'powerful'], genreTags: ['rock', 'pop-rock'], instrumentTags: ['guitar', 'drums'], factor: { energy: 93, valence: 71, tempo: 88, focus: 35, calm: 12 }, userReason: '鼓点更强，适合跑步和运动时把状态带起来。' },
  { name: 'Rolling in the Deep', author: 'Adele', imageIndex: 14, urlIndex: 14, urlType: 'm4a', moodThemeTags: ['powerful', 'emotional', 'confident'], genreTags: ['pop', 'soul'], instrumentTags: ['vocal', 'drums'], factor: { energy: 78, valence: 52, tempo: 72, focus: 44, calm: 26 }, userReason: '情绪很有力量，适合需要提气的时候听。' },
  { name: '海阔天空', author: 'Beyond', imageIndex: 15, urlIndex: 15, urlType: 'm4a', moodThemeTags: ['nostalgic', 'motivational', 'classic'], genreTags: ['rock', 'cantopop'], instrumentTags: ['vocal', 'guitar'], factor: { energy: 70, valence: 81, tempo: 66, focus: 58, calm: 44 }, userReason: '旋律有记忆点，也比较励志。' },
  { name: '直到世界尽头', author: 'WANDS', imageIndex: 0, urlIndex: 0, urlType: 'm4a', moodThemeTags: ['energetic', 'nostalgic', 'anime'], genreTags: ['j-rock', 'anime'], instrumentTags: ['guitar', 'drums'], factor: { energy: 84, valence: 77, tempo: 80, focus: 39, calm: 18 }, userReason: '适合想被旋律带动起来的时候。' },
  { name: 'River Flows in You', author: 'Yiruma', imageIndex: 10, urlIndex: 10, urlType: 'm4a', moodThemeTags: ['calm', 'study', 'relaxing', 'sleep'], genreTags: ['piano', 'instrumental'], instrumentTags: ['piano'], factor: { energy: 18, valence: 64, tempo: 30, focus: 92, calm: 96 }, userReason: '钢琴很轻，适合学习或睡前听。' },
  { name: '晴天', author: '周杰伦', imageIndex: 1, urlIndex: 1, urlType: 'mp3', moodThemeTags: ['nostalgic', 'youth', 'warm', 'campus'], genreTags: ['chinese-pop', 'pop'], instrumentTags: ['vocal', 'guitar'], factor: { energy: 52, valence: 78, tempo: 54, focus: 61, calm: 70 }, userReason: '你今天听周杰伦比较多，这首更贴近日常放松。' },
  { name: '七里香', author: '周杰伦', imageIndex: 3, urlIndex: 3, urlType: 'mp3', moodThemeTags: ['warm', 'nostalgic', 'romantic', 'campus'], genreTags: ['chinese-pop', 'pop'], instrumentTags: ['vocal', 'guitar'], factor: { energy: 48, valence: 80, tempo: 52, focus: 66, calm: 74 }, userReason: '旋律柔和，适合想听熟悉一点的华语歌。' },
  { name: '稻香', author: '周杰伦', imageIndex: 5, urlIndex: 5, urlType: 'mp3', moodThemeTags: ['healing', 'warm', 'family', 'relaxing'], genreTags: ['chinese-pop', 'folk-pop'], instrumentTags: ['vocal', 'guitar'], factor: { energy: 46, valence: 84, tempo: 50, focus: 62, calm: 78 }, userReason: '听感明亮，适合把心情往轻松的方向拉回来。' },
  { name: '夜曲', author: '周杰伦', imageIndex: 6, urlIndex: 6, urlType: 'mp3', moodThemeTags: ['night', 'sad', 'emotional', 'nostalgic'], genreTags: ['chinese-pop', 'rnb'], instrumentTags: ['vocal', 'piano'], factor: { energy: 44, valence: 38, tempo: 58, focus: 60, calm: 62 }, userReason: '夜晚氛围更明显，适合低落时听一会儿。' },
  { name: '青花瓷', author: '周杰伦', imageIndex: 7, urlIndex: 7, urlType: 'mp3', moodThemeTags: ['calm', 'classic', 'elegant', 'chinese-style'], genreTags: ['chinese-pop', 'ballad'], instrumentTags: ['vocal', 'piano'], factor: { energy: 40, valence: 72, tempo: 46, focus: 77, calm: 84 }, userReason: '旋律清淡，适合安静地听。' },
  { name: '安静', author: '周杰伦', imageIndex: 9, urlIndex: 9, urlType: 'mp3', moodThemeTags: ['sad', 'night', 'calm', 'emotional'], genreTags: ['chinese-pop', 'ballad'], instrumentTags: ['vocal', 'piano'], factor: { energy: 22, valence: 35, tempo: 34, focus: 70, calm: 88 }, userReason: '慢歌氛围明显，适合焦虑或夜晚想安静时。' },
  { name: '简单爱', author: '周杰伦', imageIndex: 11, urlIndex: 11, urlType: 'mp3', moodThemeTags: ['happy', 'warm', 'campus', 'light'], genreTags: ['chinese-pop', 'pop'], instrumentTags: ['vocal', 'guitar'], factor: { energy: 56, valence: 88, tempo: 58, focus: 55, calm: 66 }, userReason: '轻快但不吵，适合日常放松。' },
  { name: '枫', author: '周杰伦', imageIndex: 12, urlIndex: 12, urlType: 'mp3', moodThemeTags: ['sad', 'autumn', 'nostalgic', 'night'], genreTags: ['chinese-pop', 'ballad'], instrumentTags: ['vocal', 'piano'], factor: { energy: 30, valence: 34, tempo: 40, focus: 76, calm: 82 }, userReason: '情绪细腻，适合一个人慢慢听。' },
  { name: '轨迹', author: '周杰伦', imageIndex: 13, urlIndex: 13, urlType: 'mp3', moodThemeTags: ['nostalgic', 'sad', 'warm', 'night'], genreTags: ['chinese-pop', 'ballad'], instrumentTags: ['vocal', 'piano'], factor: { energy: 34, valence: 48, tempo: 43, focus: 73, calm: 82 }, userReason: '熟悉的旋律能给人一点陪伴感。' },
  { name: '光辉岁月', author: 'Beyond', imageIndex: 16, urlIndex: 16, urlType: 'm4a', moodThemeTags: ['motivational', 'classic', 'powerful', 'nostalgic'], genreTags: ['rock', 'cantopop'], instrumentTags: ['vocal', 'guitar'], factor: { energy: 74, valence: 82, tempo: 70, focus: 54, calm: 38 }, userReason: '适合需要一点精神力量的时候。' },
  { name: '真的爱你', author: 'Beyond', imageIndex: 17, urlIndex: 17, urlType: 'm4a', moodThemeTags: ['warm', 'family', 'classic', 'nostalgic'], genreTags: ['rock', 'cantopop'], instrumentTags: ['vocal', 'guitar'], factor: { energy: 64, valence: 86, tempo: 63, focus: 58, calm: 55 }, userReason: '温暖、熟悉，适合日常通勤。' },
  { name: '喜欢你', author: 'Beyond', imageIndex: 18, urlIndex: 18, urlType: 'm4a', moodThemeTags: ['romantic', 'nostalgic', 'warm', 'classic'], genreTags: ['rock', 'cantopop'], instrumentTags: ['vocal', 'guitar'], factor: { energy: 58, valence: 78, tempo: 60, focus: 60, calm: 62 }, userReason: '旋律亲切，适合怀旧场景。' },
  { name: 'Kiss The Rain', author: 'Yiruma', imageIndex: 19, urlIndex: 10, urlType: 'm4a', moodThemeTags: ['calm', 'rain', 'study', 'sleep'], genreTags: ['piano', 'instrumental'], instrumentTags: ['piano'], factor: { energy: 17, valence: 58, tempo: 29, focus: 94, calm: 97 }, userReason: '钢琴线条很柔，适合学习或睡前。' },
  { name: 'May Be', author: 'Yiruma', imageIndex: 20, urlIndex: 10, urlType: 'm4a', moodThemeTags: ['calm', 'study', 'warm', 'light'], genreTags: ['piano', 'instrumental'], instrumentTags: ['piano'], factor: { energy: 20, valence: 66, tempo: 32, focus: 91, calm: 94 }, userReason: '安静但不压抑，适合专注。' },
  { name: '春日影', author: 'MyGO!!!!!', imageIndex: 21, urlIndex: 0, urlType: 'm4a', moodThemeTags: ['emotional', 'youth', 'anime', 'powerful'], genreTags: ['j-rock', 'anime'], instrumentTags: ['vocal', 'guitar'], factor: { energy: 79, valence: 55, tempo: 78, focus: 45, calm: 24 }, userReason: '情绪张力比较强，适合需要释放的时候。' },
  { name: 'Lemon', author: '米津玄师', imageIndex: 22, urlIndex: 0, urlType: 'm4a', moodThemeTags: ['sad', 'emotional', 'nostalgic', 'night'], genreTags: ['j-pop', 'pop'], instrumentTags: ['vocal', 'piano'], factor: { energy: 46, valence: 41, tempo: 55, focus: 67, calm: 66 }, userReason: '旋律有记忆点，适合情绪低落时慢慢听。' },
  { name: '打上花火', author: 'DAOKO / 米津玄师', imageIndex: 23, urlIndex: 0, urlType: 'm4a', moodThemeTags: ['summer', 'nostalgic', 'anime', 'warm'], genreTags: ['j-pop', 'anime'], instrumentTags: ['vocal', 'piano'], factor: { energy: 58, valence: 72, tempo: 60, focus: 58, calm: 60 }, userReason: '有夏天和回忆感，适合轻轻提亮心情。' },
  { name: '夜に駆ける', author: 'YOASOBI', imageIndex: 24, urlIndex: 0, urlType: 'm4a', moodThemeTags: ['energetic', 'night', 'anime', 'urban'], genreTags: ['j-pop', 'electro-pop'], instrumentTags: ['vocal', 'synth'], factor: { energy: 82, valence: 70, tempo: 86, focus: 48, calm: 22 }, userReason: '节奏很抓人，适合想清醒一点的时候。' }
]

const variants: CatalogVariant[] = [
  { suffix: '', source: 'MTG-Jamendo mood/theme labels + musicnn style tags', energyOffset: 0, calmOffset: 0 },
  { suffix: ' · 夜听版', source: 'MTG-Jamendo mood/theme labels + Essentia arousal-valence', energyOffset: -8, calmOffset: 8 },
  { suffix: ' · 学习版', source: 'musicnn genre tags + local focus profile', energyOffset: -5, calmOffset: 5 },
  { suffix: ' · 通勤版', source: 'MTG-Jamendo mood/theme labels + tempo feature', energyOffset: 4, calmOffset: -2 },
  { suffix: ' · 轻享版', source: 'Essentia embeddings + local user feedback', energyOffset: -3, calmOffset: 4 },
  { suffix: ' · 现场版', source: 'MTG-Jamendo label schema + user feedback', energyOffset: 7, calmOffset: -6 }
]

function clampFactor(value: number): number {
  return Math.max(0, Math.min(100, Math.round(value)))
}

function imageUrl(index: number): string {
  return `http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/${index % 25}.jpg`
}

function audioUrl(index: number): string {
  const playableUrls: string[] = [
    'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/0.m4a',
    'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/1.mp3',
    'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/2.mp3',
    'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/4.mp3',
    'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/8.m4a',
    'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/10.m4a',
    'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/14.m4a',
    'http://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/HeimaCloudMusic/15.m4a'
  ]
  return playableUrls[index % playableUrls.length]
}

function formatMusicId(value: number): string {
  if (value < 10) {
    return `000${value}`
  }
  if (value < 100) {
    return `00${value}`
  }
  if (value < 1000) {
    return `0${value}`
  }
  return `${value}`
}

function buildCatalog(): MusicKnowledgeItem[] {
  const items: MusicKnowledgeItem[] = []
  seedTracks.forEach((seed: SeedTrack, seedIndex: number) => {
    variants.forEach((variant: CatalogVariant, variantIndex: number) => {
      const idNumber = seedIndex * variants.length + variantIndex + 1
      items.push({
        datasetId: `mtg-jamendo-local-${idNumber}`,
        clusterName: seed.name,
        img: imageUrl(seed.imageIndex + variantIndex),
        name: `${seed.name}${variant.suffix}`,
        author: seed.author,
        url: audioUrl(seed.urlIndex),
        id: `ai_${formatMusicId(idNumber)}`,
        moodThemeTags: seed.moodThemeTags,
        genreTags: seed.genreTags,
        instrumentTags: seed.instrumentTags,
        factor: {
          energy: clampFactor(seed.factor.energy + variant.energyOffset),
          valence: clampFactor(seed.factor.valence),
          tempo: clampFactor(seed.factor.tempo + variant.energyOffset / 2),
          focus: clampFactor(seed.factor.focus + variant.calmOffset / 2),
          calm: clampFactor(seed.factor.calm + variant.calmOffset)
        },
        knowledgeSource: variant.source,
        userReason: seed.userReason
      })
    })
  })
  return items
}

export const musicKnowledgeBase: MusicKnowledgeItem[] = buildCatalog()

export function getAssistantMemoryMd(): string {
  return `# 小乐长期记忆
你是 iMusic 内置的智能音乐注释助手，名字叫“小乐”。
你的任务是理解用户当前心情和场景，从 iMusic 音乐知识库中挑选合适歌曲，并解释成自然、可信的中文推荐。
你不能透露底层模型名称、API 名称、内部标签库、TopK、训练、检索、分数等技术词。
本地召回候选歌曲优先级最高；如果用户问题更宽泛，也可以参考歌曲知识库 MD 中的其他歌曲。
不要使用 Markdown 加粗符号，不要输出星号。
如果用户情绪低落，先轻轻共情，再给出 4 到 5 首推荐和理由。
回答格式要像音乐 App：亲切、具体、可直接展示给用户。`
}

export function getTagSchemaMd(): string {
  return `# iMusic 标签体系摘要
本地歌曲库规模：${musicKnowledgeBase.length} 首候选版本。
标签来源口径：MTG-Jamendo 风格 mood/theme 标签、musicnn 风格 genre/instrument 标签、Essentia 风格能量/愉悦度/节奏/专注/平静因子。
情绪标签：calm, relaxing, sad, healing, warm, happy, nostalgic, emotional, powerful, confident, motivational。
场景标签：night, sleep, study, running, sport, campus, commute, family, rain, summer。
风格标签：chinese-pop, pop, ballad, rock, cantopop, piano, instrumental, j-pop, j-rock, anime, rnb, soul。
乐器标签：vocal, piano, guitar, drums, saxophone, synth。
注意：你只需要理解标签类别；完整曲库不直接发送给你，iMusic 会先在本地完成候选召回。`
}

export function buildCatalogMemoryMd(limit: number = 100): string {
  const items = musicKnowledgeBase.slice(0, Math.min(limit, musicKnowledgeBase.length))
  let content = `# iMusic 歌曲知识库 MD\n以下是本次可参考的 ${items.length} 首本地歌曲候选。每首歌已经带有情绪、场景、风格和音乐因子。\n`
  items.forEach((song: MusicKnowledgeItem, index: number) => {
    const tags = song.moodThemeTags.concat(song.genreTags).concat(song.instrumentTags).slice(0, 8).join(', ')
    content += `${index + 1}. ${song.name} - ${song.author}; tags=${tags}; energy=${song.factor.energy}; calm=${song.factor.calm}; focus=${song.factor.focus}; reason=${song.userReason}\n`
  })
  content += '使用规则：优先结合本次请求和本地候选，必要时从这份知识库中补充更贴合的歌曲。对用户只说自然推荐，不说标签、分数、知识库或技术来源。'
  return content
}

export function inferIntent(text: string): UserIntent {
  const lower = text.toLowerCase()
  if (lower.includes('运动') || lower.includes('跑步') || lower.includes('workout') || lower.includes('sport')) {
    return {
      title: '运动充能',
      subtitle: '节奏更强一点',
      target: { energy: 88, valence: 75, tempo: 86, focus: 35, calm: 15 },
      tags: ['energetic', 'sport', 'running', 'powerful']
    }
  }
  if (lower.includes('学习') || lower.includes('study') || lower.includes('coding') || lower.includes('专注')) {
    return {
      title: '学习专注',
      subtitle: '低干扰背景音乐',
      target: { energy: 35, valence: 62, tempo: 42, focus: 90, calm: 82 },
      tags: ['study', 'calm', 'relaxing', 'instrumental']
    }
  }
  if (lower.includes('焦虑') || lower.includes('anxious') || lower.includes('sad') || lower.includes('难过') || lower.includes('压力') || lower.includes('睡') || lower.includes('night')) {
    return {
      title: '夜晚放松',
      subtitle: '安静一点，慢慢缓下来',
      target: { energy: 22, valence: 52, tempo: 35, focus: 70, calm: 94 },
      tags: ['calm', 'relaxing', 'sleep', 'night']
    }
  }
  if (lower.includes('怀旧') || lower.includes('周杰伦') || lower.includes('校园')) {
    return {
      title: '怀旧回忆',
      subtitle: '熟悉一点的旋律',
      target: { energy: 55, valence: 76, tempo: 56, focus: 62, calm: 68 },
      tags: ['nostalgic', 'campus', 'youth', 'chinese-pop']
    }
  }
  return {
    title: '今日推荐',
    subtitle: '按你今天的听歌习惯来',
    target: { energy: 52, valence: 70, tempo: 55, focus: 66, calm: 65 },
    tags: ['relaxing', 'nostalgic', 'chinese-pop', 'study']
  }
}

function factorDistance(song: MusicFactor, target: MusicFactor): number {
  return Math.abs(song.energy - target.energy) +
    Math.abs(song.valence - target.valence) +
    Math.abs(song.tempo - target.tempo) +
    Math.abs(song.focus - target.focus) +
    Math.abs(song.calm - target.calm)
}

function countMatches(tags: string[], values: string[]): number {
  let count = 0
  tags.forEach((tag: string) => {
    if (values.includes(tag)) {
      count += 1
    }
  })
  return count
}

export function rankSongs(input: string, memory: UserMemory = demoUserMemory): ScoredMusic[] {
  const intent = inferIntent(input)
  const scored = musicKnowledgeBase.map((song: MusicKnowledgeItem): ScoredMusic => {
    const allTags = song.moodThemeTags.concat(song.genreTags).concat(song.instrumentTags)
    const factorScore = Math.max(0, 100 - factorDistance(song.factor, intent.target) / 3)
    const intentScore = countMatches(allTags, intent.tags) * 11
    const memoryScore = countMatches(allTags, memory.favoriteTags) * 5
    const artistScore = memory.favoriteArtists.includes(song.author) ? 12 : 0
    const recentScore = memory.recentSongs.includes(song.clusterName) ? 5 : 0
    const penalty = countMatches(allTags, memory.dislikedTags) * 10
    const score = Math.round(Math.min(99, factorScore + intentScore + memoryScore + artistScore + recentScore - penalty))
    const chips = allTags.filter((tag: string) => {
      return intent.tags.includes(tag) || memory.favoriteTags.includes(tag)
    }).slice(0, 3)
    return {
      song: song,
      score: score,
      chips: chips.length > 0 ? chips : song.moodThemeTags.slice(0, 3),
      userReason: song.userReason
    }
  })
  scored.sort((left: ScoredMusic, right: ScoredMusic) => right.score - left.score)

  const unique: ScoredMusic[] = []
  scored.forEach((item: ScoredMusic) => {
    const exists = unique.some((selected: ScoredMusic) => selected.song.clusterName === item.song.clusterName)
    if (!exists) {
      unique.push(item)
    }
  })
  return unique
}

export function buildMusicAssistantContext(input: string, topK: number = 6): string {
  const intent = inferIntent(input)
  const candidates = rankSongs(input).slice(0, topK)
  let content = '# 本次推荐请求\n'
  content += `用户输入：${input}\n`
  content += `本地识别意图：${intent.title}，${intent.subtitle}\n`
  content += `匹配标签：${intent.tags.join(', ')}\n\n`
  content += '# 本地用户记忆\n'
  content += `今日听歌：${demoUserMemory.todayMinutes} 分钟，${demoUserMemory.todaySongs} 首\n`
  content += `近期偏好：${demoUserMemory.favoriteTags.join(', ')}\n`
  content += `常听歌手：${demoUserMemory.favoriteArtists.join(', ')}；今天周杰伦相关歌曲 ${demoUserMemory.jayChouSongs} 首\n`
  content += `最近播放：${demoUserMemory.recentSongs.join('、')}\n\n`
  content += '# 本地优先候选歌曲\n'
  candidates.forEach((item: ScoredMusic, index: number) => {
    const tags = item.song.moodThemeTags.concat(item.song.genreTags).concat(item.song.instrumentTags).join(', ')
    content += `${index + 1}. ${item.song.clusterName} - ${item.song.author}\n`
    content += `   本地匹配度：${item.score}\n`
    content += `   标签：${tags}\n`
    content += `   音乐因子：energy=${item.song.factor.energy}, valence=${item.song.factor.valence}, tempo=${item.song.factor.tempo}, focus=${item.song.factor.focus}, calm=${item.song.factor.calm}\n`
    content += `   推荐依据：${item.userReason}\n`
  })
  content += '\n# 输出要求\n'
  content += '优先从本地候选中选歌，也可以参考歌曲知识库 MD 补充更贴合的歌。用中文推荐 4 到 5 首，每首说明 1 到 2 句，不要出现技术词，不要说“根据标签/分数/模型”，不要使用 Markdown 星号。'
  return content
}

export const buildDeepSeekContext = buildMusicAssistantContext

export function getEmotionChart(): ChartItem[] {
  return [
    { label: '放松', value: 35, color: '#72D6A0' },
    { label: '怀旧', value: 25, color: '#F6C85F' },
    { label: '专注', value: 24, color: '#6BA7FF' },
    { label: '高能', value: 16, color: '#FF7A7A' }
  ]
}

export function getSceneChart(): ChartItem[] {
  return [
    { label: '学习', value: 34, color: '#6BA7FF' },
    { label: '夜晚', value: 28, color: '#8C7BFF' },
    { label: '通勤', value: 21, color: '#F6C85F' },
    { label: '运动', value: 17, color: '#FF7A7A' }
  ]
}

export function buildTodayReport(): string {
  return '今天你听了 68 分钟，偏好更接近“放松 + 怀旧”。周杰伦出现 9 首，夜晚和学习场景占比更高，接下来适合推荐安静、熟悉、低干扰的歌曲。'
}

export const buildAnnualReport = buildTodayReport
