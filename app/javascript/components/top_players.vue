<template lang="pug">
  .top-players(v-if="$store.state.activePlayers.length > 0")
    .header-row
      h2 Active players
      h3 {{ pastDays }}
    .label-row
      .left-label name
      .right-label # games
    .stats
      .stats-row(
        v-for="([name, count]) in $store.state.activePlayers"
        @click="clickUserName(name)"
      )
        .left-label {{ name.split("#")[0] }}
        .right-label {{ count }}

</template>

<script>
  import { trackEvent } from '../utils'

  export default {
    methods: {
      clickUserName(name) {
        trackEvent('click player', 'name', name)
      }
    },

    computed: {
      pastDays() {
        const since = this.$store.getters.sinceDays
        if (since === 1) {
          return `past day`
        } else {
          return `past ${since} days`
        }
      }
    }
  }
</script>

<style lang="stylus" scoped>
  .header-row
    padding-bottom 10px
    border-bottom 1px solid rgba(0,0,0,0.2)
    margin-bottom 10px
    display flex
    align-items center

    h2
      font-weight bold

    h3
      font-size 10px
      margin-left auto
      text-transform uppercase
      opacity 0.5

  .label-row
    font-size 10px
    letter-spacing 0.4px
    text-transform uppercase
    display flex
    opacity 0.5
    margin-bottom 8px

    .left-label
      text-align left

    .right-label
      text-align right
      margin-left auto

  .stats-row
    display flex
    line-height 24px
    padding 2px 0
    border-radius 2px
    text-decoration none
    color #333

    .left-label
      font-weight normal

    .right-label
      width 60px
      font-weight normal
      margin-left auto
      text-align right

</style>
