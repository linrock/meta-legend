<template lang="pug">
  .top-decks(v-if="$store.getters.topArchetypeRows.length > 0")
    .header-row
      h2 Popular decks
      h3 {{ $store.getters.sinceDaysText }}
    .label-row
      .class-label deck type
      .winrate-label # games
    .archetype-stats
      router-link.stats-row(
        v-for="([path, deck]) in $store.getters.topArchetypeRows"
        :key="path"
        :to="fullPath(path)"
        @click="clickTopDeck(path)"
      )
        .left-value(:class="classColor(deck.class)") {{ deck.archetype }} {{ deck.class }}
        .right-value {{ deck.n }}

</template>

<script lang="ts">
  import { trackEvent } from '../utils'

  export default {
    methods: {
      fullPath(path) {
        const prefix = this.$store.getters.filterPrefix
        return `${prefix}/${path}`
      },
      classColor(className) {
        return `color-${className.toLowerCase()}`
      },
      clickTopDeck(path) {
        trackEvent('click', 'popular deck', path)
      },
    }
  }
</script>

<style lang="stylus" scoped>
  .top-decks
    margin-bottom 40px

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

    .class-label
      text-align left

    .winrate-label
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

    .left-value
      font-weight bold

    .right-value
      width 45px
      font-weight normal
      margin-left auto
      text-align right

  a
    display block
    color inherit
    font-weight bold
    text-decoration none

    &:hover
      color #45ABFE

      .left-value
        color #45ABFE

</style>
