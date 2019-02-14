<template lang="pug">
  .infinite-scroll(ref="bottom")
    .no-more(v-if="!enabled") No more games!

</template>

<script lang="ts">
  const triggerDist = 500
  const pollInterval = 300

  export default {
    created() {
      setInterval(() => {
        const d = this.distanceFromBottom()
        if (d < triggerDist && !this.$store.state.isFetching && this.enabled) {
          this.$store.dispatch(`fetchNextPage`)
        }
      }, pollInterval)
    },

    computed: {
      enabled() {
        return this.$store.state.infScrollEnabled && this.$store.state.page < 20
      }
    },

    methods: {
      distanceFromBottom() {
        if (!this.$refs.bottom) {
          return Infinity
        } else {
          return this.$refs.bottom.offsetTop - (window.scrollY + window.innerHeight)
        }
      }
    }
  }
</script>

<style lang="stylus">
  .infinite-scroll
    min-height 120px

    .no-more
      text-align center
      line-height 120px

</style>
