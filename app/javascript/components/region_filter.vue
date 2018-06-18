<template lang="pug">
  .region-filter
    select(v-model="selected").needsclick
      option(disabled name="") choose a region
      option(value="all") all regions
      option(value="americas") Americas
      option(value="europe") Europe
      option(value="asia") Asia

</template>

<script>
  import api from '../api'
  import { trackEvent } from '../utils'

  export default {
    data() {
      return {
        selected: this.$store.state.region || `all`
      }
    },

    watch: {
      selected() {
        this.$store.dispatch(`setRegionOption`, this.selected)
        trackEvent('filter region', 'select', this.selected)
        window.location.pathname = this.$store.getters.filterPath
      }
    }
  }
</script>

<style lang="stylus" scoped>
  .region-filter select
    margin 0 10px

</style>
