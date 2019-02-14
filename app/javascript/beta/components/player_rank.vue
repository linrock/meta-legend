<template lang="pug">
  .rank
    template(v-if="player.legendRank")
      .rank-num.legend-rank(:class="legendRank") {{ player.legendRank }}
      svg.hexagon.legend-hexagon
        use(xlink:href="#hexagon")
    template(v-else)
      .rank-num {{ player.rank || `??` }}
      svg.hexagon.rank-hexagon
        use(xlink:href="#hexagon")

</template>

<script lang="ts">
  import { Player } from '../models/player'

  export default {
    props: {
      player: {
        required: true,
        type: Player,
      },
    },

    computed: {
      legendRank(): string {
        const rank = this.player.legendRank
        if (rank <= 10) {
          return `top-10`
        } else if (rank < 100) {
          return `top`
        } else if (rank <= 500) {
          return `high`
        } else if (rank < 1000) {
          return `mid`
        } else {
          return `low`
        }
      },
    }
  }
</script>

<style lang="stylus" scoped>
  .rank
    font-size 10px
    position relative
    text-align center
    width 55px

  .rank-num
    position relative
    z-index 3

  .legend-rank
    &.top-10
      font-weight bold
      font-size 18px

    &.top
      font-weight bold
      font-size 13px
      letter-spacing 0.5px

    &.high
      letter-spacing 0.3px
      font-size 11px

    &.mid
      letter-spacing 0.3px
      font-size 11px
      opacity 0.8

    &.low
      opacity 0.4

  .hexagon
    position absolute
    left 50%
    top 50%
    margin-top -14px
    margin-left -12.5px
    width 25px
    height 28px
    z-index 1

    &.legend-hexagon
      fill #fff100
      stroke #ffcd00
      stroke-width 2px
      opacity 0.7

    &.rank-hexagon
      fill none
      stroke #737373
      stroke-width 1px
      opacity 0.7

</style>
