<template lang="pug">
  .search-results
    replay-card(
      v-for="replay in $store.getters.replays"
      :key="replay.key"
      :replay="replay"
    )
    infinite-scroll

</template>

<script lang="ts">
  import ReplayCard from './replay_card'
  import InfiniteScroll from './infinite_scroll'
  import { paramsToString } from '../../utils'

  export default {
    components: {
      ReplayCard,
      InfiniteScroll,
    }
  }
</script>
