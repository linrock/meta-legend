<template lang="pug">
  .selector
    .selected(@click="chooseGameType")
      | {{ gameTypes[$store.getters.gameType] }}
    .selector-dropdown(
      v-if="$store.getters.currentDropdown === 'game_type'"
    )
      .select-dropdown-container
        .option(
          v-for="[value, label] in Object.entries(gameTypes)"
          @click="selectGameType(value)"
        ) {{ label }}

</template>

<script lang="ts">
  const gameTypes = {
    'all':      'Standard and wild games',
    'standard': 'Standard games',
    'wild':     'Wild games',
  }

  export default {
    data() {
      return {
        gameTypes
      }
    },

    methods: {
      chooseGameType() {
        this.$store.dispatch(`toggleDropdown`, `game_type`)
      },
      selectGameType(gameType) {
        this.$store.dispatch(`selectGameType`, gameType)
      }
    }
  }
</script>
