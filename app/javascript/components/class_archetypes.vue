<template lang="pug">
  .class-archetypes(v-if="classArchetypeRows.length > 0")
    h2 {{ title }}
    .label-row
      .class-label deck type
      .winrate-label winrate
    .archetype-selector
      router-link.stats-row(
        v-for="([path, route]) in classArchetypeRows"
        :class="[{ active: currentRoute.archetype === route.archetype }]"
        :key="path"
        :to="path"
      )
        .name {{ route.archetype }}
        .winrate {{ route.winrate }}%
  // transition(name="fade")

</template>

<script>
  export default {
    computed: {
      currentRoute() {
        return this.$store.getters.currentRoute
      },
      classArchetypeRows() {
        if (this.currentRoute.class) {
          return this.$store.getters.classArchetypeRows(this.currentRoute.class)
        } else {
          return []
        }
      },
      title() {
        if (this.currentRoute) {
          return `Top ${this.currentRoute.class} decks`
        }
      }
    }
  }
</script>

<style lang="stylus" scoped>
  h2
    font-weight bold
    padding-bottom 10px
    border-bottom 1px solid rgba(0,0,0,0.05)
    margin-bottom 10px

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
      margin-left auto
      text-align right

  .fade-enter-active, .fade-leave-active
    transition all 0.2s ease
    transform translate3d(0, 0, 0)
    opacity 1

  .fade-enter, .fade-leave-to
    transform translate3d(0, -4px, 0)
    opacity 0

</style>
