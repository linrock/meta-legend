<template lang="pug">
  section#sidebar(:class="[{ fixed: fixedSidebar }]")
    template(v-if="$store.getters.currentReplay")
      replay-info(:replay="$store.getters.currentReplay")
    template(v-else)
      template(v-if="$store.getters.currentRoute.class")
        class-archetypes
      template(v-else)
        top-decks
        top-players
        // popular-archetypes
</template>

<script>
  import ClassArchetypes from './class_archetypes'
  import ReplayInfo from './replay_info'
  import TopDecks from './top_decks'
  import TopPlayers from './top_players'

  // this.el.getBoundingClientRect().top - (top padding)
  const scrollThreshold = 223 - 20

  export default {
    data() {
      return {
        fixedSidebar: false,
      }
    },

    created() {
      // move fixed sidebar component
      window.addEventListener('scroll', () => {
        if (window.scrollY >= scrollThreshold && !this.fixedSidebar) {
          this.fixedSidebar = true
        } else if (window.scrollY < scrollThreshold && this.fixedSidebar) {
          this.fixedSidebar = false
        }
      })
    },

    components: {
      ClassArchetypes,
      ReplayInfo,
      TopDecks,
      TopPlayers,
    }
  }
</script>

<style lang="stylus" scoped>
  sidebar-width = 240px
  sidebar-margin = 10px

  #sidebar
    padding-left sidebar-margin
    width sidebar-width

    &.fixed
      position fixed
      left 50%
      margin-left 135px
      top: 0
      padding-top 20px

</style>
