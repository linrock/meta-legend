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
  deck_card_names: Array<Card>
  found_at: string
}

interface Card {
  cost: number
  name: string
  n: number
  rarity: string
}

export default class Replay {
  public hsreplayId: string
  public numTurns: number 
  public p1: PlayerOptions
  public p2: PlayerOptions
  public winner: string
  public deckCards: Array<Card>
  public foundAt: string

  constructor(options: ReplayOptions) {
    this.hsreplayId = options.hsreplay_id
    this.numTurns = options.num_turns
    this.p1 = options.p1
    this.p2 = options.p2
    this.winner = options.winner
    this.foundAt = options.found_at
    this.deckCards = options.deck_card_names
  }

  get key(): string {
    return this.hsreplayId
  }

  get hsreplayLink(): string {
    return `https://hsreplay.net/replay/${this.hsreplayId}`
  }

  get p1Name(): string {
    return this.p1.tag.split(`#`)[0]
  }

  get p2Name(): string {
    return this.p2.tag.split(`#`)[0]
  }

  get deckDustCost(): number {
    let cost = 0
    this.deckCards.forEach(c => {
      if (c.rarity === `common`) {
        cost += 40 * c.n
      } else if (c.rarity === `rare`) {
        cost += 100 * c.n
      } else if (c.rarity === `epic`) {
        cost += 400 * c.n
      } else if (c.rarity === `legendary`) {
        cost += 1600 * c.n
      }
    })
    return cost
  }
}
