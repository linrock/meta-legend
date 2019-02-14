<template lang="pug">
  .replay-info
    .about-replay
      .players
        a(
          :href="`/players/${replay.p1.name}`"
          target="_blank"
          @click="playerNameClicked(replay.p1.name)"
        ) {{ replay.p1.name }}
        .vs vs.
        a(
          :href="`/players/${replay.p2.name}`"
          target="_blank"
          @click="playerNameClicked(replay.p2.name)"
        ) {{ replay.p2.name }}
      .small
        .num-turns {{ replay.numTurns }} turns
        .separator &bull;
        .time-ago {{ timeAgo }}
      a.watch-link(
        :href="replay.hsreplayLink"
        target="_blank"
        @click="replayClicked"
      ) Watch on hsreplay.net
    deck-cards(
      :player="replay.p1"
      :dustCost="replay.deckDustCost"
      :cards="replay.deckCards"
    )
    template(v-if="replay.opposingDeckPredictedCards && replay.opposingDeckPredictedCards.length > 0")
      deck-cards(
        :player="replay.p2"
        :predicted="true"
        :cards="replay.opposingDeckPredictedCards"
      )
    template(v-else)
      deck-cards(
        v-if="replay.opposingDeckCards.length > 0"
        :player="replay.p2"
        :partial="true"
        :cards="replay.opposingDeckCards"
      )

</template>

<script lang="ts">
  import Replay from '../models/replay'
  import DeckCards from '../../components/deck_cards'
  import api from '../../api'
  import { trackEvent, timeAgo } from '../../utils'

  export default {
    props: {
      replay: {
        type: Replay,
        required: true
      }
    },

    data() {
      return {
        showError: false,
        cardUrl: false,
        showReplayComment: false,
      }
    },

    watch: {
      replay() {
        this.showReplayComment = false
      }
    },

    methods: {
      replayClicked() {
        trackEvent('click', 'watch replay', this.replay.hsreplayId)
        const replay = this.replay
        setTimeout(() => {
          if (this.$store.getters.currentReplay === replay) {
            this.showReplayComment = true
            trackEvent('comment box', 'displayed', this.replay.hsreplayId)
          }
        }, 3000)
      },
      cardClicked(cardName) {
        trackEvent('click', 'card name', cardName)
      },
      playerNameClicked(name) {
        trackEvent('click player', 'name', name)
      },
      showCardImage(cardId) {
        if ('ontouchstart' in document.documentElement) {
          return
        }
        if (cardId) {
          this.cardUrl = `https://art.hearthstonejson.com/v1/render/latest/enUS/256x/${cardId}.png`
        } else {
          this.cardUrl = null
        }
      },
    },

    computed: {
      timeAgo() {
        return timeAgo(this.replay.foundAt)
      },
    },

    components: {
      DeckCards
    }
  }
</script>

<style lang="stylus" scoped>
  .replay-info
    font-size 14px
    width 230px

  .separator
    margin 0 5px

  .about-replay
    margin-bottom 15px

    .players
      display flex
      font-weight bold
      margin-bottom 10px

      a
        color #45abfe

      .vs
        margin 0 5px

    .small
      display flex
      opacity 0.7
      font-size 17px
      margin-bottom 12px

    .watch-link
      color white
      background #45abfe
      border-radius 2px
      display block
      padding 10px 0
      text-align center
      text-decoration none
      font-size 16px
      transition opacity 0.15s ease

      &:visited
        opacity 0.3

      &:hover
        opacity 0.65

</style>
