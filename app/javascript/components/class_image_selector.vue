<template lang="pug">
  .class-image-selector
    router-link(
      v-for="([path, route]) in $store.getters.classArray"
      :class="[{ active: !currentRoute.class || currentRoute.class === route.class }]"
      :key="path"
      :to="$store.state.path === path ? `/` : path"
    )
      img(:src="imgSrc(path)" :alt="path")

</template>

<script>
  export default {
    computed: {
      currentRoute() {
        return this.$store.getters.currentRoute
      }
    },

    methods: {
      imgSrc(path) {
        return `/assets/classes/${path}.png`
      },
    },
  }
</script>

<style lang="stylus" scoped>
  .class-image-selector
    width 750px
    display flex
    flex-wrap wrap
    justify-content space-between
    align-items center
    margin-bottom 10px

  a
    display block
    width 77px
    height 77px
    opacity 0.3
    transition opacity 0.2s ease-in-out

    &.active
      opacity 1

  img
    width 100%
    height 100%
    display block
    border-radius 2px
    margin-left 0

</style>
