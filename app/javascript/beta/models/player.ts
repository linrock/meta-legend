import Card from '../../models/card'

export interface PlayerOptions {
  class_name: string
  archetype: string
  legend_rank: string
  rank: string
  battletag: string
  is_winner: boolean
  deck_cards: Array<Card>
  predicted_deck_cards?: Array<Card>
  pre_mulligan_cards?: Array<Card>
  post_mulligan_cards?: Array<Card>
}

const initCards = (cardData): Array<Card> => cardData.map(c => new Card(c))

export class Player {
  public className: string
  public archetype: string
  private battletag: string
  public legendRank: number
  public rank: number
  public deckCards: Array<Card>
  public preMulliganCards: Array<Card>
  public postMulliganCards: Array<Card>
  public deckStatus: string
  public isWinner: boolean

  constructor(options: PlayerOptions) {
    this.className = options.class_name
    this.archetype = options.archetype
    this.battletag = options.battletag
    this.legendRank = parseInt(options.legend_rank, 10)
    this.rank = parseInt(options.rank, 10)
    this.isWinner = options.is_winner
    if (this.nCards(options.deck_cards) === 30) {
      this.deckCards = initCards(options.deck_cards)
      this.deckStatus = `full`
    } else if (options.predicted_deck_cards) {
      this.deckCards = initCards(options.predicted_deck_cards)
      this.deckStatus = `predicted`
    } else {
      this.deckCards = initCards(options.deck_cards)
      this.deckStatus = `partial`
    }
    if (options.pre_mulligan_cards) {
      this.preMulliganCards = initCards(options.pre_mulligan_cards)
    }
    if (options.post_mulligan_cards) {
      this.postMulliganCards = initCards(options.post_mulligan_cards)
    }
  }

  get name(): string {
    return this.battletag.split(`#`)[0]
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

  public nCards(deck_cards): number {
    let n = 0
    deck_cards.forEach(card => n += card.n)
    return n
  }
}
