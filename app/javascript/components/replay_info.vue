<template lang="pug">
  .replay-info
    .about-replay
      .players {{ replay.p1.name }} vs. {{ replay.p2.name }}
      .small
        .num-turns {{ replay.numTurns }} turns
        .separator &bull;
        .time-ago {{ timeAgo }}
      a.watch-link(
        :href="replay.hsreplayLink"
        target="_blank"
        @click="replayClicked"
      ) Watch on hsreplay.net
    // .replay-likes
      div(v-if="replayLikes.liked") Liked
      a(v-else @click="likeReplay") Like
      template(v-if="numLikes")
        .separator &bull;
        .num-likes {{ numLikesText }}
      .error-message(v-if="showError")
        a(href="/account/login") Log in with battle.net
        div to like replays
    .deck(@mouseleave="showCardImage(false)")
      .about-deck
        .deck-owner {{ replay.p1.name }}'s deck
        .dust-cost(v-if="replay.deckDustCost > 0") {{ replay.deckDustCost }} dust
      .deck-card-names
        .card(
          v-for="card in replay.deckCards"
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

<script>
  import Replay from '../models/replay'
  import api from '../api'
  import { trackEvent, timeAgo } from '../utils'

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
      }
    },

    methods: {
      likeReplay() {
        api.post(`/replays/like.json`, { replay_id: this.replay.hsreplayId })
          .then(response => response.data)
          .then(data => {
            this.$store.dispatch(`setReplayLikes`, {
              replayId: data.hsreplay_id,
              numLikes: data.likes,
              liked: data.liked,
            })
          })
          .catch(error => {
            if (error.request.status === 401) {
              this.showError = true
            } else {
              throw error
            }
          })
        trackEvent('like', 'replay', this.replay.hsreplayId)
      },
      replayClicked() {
        trackEvent('click', 'watch replay', this.replay.hsreplayId)
      },
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
      replayLikes() {
        return this.$store.getters.replayLikes(this.replay.hsreplayId)
      },
      numLikes() {
        return this.replayLikes.numLikes
      },
      numLikesText() {
        if (this.numLikes) {
          return this.numLikes === 1 ? `1 like` : `${this.numLikes} likes`
        }
      },
      timeAgo() {
        return timeAgo(this.replay.foundAt)
      },
    }
  }
</script>

<style lang="stylus" scoped>
  .replay-info
    font-size 14px

  .separator
    margin 0 5px

  .about-replay
    margin-bottom 15px

    .players
      font-weight bold
      margin-bottom 10px

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

      &:hover
        opacity 0.8

  // likes
  .replay-likes
    display flex
    font-size 17px

    a
      color #45abfe

      &:hover
        cursor pointer
        text-decoration underline

    .error-message
      margin-left 15px
      margin-top -4px
      line-height 20px

  // card
  .deck
    margin-top 25px

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
