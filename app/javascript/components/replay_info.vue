<template lang="pug">
  .replay-info
    .about-replay
      .players {{ replay.p1Name }} vs. {{ replay.p2Name }}
      .small
        .num-turns {{ replay.numTurns }} turns
        .separator &bull;
        .time-ago {{ timeAgo }}
      a.watch-link(
        :href="replay.hsreplayLink"
        target="_blank"
      ) Watch on hsreplay.net
    .replay-likes
      div(v-if="replayLikes.liked") Liked
      a(v-else href="javascript:" @click="likeReplay") Like
      template(v-if="numLikes")
        .separator &bull;
        .num-likes {{ numLikesText }}
      .error-message(v-if="showError")
        a(href="/account/login") Log in with battle.net
        div to like replays
    .deck
      // .about-deck {{ replay.p1Name }}'s deck
      .deck-card-names
        .card(v-for="card in replay.deckCardNames")
          .cost {{ card.cost }}
          .name {{ card.name }}
          .quantity(v-if="card.n > 1") x{{ card.n }}

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
        showError: false
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
      margin 10px 0

    .small
      display flex
      font-size 15px
      opacity 0.7
      margin-bottom 10px

    .watch-link
      color #45abfe
      text-decoration none
      font-size 16px

      &:hover
        text-decoration underline

  // likes
  .replay-likes
    display flex
    font-size 17px

    .error-message
      margin-left 15px
      margin-top -4px
      line-height 20px

  // card
  .deck
    margin-top 25px

    .deck-card-names
      margin-top 10px

  .card
    padding 3px 0
    display flex
    font-size 15px
    letter-spacing -0.2px

    .cost
      width 25px

    .name
      width 190px

    .quantity
      opacity 0.4
      width 15px

</style>
