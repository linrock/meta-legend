<template lang="pug">
  .replay-info
    a.watch-link(
      :href="replayLink"
      target="_blank"
    ) Watch on hsreplay.net
    .about-replay
      .players {{ p1Name }} vs. {{ p2Name }}
      .small
        .num-turns {{ replay.num_turns }} turns
        .separator &bull;
        .time-ago {{ timeAgo }}
    .deck-card-names
      .card(v-for="card in replay.deck_card_names")
        .cost {{ card.cost }}
        .name {{ card.name }}
        .quantity x{{ card.n }}

</template>

<script>
  import { timeAgo } from '../utils'

  export default {
    computed: {
      replay() {
        console.dir(this.$store.getters.currentReplay)
        return this.$store.getters.currentReplay
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

<style lang="stylus">
  .replay-info
    font-size 14px

  .about-replay
    margin 5px 0 15px

    .players
      font-weight bold
      margin 10px 0

    .small
      display flex
      font-size 12px
      opacity 0.7

      .separator
        margin 0 5px

  .deck-card-names
    margin-top 25px

  .card
    padding 2px
    display flex

    .cost
      width 25px

    .name
      width 180px

    .quantity
      opacity 0.4
      width 15px

</style>
