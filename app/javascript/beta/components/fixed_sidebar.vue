<template lang="pug">
  transition(name="fade")
    aside.fixed-sidebar(
      v-if="currentReplay || shouldShow"
      ref="sidebar"
    )
      .sidebar-container
        template(v-if="$store.getters.currentReplay")
          replay-info(:replay="$store.getters.currentReplay")
        div(v-else-if="content" v-html="content")
        template(v-else)
          .share-replays
            div Share your replays!
            a(href="https://hsreplay.net/account/api/hooks/new/")
              | Set up a webhook on hsreplay.net
            br
            br
            div with this Payload URL:
            b https://metalegend.com/webhook

</template>

<script lang="ts">
  import ReplayInfo from './replay_info'

  const pollInterval = 300

  export default {
    props: {
      content: String
    },

    created() {
      setInterval(() => {
        this.shouldShow = this.sidebarOutOfView()
      }, pollInterval)
    },

    data() {
      const sidebarEl = document.querySelector('.sidebar-container')
      const sidebarHeight = sidebarEl ? sidebarEl.scrollHeight : 0
      return {
        shouldShow: false,
        sidebarHeight,
      }
    },

    computed: {
      currentReplay() {
        return this.$store.getters.currentReplay
      },
    },

    methods: {
      sidebarOutOfView() {
        if (this.sidebarHeight === 0) {
          return true
        }
        return window.scrollY > this.sidebarHeight + 200
      }
    },

    watch: {
      currentReplay() {
        this.$refs.sidebar.scrollTo(0, 0)
      },
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
    top: 40px
    background white
    width 260px
    height calc(100% - 40px)
    overflow-x hidden
    overflow-y auto
    margin-left 135px
    padding-left 10px
    padding-top 15px
    z-index 5 // needs to be higher than rank diamonds

  .sidebar-container
    max-height 100%

  .share-replays
    font-size 14px
    line-height 22px

    a
      color #45abfe
    b
      font-weight bold

  .fade-enter-active, .fade-leave-active
    transition opacity 0.1s

  .fade-enter, .fade-leave-to
    opacity 0

</style>
