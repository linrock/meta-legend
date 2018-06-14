<template lang="pug">
  .rank-filter
    .prompt Show me:
    select(v-model="selected").needsclick
      option(disabled name="") games played by
      option(value="all") all legend players
      option(value="top1000") top 1000 players
      option(value="top100") top 100 players

</template>

<script>
  import api from '../api'
  import { trackEvent } from '../utils'

  export default {
    data() {
      return {
        selected: `all`
      }
    },

    watch: {
      selected() {
        this.$store.dispatch(`setFilterOption`, this.selected)
        trackEvent('filter ranks', 'select', this.selected)
        api.get(`/popular.json?filter=${this.selected}`)
          .then(response => response.data)
          .then(data => {
            this.$store.dispatch(`setInitialData`, data.replay_stats)
          })
      }
    }
  }
</script>

<style lang="stylus" scoped>
  .rank-filter
    display flex
    align-items center
    justify-content center
    font-size 14px
    padding-bottom 15px

    .prompt
      font-weight bold

    select
      margin-left 10px

</style>
