interface LikedReplay {
  numLikes: number,
  liked: boolean,
}

export default class LikedReplays {
  likeMap: { [replayId: string]: LikedReplay } = {}

  getReplayLikes(replayId): object {
    return this.likeMap[replayId] || {}
  }
}
