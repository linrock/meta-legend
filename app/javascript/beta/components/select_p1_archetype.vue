<template lang="pug">
  .selector
    .selected(@click="chooseP1Archetype")
      | Any
    .selector-dropdown(
      v-if="$store.getters.currentDropdown === DropdownType.P1Archetype"
    )
      .option(
        v-for="[value, label] in Object.entries(archetypes)"
        @click="selectP1Archetype(value)"
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
      chooseP1Archetype() {
        this.$store.dispatch(`toggleDropdown`, DropdownType.P1Archetype)
      },
      selectP1Archetype(p1Class) {
        this.$store.dispatch(`selectP1Archetype`, p1Class)
      }
    }
  }
</script>
