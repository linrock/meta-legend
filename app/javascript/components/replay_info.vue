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
    // .replay-likes
      div(v-if="replayLikes.liked") Liked
      a(v-else @click="likeReplay") Like
      template(v-if="numLikes")
        .separator &bull;
        .num-likes {{ numLikesText }}
      .error-message(v-if="showError")
        a(href="/account/login") Log in with battle.net
        div to like replays
    deck-cards(
      :player="replay.p1"
      :dustCost="replay.deckDustCost"
      :cards="replay.deckCards"
    )
</template>

<script lang="ts">
  import Replay from '../models/replay'
  import DeckCards from './deck_cards'
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
        showReplayComment: false,
      }
    },

    watch: {
      replay() {
        this.showReplayComment = false
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
    },

    components: {
      DeckCards
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

</style>
