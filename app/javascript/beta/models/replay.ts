import Card from '../../models/card'
import { PlayerOptions, Player } from '../../models/player'

interface OpposingDeckOptions {
  cards: Array<Card>
  predicted_cards: Array<Card>
}

interface ReplayOptions {
  hsreplay_id: string
  winner: string
  num_turns: number
  p1: PlayerOptions
  p2: PlayerOptions
  deck_card_names: Array<Card>
  opposing_deck?: OpposingDeckOptions
  metadata?: any
  found_at: string
}

export default class Replay {
  public hsreplayId: string
  public numTurns: number 
  public p1: Player
  public p2: Player
  public winner: string
  public deckCards: Array<Card>
  public opposingDeckCards: Array<Card>
  public opposingDeckPredictedCards: Array<Card>
  public metadata: any
  public foundAt: string

  constructor(options: ReplayOptions) {
    this.hsreplayId = options.hsreplay_id
    this.numTurns = options.num_turns
    this.p1 = new Player(options.p1)
    this.p2 = new Player(options.p2)
    this.winner = options.winner
    this.foundAt = options.found_at
    this.deckCards = options.deck_card_names.map(c => new Card(c))
    const opposingDeck = options.opposing_deck
    if (options.opposing_deck) {
      this.opposingDeckCards = opposingDeck.cards.map(c => new Card(c))
      this.opposingDeckPredictedCards = opposingDeck.predicted_cards.map(c => new Card(c))
    }
    if (options.metadata) {
      this.metadata = options.metadata
    }
  }

  get key(): string {
    return this.hsreplayId
  }

  get hsreplayLink(): string {
    return `https://hsreplay.net/replay/${this.hsreplayId}`
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
