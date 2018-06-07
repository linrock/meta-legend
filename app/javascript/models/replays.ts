interface Replay {
  hsreplay_id: string,
  winner: string,
  num_turns: number,
  p1: object,
  p2: object,
}

export default class Replays {
  replayList: Array<Replay>
  replaySet: Set<string>

  constructor() {
    this.replayList = []
    this.replaySet = new Set()
  }

  // returns a list of all replays
  addReplays(replays): Array<Replay> {
    replays.forEach(replay => {
      if (!this.replaySet.has(replay.hsreplay_id)) {
        this.replaySet.add(replay.hsreplay_id)
        this.replayList.push(replay)
      }
    })
    return this.replayList
  }
}
