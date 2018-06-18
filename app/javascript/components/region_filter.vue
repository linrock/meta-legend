<template lang="pug">
  .region-filter
    select(v-model="selected").needsclick
      option(disabled name="") choose a region
      option(value="all") all regions
      option(value="us") Americas
      option(value="eu") Europe
      option(value="sea") Asia

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
        this.$store.dispatch(`setRegionOption`, this.selected)
        trackEvent('filter region', 'select', this.selected)
        api.get(`/popular.json${this.$store.getters.filterQueryString}`)
          .then(response => response.data)
          .then(data => {
            this.$store.dispatch(`setInitialData`, data.replay_stats)
          })
      }
    }
  }
</script>

<style lang="stylus" scoped>
  .region-filter select
    margin 0 10px

</style>
