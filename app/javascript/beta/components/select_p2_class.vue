<template lang="pug">
  .selector
    .selected(@click="chooseP2Class")
      | {{ classes[$store.getters.p2Class] }}
    .selector-dropdown(
      v-if="$store.getters.currentDropdown === DropdownType.P2Class"
    )
      .option(
        v-for="[value, label] in Object.entries(classes)"
        @click="selectP2Class(value)"
      ) {{ label }}

</template>

<script lang="ts">
  import { DropdownType } from '../enums'

  const classes = {
    'all':     'Class',
    'Druid':   'Druid',
    'Hunter':  'Hunter',
    'Mage':    'Mage',
    'Paladin': 'Paladin',
    'Priest':  'Priest',
    'Rogue':   'Rogue',
    'Shaman':  'Shaman',
    'Warlock': 'Warlock',
    'Warrior': 'Warrior',
  }

  export default {
    data() {
      return {
        classes,
        DropdownType,
      }
    },

    methods: {
      chooseP2Class() {
        this.$store.dispatch(`toggleDropdown`, DropdownType.P2Class)
      },
      selectP2Class(p2Class) {
        this.$store.dispatch(`selectP2Class`, p2Class)
      }
    }
  }
</script>
