import Replay from './replay'

export default class Replays {
  replayList: Array<Replay>
  replaySet: Set<string>

  constructor() {
    this.replayList = []
    this.replaySet = new Set()
  }

  // returns a list of all replays
  addReplays(replays): Array<Replay> {
    replays.forEach(replayOptions => {
      const replay = new Replay(replayOptions)
      if (!this.replaySet.has(replay.key)) {
        this.replaySet.add(replay.key)
        this.replayList.push(replay)
      }
    })
    return this.replayList
  }
}
