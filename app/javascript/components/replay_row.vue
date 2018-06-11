<template lang="pug">
  a.replay-link(
    :class="[{ selected: isSelectedReplay }]"
    @click="selectReplay(replay)"
    v-if="hasValidAttributes"
  )
    .player.player1
      .player-name
        .win-indicator
          svg.crown(v-if="replay.winner === `p1`")
            use(xlink:href="#crown")
        div {{ replay.p1Name }}
      .archetype(:class="getClass(replay.p1.archetype)")
        | {{ replay.p1.archetype }}
    player-rank(:player="replay.p1")
    .vs vs
    player-rank(:player="replay.p2")
    .player.player2
      .player-name
        div {{ replay.p2Name }}
        .win-indicator
          svg.crown(v-if="replay.winner === `p2`")
            use(xlink:href="#crown")
      .archetype(:class="getClass(replay.p2.archetype)")
        | {{ replay.p2.archetype }}

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
      getClass(archetype) {
        return archetype.split(/\s+/).reverse()[0].toLowerCase()
      }
    },

    computed: {
      isSelectedReplay() {
        return this.replay === this.$store.getters.currentReplay
      },
      hasValidAttributes() {
        const { p1, p2 } = this.replay
        return p1.archetype && p2.archetype && p1.legend_rank && p2.legend_rank
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

    &.druid
      color #944b1a

    &.hunter
      color #558a53

    &.mage
      color #6472a2

    &.paladin
      color #a27c0d

    &.priest
      color #a1aeb2

    &.rogue
      color #6c7179

    &.shaman
      color #636eb7

    &.warlock
      color #8a3f9e

    &.warrior
      color #ad3d29

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
