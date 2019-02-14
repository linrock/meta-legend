<template lang="pug">
  .deck-cards
    .deck(@mouseleave="showCardImage(false)")
      .about-deck
        .deck-owner {{ title }}
        .dust-cost(v-if="showDustCost") {{ player.deckDustCost }} dust
      .deck-card-names
        .card(
          v-for="card in player.deckCards"
          :class="card.rarity"
          @mouseenter="showCardImage(card.id)"
        )
          .cost {{ card.cost }}
          a.name(
            :href="card.href"
            target="_blank"
            @click="cardClicked(card.name)"
          ) {{ card.name }}
          .quantity(v-if="card.n > 1") x{{ card.n }}
    .card-preview(v-if="cardUrl")
      img(:src="cardUrl")

</template>

<script lang="ts">
  import { Player } from '../models/player'
  import { trackEvent } from '../../utils'

  export default {
    props: {
      player: {
        type: Player,
        required: true
      },
    },

    data() {
      return {
        cardUrl: false
      }
    },

    methods: {
      cardClicked(cardName) {
        trackEvent('click', 'card name', cardName)
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
      title() {
        let title = `${this.player.name}'s`
        if (this.player.deckStatus === `predicted`) {
          title = `${title} predicted`
        } else if (this.player.deckStatus === `partial`) {
          title = `${title} partial`
        }
        return `${title} deck`
      },
      showDustCost() {
        return this.player.deckStatus === `full`
      }
    }
  }
</script>

<style lang="stylus" scoped>
  // card
  .deck
    margin 25px 0

    .deck-card-names
      margin-top 10px

  .about-deck
    opacity 0.4
    display flex
    padding-bottom 5px
    border-bottom 1px solid rgba(0,0,0,0.1)

    .dust-cost
      margin-left auto

  .card
    padding 2px 0
    margin 2px 0
    display flex
    font-size 15px
    letter-spacing -0.2px
    text-decoration none

    &.common, &.free
      opacity 0.8

    &.rare
      color blue

    &.epic
      color #8A2BE2

    &.legendary
      color orange

    .cost
      width 25px

    .name
      color inherit
      width 190px
      text-decoration none

      &:hover
        text-decoration underline

    .quantity
      opacity 0.4
      width 15px

  .card-preview
    position fixed
    top 150px
    left 50%
    margin-left -150px

</style>
