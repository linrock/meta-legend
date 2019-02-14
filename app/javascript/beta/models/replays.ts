import Replay from './replay'

export default class Replays {
  public replayList: Array<Replay> = []
  private replaySet: Set<string> = new Set()

  // de-duplicates and returns a list of all replays
  public addReplays(replayData: Array<any>): Array<Replay> {
    replayData.forEach(replayOptions => {
      const replay = new Replay(replayOptions)
      if (!this.replaySet.has(replay.key)) {
        this.replaySet.add(replay.key)
        this.replayList.push(replay)
      }
    })
    return this.replayList
  }
}
