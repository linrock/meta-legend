<template lang="pug">
  main
    header
      class-image-selector
      class-winrates
    article
      section#replays(:class="[{ loading: isLoading && isLoadingPageOne }]")
        .top-row
          rank-filter
          h3.replay-feed-title {{ $store.state.replayFeedTitle }}
        template(v-if="$store.getters.replays.length === 0")
          .loading-text(v-if="isLoading") Loading...
          .loading-text(v-else) No replays found
        .error-text(v-if="error") Failed to fetch replays :(
        .replay-feed-container
          .replay-feed
            .replay-list
              replay-row(
                v-for="replay in $store.getters.replays"
                :key="replay.hsreplay_id"
                :replay="replay"
              )
          .bottom(ref="bottom")
            .back-to-top(
              v-if="$store.getters.currentPage > 1 && !infiniteScrollOn"
              @click="backToTop()"
            ) Back to top
      sidebar

</template>

<script>
  import axios from 'axios'

  import AboutSelection from './components/about_selection'
  import ClassImageSelector from './components/class_image_selector'
  import ClassWinrates from './components/class_winrates'
  import PopularArchetypes from './components/popular_archetypes'
  import RankFilter from './components/rank_filter'
  import ReplayRow from './components/replay_row'
  import Sidebar from './components/sidebar'
  import { trackEvent } from './utils'

  const pageTitleSuffix = `Hearthstone Replay Finder`
  const infScroll = {
    delayBeforeEnabling: 1000,
    triggerDistance: 500,
    pollInterval: 300,
  }

  export default {
    data() {
      return {
        error: false,
        isLoading: false,
        isLoadingPageOne: false,
        infiniteScrollOn: false,
        scrollPoller: null,
      }
    },

    created() {
      // legendStats - routes, about, players
      const { legendStats, replayData } = window.hsrpf
      this.$store.dispatch(`setInitialData`, legendStats)
      const path = this.$route.params.path || `/`
      this.$store.dispatch(`setPath`, path)
      const replays = replayData.replays
      if (replays && replays.length > 0 && replayData.path === path) {
        this.setReplays(replays)
      } else {
        this.fetchReplays()
      }
      const route = replayData.route || this.$store.getters.currentRoute
      if (route) {
        this.setPageTitle(route)
      }
      this.enableInfiniteScroll()
      this.scrollPoller = setInterval(() => {
        const d = this.distanceFromBottom()
        if (d < infScroll.triggerDistance && !this.isLoading && this.infiniteScrollOn) {
          this.fetchReplays(this.$store.getters.currentPage + 1)
        }
      }, infScroll.pollInterval)
    },

    computed: {
      path() {
        return this.$store.state.path
      },
      filter() {
        return this.$store.state.filter
      },
    },

    methods: {
      setReplays(replays) {
        this.$store.dispatch(`setReplays`, replays)
        this.fetchReplayLikes(replays)
      },
      setPageTitle(route) {
        this.$store.dispatch(`setReplayFeedTitle`, route)
        let newPageTitle = pageTitleSuffix
        if (route.class && route.archetype) {
          newPageTitle = `${route.archetype} ${route.class} | ${pageTitleSuffix}`
        } else if (route.class) {
          newPageTitle = `${route.class} | ${pageTitleSuffix}`
        }
        document.title = newPageTitle
      },
      enableInfiniteScroll() {
        setTimeout(() => this.infiniteScrollOn = true, infScroll.delayBeforeEnabling)
      },
      disableInfiniteScroll() {
        this.infiniteScrollOn = false
      },
      distanceFromBottom() {
        if (!this.$refs.bottom) {
          return Infinity
        } else {
          return this.$refs.bottom.offsetTop - (window.scrollY + window.innerHeight)
        }
      },
      apiQuery(page) {
        let query = `replays.json?path=${this.path || `/`}`
        if (this.filter) {
          query = `${query}&filter=${this.filter}`
        }
        if (page) {
          query = `${query}&page=${page}`
        }
        return query
      },
      fetchReplays(page) {
        this.isLoading = true
        this.error = false
        page = page || 1
        if (page === 1) {
          this.isLoadingPageOne = true
        }
        axios.get(this.apiQuery(page))
          .then(response => response.data)
          .then(data => {
            if (this.path !== data.path) {
              return
            }
            this.isLoading = false
            this.isLoadingPageOne = false
            this.$store.dispatch(`setPage`, data.page)
            if (data.page === 1) {
              this.setReplays(data.replays)
              this.setPageTitle(data.route || {})
              if (data.replays_count === data.page_size) {
                this.enableInfiniteScroll()
              } else {
                this.disableInfiniteScroll()
              }
              this.backToTop()
            } else {
              this.$store.dispatch(`addReplays`, data.replays)
              if (data.page < page || data.replays.length === 0) {
                this.disableInfiniteScroll()
              }
              this.fetchReplayLikes(data.replays)
            }
          })
          .catch(error => {
            if (error.request.status === 404) {
              this.$router.replace({ path: `/` })
              return
            }
            console.error(error)
            this.disableInfiniteScroll()
            this.isLoading = false
            this.isLoadingPageOne = false
            this.error = true
          })
        trackEvent('fetch replays', this.path, page)
      },
      fetchReplayLikes(replays) {
        const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        axios.post(`/replays/get_likes.json`, {
          hsreplay_ids: replays.map(r => r.hsreplay_id)
        }, {
          headers: {
            'X-CSRF-Token': token
          }
        })
          .then(response => response.data)
          .then(data => data.replay_likes.forEach(([replayId, likeData]) => {
            console.log(replayId)
            console.log(JSON.stringify(likeData))
            this.$store.dispatch(`setReplayLikes`, {
              numLikes: likeData.likes,
              liked: likeData.liked,
              replayId,
            })
          }))
      },
      backToTop() {
        window.scrollTo(0, 0)
      }
    },

    watch: {
      $route(to, from) {
        let path = to.params.path || `/`
        this.$store.dispatch(`setPath`, path)
        this.fetchReplays()
      },
      filter() {
        this.fetchReplays()
      },
    },

    components: {
      AboutSelection,
      ClassImageSelector,
      ClassWinrates,
      PopularArchetypes,
      RankFilter,
      ReplayRow,
      Sidebar,
    },
  }
</script>

<style lang="stylus" scoped>
  replay-feed-width = 510px
  sidebar-width = 240px
  sidebar-margin = 10px

  main
    width replay-feed-width + sidebar-width
    margin 0 auto

  header
    margin-bottom 30px

  article
    display flex

  #replays
    position relative
    width replay-feed-width

  section.loading
    opacity 0.5
    transition opacity 0.15s ease-in-out

  .loading-text
    position absolute
    top 240px
    text-align center
    font-size 30px
    opacity 0.5
    width replay-feed-width

  .error-text
    width replay-feed-width
    text-align center
    font-size 20px
    padding 27px
    background white
    position fixed
    top 271px
    border 1px solid rgba(0,0,0,0.3)
    z-index 5

  .top-row
    display flex
    align-items center
    padding-bottom 8px
    border-bottom 1px solid rgba(0,0,0,0.1)
    margin-bottom 26px

    .rank-filter
      font-size 16px

    h3.replay-feed-title
      width replay-feed-width
      font-size 16px
      font-weight bold
      margin-left 30px

  .replay-feed
    display flex
    width 100%
    min-height 1200px

  .bottom
    height 100px
    width replay-feed-width

    .back-to-top
      text-align center
      margin-top 35px
      opacity 0.4

      &:hover
        cursor pointer
        opacity 0.9

</style>
