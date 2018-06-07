<template lang="pug">
  .about-selection
    h2 {{ title }}

</template>

<script>
  export default {
    computed: {
      currentRoute() {
        return this.$store.getters.currentRoute
      },
      title() {
        if (this.currentRoute) {
          return `Top ${this.currentRoute.class} decks`
        }
      }
    }
  }
</script>

<style lang="stylus" scoped>
  h2
    font-weight bold
    padding-bottom 5px
    border-bottom 1px solid rgba(0,0,0,0.3)

</style>
