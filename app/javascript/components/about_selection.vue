<template lang="pug">
  .about-selection
    h2 {{ currentRouteType }}
</template>

<script>
  export default {
    computed: {
      currentRoute() {
        return this.$store.getters.currentRoute
      },
      currentRouteType() {
        if (this.currentRoute.class) {
          if (this.currentRoute.archetype) {
            return `${this.currentRoute.archetype} ${this.currentRoute.class}`
          } else {
            return this.currentRoute.class
          }
        }
      }
    }
  }
</script>
