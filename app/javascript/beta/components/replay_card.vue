<template lang="pug">
  a.replay-card(
    :class="[{ selected: isSelectedReplay }]"
    @click="selectReplay(replay)"
  )
    .game-players
      .player.player1
        .player-name
          .win-indicator
            svg.crown(v-if="p1.isWinner")
              use(xlink:href="#crown")
          .name {{ p1.name }}
        .archetype
          | {{ p1.archetype }} {{ p1.className }}
      player-rank(:player="p1")
      .vs vs
      player-rank(:player="p2")
      .player.player2
        .player-name
          .name {{ p2.name }}
          .win-indicator
            svg.crown(v-if="p2.isWinner")
              use(xlink:href="#crown")
        .archetype
          | {{ p2.archetype }} {{ p2.className }}
    .under-info
      .starting-hand
        .post
          div(v-for="card in p1.postMulliganCards")
            span.cost {{ card.cost }}
            span.name {{ card.name }}
      .replay-info
        .left
          .num-turns {{ replay.numTurns }}
          .duration {{ Math.round(replay.durationSeconds / 60) }}
        .right
          .label turns
          .label minutes
          .game-type {{ replay.gameType }}


</template>

<script lang="ts">
  import Replay from '../models/replay'
  import PlayerRank from './player_rank'
  import { trackEvent } from '../../utils'

  export default {
    props: {
      replay: {
        required: true,
        type: Replay,
      },
    },

    methods: {
      selectReplay() {
        const replay = this.isSelectedReplay ? null : this.replay
        this.$store.dispatch(`selectReplay`, replay)
        if (replay) {
          trackEvent(`click row`, `replay`, replay.hsreplayId)
        }
      },
    },

    computed: {
      isSelectedReplay() {
        return this.replay === this.$store.getters.currentReplay
      },
      p1() {
        return this.replay.p1
      },
      p2() {
        return this.replay.p2
      },
    },

    components: {
      PlayerRank,
    }
  }
</script>

<style lang="stylus" scoped>
  a.replay-card
    display block
    color #111
    text-decoration none
    font-size 17px
    margin 10px 0
    width 490px
    border 1px solid #eaeaea
    border-radius 3px

    &:hover
      opacity 1
      cursor pointer
      background #fafafa

    &.selected
      background rgba(0, 0, 0, 0.04)
      border-radius 2px

  .game-players
    align-items center
    justify-content center
    display flex
    padding 10px 0

  // info under the list of game players
  .under-info
    display flex
    justify-content space-between
    background #f7f7f7
    padding 15px 0
    line-height 18px
    font-size 13px

    // pre and post mulligan cards
    .starting-hand
      margin-left 20px

      .cost
        margin-right 10px

    // num turns, duration, game type
    .replay-info
      display flex
      justify-content flex-end
      opacity 0.5
      margin-right 30px

      .left
        margin-right 10px

      .game-type
        text-transform capitalize

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

      .name
        font-size 16px

  .archetype
    font-size 15px
    font-weight bold
    transition color 0.2s ease

  .vs
    font-weight 300
    text-align center
    width 18px
    opacity 0.3

  .win-indicator
    width 30px
    display flex
    text-align center
    align-items center
    justify-content center

  .crown
    width 28px
    height 17px
    fill #ffcd00
    stroke #5f5f5f
    stroke-width 5px
    z-index 2

</style>
