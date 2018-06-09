<template lang="pug">
  .top-decks
    .header-row
      h2 Top decks
      h3 {{ pastDays }}
    .label-row
      .class-label deck type
      .winrate-label winrate
    .archetype-stats
      router-link.stats-row(
        v-for="([path, deck]) in topArchetypeRows"
        :key="path"
        :to="path"
      )
        .name {{ deck.archetype }} {{ deck.class }}
        .winrate {{ deck.winrate }}%

</template>

<script>
  export default {
    computed: {
      topArchetypeRows() {
        return this.$store.state.routeMap.topArchetypeRows
      },
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
  .top-decks
    margin-bottom 40px

  .header-row
    padding-bottom 10px
    border-bottom 1px solid rgba(0,0,0,0.05)
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

    .name
      font-weight bold

    .winrate
      width 60px
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

</style>
