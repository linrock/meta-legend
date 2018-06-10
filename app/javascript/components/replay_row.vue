<template lang="pug">
  a.replay-link(
    href="javascript:" target="_blank"
    :class="[{ selected: isSelectedReplay }]"
    @click="selectReplay(replay)"
  )
    .player.player1
      .player-name
        .win-indicator
          svg.crown(v-if="replay.winner === `p1`")
            use(xlink:href="#crown")
        div {{ replay.p1Name }}
      .archetype {{ replay.p1.archetype }}
    player-rank(:player="replay.p1")
    .vs vs
    player-rank(:player="replay.p2")
    .player.player2
      .player-name
        div {{ replay.p2Name }}
        .win-indicator
          svg.crown(v-if="replay.winner === `p2`")
            use(xlink:href="#crown")
      .archetype {{ replay.p2.archetype }}

</template>

<script>
  import PlayerRank from './player_rank'
  import { trackEvent } from '../utils'

  export default {
    props: {
      replay: {
        required: true,
        type: Object,
      },
    },

    methods: {
      selectReplay() {
        const replay = this.isSelectedReplay ? null : this.replay
        this.$store.dispatch(`selectReplay`, replay)
        trackEvent('click row', 'replay', replay.hsreplayId)
      },
    },

    computed: {
      isSelectedReplay() {
        return this.replay === this.$store.getters.currentReplay
      },
    },

    components: {
      PlayerRank,
    }
  }
</script>

<style lang="stylus" scoped>
  a.replay-link
    align-items center
    color #111
    display flex
    text-decoration none
    justify-content center
    font-size 17px
    padding 10px 0
    margin 10px 0
    width 510px
    border-radius 2px

    &:hover
      opacity 1

      .player
        color #45ABFE

    &:visited
      color #999
      opacity 0.7

    &.selected
      background rgba(0, 0, 0, 0.04)
      border-radius 2px

  .player
    display flex
    flex-direction column
    width 190px

    &.player1
      text-align right
      justify-content flex-end

      .player-name
        margin-left auto

    &.player2
      text-align left
      justify-content flex-start

      .player-name
        margin-right auto

    .player-name
      display flex
      margin-bottom 7px
      flex-direction row

    .archetype
      font-size 15px
      font-weight bold

  .vs
    font-weight 300
    text-align center
    width 18px
    opacity 0.5

  .win-indicator
    width 30px
    display flex
    text-align center
    align-items center
    justify-content center

  .crown
    width 25px
    height 16px
    fill #ffcd00
    stroke #737373
    stroke-width 1px
    z-index 2

</style>
