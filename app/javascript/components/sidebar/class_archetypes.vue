<template lang="pug">
  .class-archetypes(v-if="classArchetypeRows.length > 0")
    .header-row
      h2 {{ title }}
      h3 {{ $store.getters.sinceDaysText }}
    .label-row
      .left-label deck type
      .mid-label winrate
      .right-label # games
    .archetype-selector
      router-link.stats-row(
        v-for="([path, route]) in classArchetypeRows"
        :class="[{ active: currentRoute.archetype === route.archetype }]"
        :key="fullPath(path)"
        :to="fullPath(path)"
      )
        .name {{ route.archetype }}
        .mid-value {{ route.winrate }}%
        .right-value {{ route.n }}

</template>

<script lang="ts">
  import Route from '../../models/route'

  export default {
    methods: {
      fullPath(path) {
        const prefix = this.$store.getters.filterPrefix
        const route = `/${[prefix, path].filter(x => x).join(`/`)}`
        return route
      }
    },

    computed: {
      currentRoute(): Route {
        return this.$store.getters.currentRoute
      },
      classArchetypeRows(): Array<Route> {
        if (this.currentRoute.class) {
          return this.$store.getters.classArchetypeRows(this.currentRoute.class)
        } else {
          return []
        }
      },
      title(): string {
        if (this.currentRoute) {
          return `Top ${this.currentRoute.class} decks`
        }
      }
    }
  }
</script>

<style lang="stylus" scoped>
  .class-archetypes
    width 230px

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

    .mid-label
      width 60px
      margin-left auto
      text-align right

    .right-label
      width 60px
      text-align right

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

    .mid-value
      width 60px
      margin-left auto
      text-align right

    .right-value
      width 60px
      text-align right

</style>
