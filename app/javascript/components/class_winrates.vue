<template lang="pug">
  .class-winrates
    .winrate(v-for="([path, route]) in $store.getters.classArray") {{ route.winrate }}%

</template>

<script>
  export default {
    computed: {
      currentRoute() {
        return this.$store.getters.currentRoute
      },
    }
  }
</script>

<style lang="stylus" scoped>
  .class-winrates
    width 720px
    display flex
    flex-wrap wrap
    justify-content space-between
    align-items center

    .winrate
      opacity 0.5
      width 77px
      text-align center

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
