<template lang="pug">
  .replay-info
    a.watch-link(
      :href="replayLink"
      target="_blank"
    ) Watch on hsreplay.net
    .about-replay
      .players {{ replay.p1.tag }} vs. {{ replay.p2.tag }}
      .num-turns {{ replay.num_turns }} turns
    .deck-card-names
      .card(v-for="card in replay.deck_card_names")
        .cost {{ card.cost }}
        .name {{ card.name }}
        .quantity {{ card.n }}

</template>

<script>
  export default {
    computed: {
      replay() {
        console.dir(this.$store.getters.currentReplay)
        return this.$store.getters.currentReplay
      },
      replayLink() {
        return `https://hsreplay.net/replay/${this.replay.hsreplay_id}`
      }
    }
  }
</script>

<style lang="stylus">
  .replay-info
    font-size 14px

  .about-replay
    margin 5px 0 15px
    
  .card
    padding 2px
    display flex

    .cost
      width 15px

    .name
      width 180px

    .quantity
      width 15px

</style>
