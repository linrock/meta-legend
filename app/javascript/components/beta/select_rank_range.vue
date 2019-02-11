<template lang="pug">
  .selector-dropdown
    .option(
      v-for="[value, label] in rankRanges"
      @click="selectRankRange(value)"
    ) {{ label }}

</template>

<script lang="ts">
  const rankRanges = [
    ['rank5', 'Rank 5 and above'],
    ['legend', 'All legend'],
    ['top-1000', 'Top 1000 legend'],
    ['top-500', 'Top 500 legend'],
    ['top-100', 'Top 100 legend'],
  ]

  export default {
    data() {
      return {
        rankRanges
      }
    },

    methods: {
      selectRankRange(rankRange) {
        this.$store.dispatch(`selectRankRange`, rankRange)
      }
    }
  }
</script>
