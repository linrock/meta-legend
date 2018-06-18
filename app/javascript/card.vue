<template lang="pug">
  main
    replay-list(:replays="replays")
    sidebar

</template>

<script lang="ts">
  import Replay from './models/replay'
  import ReplayList from './components/replay_list'
  import Sidebar from './components/sidebar'

  export default {
    data() {
      const replayDataEl: HTMLElement = document.querySelector("#replay-data")
      return {
        replays: JSON.parse(replayDataEl.innerText).map(replayData => new Replay(replayData)),
        replayDataEl,
      }
    },

    created() {
      this.$store.dispatch(`setCurrentCard`, this.replayDataEl.dataset.cardId)
    },

    components: {
      ReplayList,
      Sidebar,
    },
  }
</script>

<style lang="stylus" scoped>
  replay-feed-width = 510px
  sidebar-width = 240px
  sidebar-margin = 20px

  main
    width replay-feed-width + sidebar-width + 2 * sidebar-margin
    margin 0 auto
    display flex

</style>
