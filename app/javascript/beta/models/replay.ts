import Card from '../../models/card'
import { PlayerOptions, Player } from './player'
import { timeAgo } from '../../utils'

interface ReplayOptions {
  hsreplay_id: string
  num_turns: number
  duration_seconds: number
  p1: PlayerOptions
  p2: PlayerOptions
  metadata?: any
  played_at: string
  game_type: string
}

export default class Replay {
  public hsreplayId: string
  public numTurns: number 
  public durationSeconds: number
  public p1: Player
  public p2: Player
  public metadata: any
  public playedAt: string
  public gameType: string

  constructor(options: ReplayOptions) {
    this.hsreplayId = options.hsreplay_id
    this.numTurns = options.num_turns
    this.durationSeconds = options.duration_seconds
    this.p1 = new Player(options.p1)
    this.p2 = new Player(options.p2)
    this.playedAt = options.played_at
    this.gameType = options.game_type
    if (options.metadata) {
      this.metadata = options.metadata
    }
  }

  get key(): string {
    return this.hsreplayId
  }

  get playedAtTimeAgo(): string {
    return timeAgo(this.playedAt)
  }

  get hsreplayLink(): string {
    return `https://hsreplay.net/replay/${this.hsreplayId}`
  }
}
