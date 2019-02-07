<template lang="pug">
  a.replay-link(
    :class="[{ selected: isSelectedReplay }]"
    @click="selectReplay(replay)"
    v-if="replay.p1.isValid && replay.p2.isValid"
  )
    .player.player1
      .player-name
        .win-indicator
          svg.crown(v-if="replay.winner === `p1`")
            use(xlink:href="#crown")
        .name {{ replay.p1.name }}
      .archetype(:class="[{ [p1Color]: p1Highlight }]")
        | {{ replay.p1.deckType }}
    player-rank(:player="replay.p1")
    .vs vs
    player-rank(:player="replay.p2")
    .player.player2
      .player-name
        .name {{ replay.p2.name }}
        .win-indicator
          svg.crown(v-if="replay.winner === `p2`")
            use(xlink:href="#crown")
      .archetype(:class="[{ [p2Color]: p2Highlight }]")
        | {{ replay.p2.deckType }}

</template>

<script lang="ts">
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
        if (replay) {
          trackEvent('click row', 'replay', replay.hsreplayId)
        }
      },
    },

    computed: {
      currentRoute() {
        return this.$store.getters.currentRoute
      },
      isSelectedReplay() {
        return this.replay === this.$store.getters.currentReplay
      },
      p1Color() {
        return `color-${this.replay.p1.className}`
      },
      p1Highlight() {
        if (this.currentRoute.class) {
          if (this.currentRoute.archetype) {
            return this.replay.p1.deckType === `${this.currentRoute.archetype} ${this.currentRoute.class}`
          } else {
            return this.replay.p1.className === this.currentRoute.class.toLowerCase()
          }
        }
      },
      p2Color() {
        return `color-${this.replay.p2.className}`
      },
      p2Highlight() {
        if (this.currentRoute.class) {
          if (this.currentRoute.archetype) {
            return this.replay.p2.deckType === `${this.currentRoute.archetype} ${this.currentRoute.class}`
          } else {
            return this.replay.p2.className === this.currentRoute.class.toLowerCase()
          }
        }
      }
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
      cursor pointer

      .player
        color #45ABFE

        .archetype
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

      .name
        transition color 0.2s ease

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
