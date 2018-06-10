interface About {
  since: string,
  count: string,
}

export default class AboutWinrates {

  constructor(private about: About) {
    this.about = about
  }

  get sinceDays(): number {
    const since = new Date(this.about.since).getTime()
    const secondsSince = ((new Date()).getTime() - since) / 1000
    return ~~(secondsSince / 86400)
  }

  get sinceDaysText(): string {
    if (this.sinceDays === 0) {
      return `today`
    } else if (this.sinceDays === 1) {
      return `past day`
    } else {
      return `past ${this.sinceDays} days`
    }
  }

  get numReplays(): string {
    return this.about.count
  }
}
