<template lang="pug">
  .top-players(v-if="$store.state.activePlayers.length > 0")
    .header-row
      h2 Replay submitters
      h3 {{ $store.getters.sinceDaysText }}
    .label-row
      .left-label name
      .right-label # games
    .stats
      div(v-for="([name, playerData]) in $store.state.activePlayers")
        a.stats-row(
          :href="`/players/${name.split('#')[0]}`"
          @click="clickUserName(name.split('#')[0])"
        )
          .left-label {{ name.split("#")[0] }}
          .right-label {{ playerData.count }}
        a.twitch-url(
          v-if="playerData.twitch_username"
          :href="twitchUrl(playerData.twitch_username)"
          target="_blank"
        ) Watch {{ name.split("#")[0] }} on Twitch.tv

</template>

<script lang="ts">
  import { trackEvent } from '../utils'

  export default {
    methods: {
      clickUserName(name): void {
        trackEvent('click player', 'name', name)
      },
      twitchUrl(username): string {
        return `https://twitch.tv/${username}`
      }
    },
  }
</script>

<style lang="stylus" scoped>
  .header-row
    padding-bottom 10px
    border-bottom 1px solid rgba(0,0,0,0.1)
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

    &:hover, &.active
      color #45ABFE
      cursor pointer

    .left-label
      font-weight bold

    .right-label
      width 60px
      font-weight normal
      margin-left auto
      text-align right

  .twitch-url
    color #45ABFE
    display block
    font-size 12px
    text-decoration none
    margin-bottom 8px

    &:hover
      text-decoration underline

</style>
