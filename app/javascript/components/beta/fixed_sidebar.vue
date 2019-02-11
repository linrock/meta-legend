<template lang="pug">
  aside.fixed-sidebar(v-if="showSidebar")
    .sidebar-container
      replay-info(:replay="$store.getters.currentReplay")

</template>

<script lang="ts">
  import ReplayInfo from '../sidebar/replay_info'

  export default {
    computed: {
      showSidebar() {
        return this.$store.getters.currentReplay
      }
    },

    components: {
      ReplayInfo
    }
  }
</script>

<style lang="stylus" scoped>
  .fixed-sidebar
    position fixed
    left 50%
    top: 0
    background white
    width 260px
    height 100%
    max-height 100%
    overflow-x hidden
    overflow-y auto
    margin-left 135px
    padding-left 10px
    padding-top 20px
    z-index 5 // needs to be higher than rank diamonds

  .sidebar-container
    max-height 100%

</style>
