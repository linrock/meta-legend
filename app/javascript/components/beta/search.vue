<template lang="pug">
  .search
    .search-filters
      .selector-group
        .label Show me
        select-game-type
      .selector-group
        .label Played at
        select-rank-range
      .selector-group
        .label With at least
        .label 8 turns
      .selector-group
        .label Piloted by
        select-p1-class
      .selector-group
        .label Against
        select-p2-class
    .search-stats
    .search-results
      replay-row(
        v-for="replay in $store.getters.replays"
        :key="replay.key"
        :replay="replay"
      )

</template>

<script lang="ts">
  import ReplayRow from './replay_row'
  import SelectGameType from './select_game_type'
  import SelectRankRange from './select_rank_range'
  import SelectP1Class from './select_p1_class'
  import SelectP2Class from './select_p2_class'
  import { paramsToString } from '../../utils'
  import api from '../../api'

  export default {
    data() {
      return {
        choosing: null,
      }
    },

    methods: {
      chooseClassAndArchetype() {
        console.log(`choosing class and archetype`)
      },
      chooseVs() {
        console.log(`choosing vs`)
      }
    },

    components: {
      ReplayRow,
      SelectGameType,
      SelectRankRange,
      SelectP1Class,
      SelectP2Class,
    }
  }
</script>

<style lang="stylus">
  .search-filters
    min-height 100px

  .search-stats
    border-bottom 1px solid rgba(0,0,0,0.15)

  .selector-group
    position relative

    .selector
      .selected
        user-select none

        &:hover
          color #45abfe
          cursor pointer

      .selector-dropdown
        position absolute
        background white
        border-radius 2px
        box-shadow 0 1px 10px rgba(0,0,0,0.15)
        font-weight normal
        min-width 160px
        left 140px
        top 30px
        z-index 10
        padding 10px

        .select-dropdown-container
          position relative

          &:before
            content ""
            position absolute
            width 20px
            height 20px
            top -28px
            border 10px solid transparent
            border-bottom 10px solid white
            background none

        .option
          user-select none
          font-weight normal
          padding 5px 0

          &:hover
            color #45abfe
            cursor pointer

</style>
