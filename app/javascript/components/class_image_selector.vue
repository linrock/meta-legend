<template lang="pug">
  .class-image-selector
    router-link(
      v-for="([path, route]) in classArray"
      :class="[{ active: !currentRoute.class || currentRoute.class === route.class }]"
      :key="path"
      :to="imgPath(path)"
    )
      img(:src="imgSrc(path)" :alt="path")

</template>

<script lang="ts">
  import Route from '../models/route'

  const defaultClassArray = [
    `Druid`,
    `Hunter`,
    `Mage`,
    `Paladin`,
    `Priest`,
    `Rogue`,
    `Shaman`,
    `Warlock`,
    `Warrior`,
  ].map(c => ([ c.toLowerCase(), c ]))

  export default {
    computed: {
      currentRoute(): Route {
        return this.$store.getters.currentRoute
      },
      classArray(): Array<any> {
        const classArray = this.$store.getters.classArray
        return classArray.length > 0 ? classArray : defaultClassArray
      }
    },

    methods: {
      imgSrc(path): string {
        return `/assets/classes/${path}.png`
      },
      imgPath(path): string {
        let pathPrefix = this.$store.getters.filterPath
        let imgPath
        if (pathPrefix !== `/`) {
          imgPath = `${pathPrefix}/${this.$store.state.path === path ? `` : path}`
        } else {
          imgPath = `${this.$store.state.path === path ? `` : path}`
        }
        if (imgPath === this.$store.state.path) {
          imgPath = ``
        }
        if (imgPath[0] !== `/`) {
          imgPath = `/${imgPath}`
        }
        return imgPath
      }
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
