<template lang="pug">
  .selector
    .selected(@click="chooseP2Archetype")
      | Any
    .selector-dropdown(
      v-if="$store.getters.currentDropdown === DropdownType.P2Archetype"
    )
      .option(
        v-for="[value, label] in Object.entries(archetypes)"
        @click="selectP2Archetype(value)"
      ) {{ label }}

</template>

<script lang="ts">
  import { DropdownType } from '../enums'

  export default {
    data() {
      return {
        archetypes: { 'any': `Any` },
        DropdownType,
      }
    },

    methods: {
      chooseP2Archetype() {
        this.$store.dispatch(`toggleDropdown`, DropdownType.P2Archetype)
      },
      selectP2Archetype(p1Class) {
        this.$store.dispatch(`selectP2Archetype`, p1Class)
      }
    }
  }
</script>
