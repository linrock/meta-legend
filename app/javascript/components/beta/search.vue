<template lang="pug">
  .search
    .search-filters
      .selector-group
        .label Show me
        .selector(@click="chooseGameType") Standard games
        select-game-type(
          v-if="$store.getters.currentDropdown === 'game_type'"
        )
      .selector-group
        .label Played at
        .selector(@click="chooseRank") Rank 5 and above
        select-rank-range(
          v-if="$store.getters.currentDropdown === 'rank_range'"
        )
      .selector-group
        .label By
        .selector(@click="chooseClassAndArchetype") Secret Hunter
      .selector-group
        .label Against
        .selector(@click="chooseVs") Odd Mage
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

  export default {
    data() {
      return {
        choosing: null,
      }
    },

    methods: {
      chooseGameType() {
        console.log(`choosing game type`)
        this.$store.dispatch(`toggleDropdown`, `game_type`)
      },
      chooseRank() {
        console.log(`choosing rank`)
        this.$store.dispatch(`toggleDropdown`, `rank_range`)
      },
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
    }
  }
</script>

<style lang="stylus" scoped>
  .search-filters
    min-height 100px

  .selector-group
    position relative

    .selector-dropdown
      position absolute
      background white
      border-radius 2px
      box-shadow 0 1px 10px rgba(0,0,0,0.15)
      min-width 160px
      left 110px
      top 30px
      z-index 10
      padding 10px

      >>> .option
        padding 5px 0

</style>
