<template lang="pug">
  section#sidebar(:class="[{ fixed: fixedSidebar }]")
    template(v-if="$store.getters.currentReplay")
      replay-info
    template(v-else)
      template(v-if="$store.getters.currentRoute.class")
        class-archetypes
        about-winrates
      template(v-else)
        top-decks
        // popular-archetypes
</template>

<script>
  import AboutWinrates from './about_winrates'
  import ClassArchetypes from './class_archetypes'
  import ReplayInfo from './replay_info'
  import TopDecks from './top_decks'

  const scrollThreshold = 185

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
      AboutWinrates,
      ClassArchetypes,
      ReplayInfo,
      TopDecks,
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
      top 30px

</style>
