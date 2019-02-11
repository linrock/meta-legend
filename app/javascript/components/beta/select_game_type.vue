<template lang="pug">
  .selector-dropdown.select-game-type
    .option(
      v-for="[value, label] in gameTypes"
      @click="selectGameType(value)"
    ) {{ label }}

</template>

<script lang="ts">
  const gameTypes = [
    ['all', 'All ranked games'],
    ['standard', 'Standard games'],
    ['wild', 'Wild games'],
  ]

  export default {
    data() {
      return {
        gameTypes
      }
    },

    methods: {
      selectGameType(gameType) {
        this.$store.dispatch(`selectGameType`, gameType)
      }
    }
  }
</script>
