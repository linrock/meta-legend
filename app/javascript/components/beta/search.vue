<template lang="pug">
  .search
    .search-filters
      div
        .label Show me
        .selector(@click="chooseGameType") Standard games
      div
        .label Played at
        .selector(@click="chooseRank") Rank 5 and above
      div
        .label By
        .selector(@click="chooseClassAndArchetype") Secret Hunter
      div
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

  export default {
    methods: {
      chooseGameType() {
        console.log(`choosing game type`)
      },
      chooseRank() {
        console.log(`choosing rank`)
      },
      chooseClassAndArchetype() {
        console.log(`choosing class and archetype`)
      },
      chooseVs() {
        console.log(`choosing vs`)
      }
    },

    components: {
      ReplayRow
    }
  }
</script>

<style lang="stylus" scoped>
  .search
    .search-filters
      min-height 100px

</style>
