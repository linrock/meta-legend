<template lang="pug">
  .infinite-scroll(ref="bottom")

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
        return this.$store.getters.replays.length > 0 && this.$store.state.page < 20
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
