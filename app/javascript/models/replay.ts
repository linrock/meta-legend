interface PlayerOptions {
  archetype: string
  legend_rank: string
  tag: string
}

interface ReplayOptions {
  hsreplay_id: string
  winner: string
  num_turns: number
  p1: PlayerOptions
  p2: PlayerOptions
  deck_card_names: Array<string>
  found_at: string
}

export default class Replay {
  public hsreplayId: string
  public numTurns: number 
  public p1: PlayerOptions
  public p2: PlayerOptions
  public winner: string
  public deckCardNames: Array<string>
  public foundAt: string

  constructor(options: ReplayOptions) {
    this.hsreplayId = options.hsreplay_id
    this.numTurns = options.num_turns
    this.p1 = options.p1
    this.p2 = options.p2
    this.winner = options.winner
    this.foundAt = options.found_at
    this.deckCardNames = options.deck_card_names
  }

  get key(): string {
    return this.hsreplayId
  }

  get hsreplayLink(): string {
    return `https://hsreplay.net/replay/${this.hsreplayId}`
  }

  get p1Name(): string {
    return this.p1.tag.split('#')[0]
  }

  get p2Name(): string {
    return this.p2.tag.split('#')[0]
  }
}
