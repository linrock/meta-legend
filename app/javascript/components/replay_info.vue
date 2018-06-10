<template lang="pug">
  .replay-info
    .about-replay
      .players {{ p1Name }} vs. {{ p2Name }}
      .small
        .num-turns {{ replay.num_turns }} turns
        .separator &bull;
        .time-ago {{ timeAgo }}
      a.watch-link(
        :href="replayLink"
        target="_blank"
      ) Watch on hsreplay.net
    .replay-likes
      div(v-if="replayLikes.liked") Liked
      a(v-else href="javascript:" @click="likeReplay") Like
      template(v-if="numLikes")
        .separator &bull;
        .num-likes {{ numLikesText }}
    .deck
      // .about-deck {{ p1Name }}'s deck
      .deck-card-names
        .card(v-for="card in replay.deck_card_names")
          .cost {{ card.cost }}
          .name {{ card.name }}
          .quantity(v-if="card.n > 1") x{{ card.n }}

</template>

<script>
  import api from '../api'
  import { trackEvent, timeAgo } from '../utils'

  export default {
    props: {
      replay: {
        type: Object,
        required: true
      }
    },

    methods: {
      likeReplay() {
        api.post(`/replays/like.json`, { replay_id: this.replay.hsreplay_id })
          .then(response => response.data)
          .then(data => {
            this.$store.dispatch(`setReplayLikes`, {
              replayId: data.hsreplay_id,
              numLikes: data.likes,
              liked: data.liked,
            })
          })
        trackEvent('like', 'replay', this.replay.hsreplay_id)
      },
    },

    computed: {
      replayLikes() {
        return this.$store.getters.replayLikes(this.replay.hsreplay_id)
      },
      numLikes() {
        return this.replayLikes.numLikes
      },
      numLikesText() {
        if (this.numLikes) {
          return this.numLikes === 1 ? `1 like` : `${this.numLikes} likes`
        }
      },
      replayLink() {
        return `https://hsreplay.net/replay/${this.replay.hsreplay_id}`
      },
      timeAgo() {
        return timeAgo(this.replay.found_at)
      },
      p1Name() {
        return this.replay.p1.tag.split('#')[0]
      },
      p2Name() {
        return this.replay.p2.tag.split('#')[0]
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

  .replay-likes
    display flex
    font-size 17px

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
