<template lang="pug">
  .rank-filter
    select(v-model="selected").needsclick
      option(disabled name="") games played by
      option(value="all") all legend players
      option(value="top-1000") top 1000 players
      option(value="top-100") top 100 players

</template>

<script>
  import api from '../api'
  import { trackEvent } from '../utils'

  export default {
    data() {
      return {
        selected: this.$store.state.filter || `all`
      }
    },

    watch: {
      selected() {
        this.$store.dispatch(`setFilterOption`, this.selected)
        trackEvent('filter ranks', 'select', this.selected)
        window.location.pathname = this.$store.getters.filterPath
      }
    }
  }
</script>

<style lang="stylus" scoped>
  .rank-filter select
    margin 0 10px

</style>
