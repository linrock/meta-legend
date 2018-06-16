<template lang="pug">
  section#sidebar(:class="[{ fixed: fixedSidebar }]")
    template(v-if="$store.getters.currentReplay")
      replay-info(:replay="$store.getters.currentReplay")
    template(v-else)
      template(v-if="$store.getters.currentRoute.class")
        class-archetypes
      template(v-else)
        template(v-if="$store.state.currentCard")
          img(:src="cardUrl()")
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

  export default {
    data() {
      return {
        fixedSidebar: false,
      }
    },

    methods: {
      cardUrl() {
        const cardId = this.$store.state.currentCard
        return `https://art.hearthstonejson.com/v1/render/latest/enUS/256x/${cardId}.png`
      }
    },

    mounted() {
      const scrollThreshold = this.$el.getBoundingClientRect().top - 20 // top padding
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
    z-index 5 // needs to be higher than rank diamonds

    &.fixed
      position fixed
      left 50%
      top: 0
      margin-left 135px
      padding-top 20px

</style>
