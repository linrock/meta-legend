export interface PlayerOptions {
  archetype: string
  legend_rank: string
  tag: string
}

export class Player {
  public deckType: string
  private tag: string
  public legendRank: number

  constructor(options: PlayerOptions) {
    this.deckType = options.archetype
    this.tag = options.tag
    this.legendRank = parseInt(options.legend_rank, 10)
  }

  get className(): string {
    return this.deckType.split(/\s+/).reverse()[0].toLowerCase()
  }

  get name(): string {
    return this.tag.split(`#`)[0]
  }

  get isValid(): boolean {
    return !!(this.legendRank && this.deckType)
  }
}
