<template lang="pug">
  .search
    .search-filters
      div
        .label Show me
        .selector Standard games
      div
        .label Played at
        .selector Rank 5 and above
      div
        .label By
        .selector Secret Hunter
      div
        .label Against
        .selector Odd Mage
    .search-results
      replay-row(
        v-for="replay in replays"
        :key="replay.key"
        :replay="replay"
      )
</template>

<script lang="ts">
  import store from '../../beta_store'
  import ReplayRow from './replay_row'

  export default {
    data() {
      return {
        replays: store.replays
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
