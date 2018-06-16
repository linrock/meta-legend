<template lang="pug">
  main
    replay-list(:replays="replays")
    sidebar

</template>

<script>
  import Replay from './models/replay'
  import ReplayList from './components/replay_list'
  import Sidebar from './components/sidebar'

  export default {
    data() {
      const replayListData = JSON.parse(document.querySelector("#replay-data").text)
      return {
        replays: replayListData.map(replayData => new Replay(replayData))
      }
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
