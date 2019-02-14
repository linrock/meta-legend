<template lang="pug">
  .selector
    .selected(@click="chooseRankRange")
      | {{ rankRanges[$store.getters.rankRange] }}
    .selector-dropdown(
      v-if="$store.getters.currentDropdown === 'rank_range'"
    )
      .option(
        v-for="[value, label] in Object.entries(rankRanges)"
        @click="selectRankRange(value)"
      ) {{ label }}

</template>

<script lang="ts">
  const rankRanges = {
    'rank-5':   'Rank 5 and above',
    'legend':   'All legend',
    'top-1000': 'Top 1000 legend',
    'top-500':  'Top 500 legend',
    'top-100':  'Top 100 legend',
  }

  export default {
    data() {
      return {
        rankRanges
      }
    },

    methods: {
      chooseRankRange() {
        this.$store.dispatch(`toggleDropdown`, `rank_range`)
      },
      selectRankRange(rankRange) {
        this.$store.dispatch(`selectRankRange`, rankRange)
      }
    }
  }
</script>
