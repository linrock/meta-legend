<template lang="pug">
  section#sidebar(:class="[{ fixed: fixedSidebar }]")
    .sidebar-container
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

<script lang="ts">
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
      setTimeout(() => {
        const scrollThreshold = window.scrollY + this.$el.getBoundingClientRect().top - 20 // top padding
        if (window.scrollY >= scrollThreshold) {
          this.fixedSidebar = true
        }
        window.addEventListener('scroll', () => {
          if (window.scrollY >= scrollThreshold && !this.fixedSidebar) {
            this.fixedSidebar = true
          } else if (window.scrollY < scrollThreshold && this.fixedSidebar) {
            this.fixedSidebar = false
          }
        })
      }, 500)
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
    max-height 100%
    overflow-x hidden
    overflow-y scroll
    z-index 5 // needs to be higher than rank diamonds

    &.fixed
      position fixed
      left 50%
      top: 0
      margin-left 135px
      padding-top 20px

  .sidebar-container
    max-height 100%

</style>
