interface CardOptions {
  id: string
  cost: number
  name: string
  n: number
  rarity: string
}

export default class Card {
  id: string
  cost: number
  name: string
  n: number
  rarity: string

  constructor(cardOptions: CardOptions) {
    this.id = cardOptions.id
    this.cost = cardOptions.cost
    this.name = cardOptions.name
    this.n = cardOptions.n
    this.rarity = cardOptions.rarity
  }

  get path(): string {
    return this.name.replace(/('|!|,|\.|:)/g, '').replace(/\s+/g, '-').toLowerCase()
      .replace(/[^0-9a-z\-]/g, '')
  }

  get href(): string {
    return `/cards/${this.path}`
  }
}
