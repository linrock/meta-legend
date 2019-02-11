<template lang="pug">
  .selector
    .selected(@click="chooseP1Class")
      | {{ classes[$store.getters.p1Class] }}
    .selector-dropdown(
      v-if="$store.getters.currentDropdown === 'p1_class'"
    )
      .option(
        v-for="[value, label] in Object.entries(classes)"
        @click="selectP1Class(value)"
      ) {{ label }}

</template>

<script lang="ts">
  const classes = {
    'all':     'Any class',
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
        classes
      }
    },

    methods: {
      chooseP1Class() {
        this.$store.dispatch(`toggleDropdown`, `p1_class`)
      },
      selectP1Class(p1Class) {
        this.$store.dispatch(`selectP1Class`, p1Class)
      }
    }
  }
</script>
