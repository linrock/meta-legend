<template lang="pug">
  .class-stats
    .class-stat(v-for="([path, route]) in $store.getters.classArray")
      .n-games {{ route.n }} games
      .winrate
        span(v-if="route.n > 0") {{ route.winrate }}%
        span(v-else) &nbsp;

</template>

<script lang="ts">
  export default {}
</script>

<style lang="stylus" scoped>
  .class-stats
    width 750px
    display flex
    flex-wrap wrap
    justify-content space-between
    align-items center

    .class-stat
      width 77px
      text-align center

    .n-games
      font-size 12px
      margin-bottom 8px
      opacity 0.5

    .winrate
      opacity 0.5

    .stats-row
      display flex
      line-height 24px
      width 240px
      padding 2px 8px
      border-radius 2px
      text-decoration none
      color #333

      &:hover, &.active
        color #45ABFE
        cursor pointer

      .name
        width 180px
        font-weight bold

      .winrate
        width 60px
        text-align right

</style>
