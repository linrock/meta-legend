<template lang="pug">
  .replay-info
    .about-replay
      .players
        a(
          :href="`/players/${replay.p1.name}`"
          target="_blank"
          @click="playerNameClicked(replay.p1.name)"
        ) {{ replay.p1.name }}
        .vs vs.
        a(
          :href="`/players/${replay.p2.name}`"
          target="_blank"
          @click="playerNameClicked(replay.p2.name)"
        ) {{ replay.p2.name }}
      .small
        .time-ago {{ timeAgo }}
      a.watch-link(
        :href="replay.hsreplayLink"
        target="_blank"
        @click="replayClicked"
      ) Watch on hsreplay.net
    deck-cards(:player="replay.p1")
    deck-cards(:player="replay.p2")

</template>

<script lang="ts">
  import Replay from '../models/replay'
  import DeckCards from './deck_cards'
  import { trackEvent, timeAgo } from '../../utils'

  export default {
    props: {
      replay: {
        type: Replay,
        required: true
      }
    },

    methods: {
      replayClicked() {
        trackEvent('click', 'watch replay', this.replay.hsreplayId)
      },
      playerNameClicked(name) {
        trackEvent('click player', 'name', name)
      },
    },

    computed: {
      timeAgo() {
        return timeAgo(this.replay.playedAt)
      },
    },

    components: {
      DeckCards
    }
  }
</script>

<style lang="stylus" scoped>
  .replay-info
    font-size 14px
    width 230px

  .separator
    margin 0 5px

  .about-replay
    margin-bottom 15px

    .players
      display flex
      font-weight bold
      margin-bottom 10px

      a
        color #45abfe

      .vs
        margin 0 5px

    .small
      display flex
      opacity 0.7
      font-size 12px
      margin-bottom 12px

    .watch-link
      color white
      background #45abfe
      border-radius 2px
      display block
      padding 10px 0
      text-align center
      text-decoration none
      font-size 16px
      transition opacity 0.15s ease

      &:visited
        opacity 0.3

      &:hover
        opacity 0.65

</style>
