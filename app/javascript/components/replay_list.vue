<template lang="pug">
  .replay-list
    replay-row(
      v-for="replay in replays"
      :key="replay.key"
      :replay="replay"
    )
</template>

<script>
  import ReplayRow from './replay_row'

  export default {
    props: {
      replays: Array,
      required: true,
    },

    components: {
      ReplayRow,
    }
  }
</script>
