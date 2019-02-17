<template lang="pug">
  .search-filters(v-if="!playerName")
    .selector-group
      .label Show me
      select-game-type
    .selector-group
      .label Played at
      select-rank-range
    template(v-if="!cardId && !cardName")
      .selector-group
        .label Piloted by
        .select-class-and-archetype
          select-p1-archetype
          select-p1-class
      .selector-group
        .label Against
        .select-class-and-archetype
          select-p2-archetype
          select-p2-class
    .selector-group
      .label For at least
      .value 8 turns
    .selector-group(v-if="cardId && cardName")
      .label With the card
      .value {{ cardName }}

</template>

<script lang="ts">
  import SelectGameType from './select_game_type'
  import SelectRankRange from './select_rank_range'
  import SelectP1Archetype from './select_p1_archetype'
  import SelectP1Class from './select_p1_class'
  import SelectP2Archetype from './select_p2_archetype'
  import SelectP2Class from './select_p2_class'

  export default {
    props: {
      cardId: {
        type: String,
      },
      cardName: {
        type: String,
      },
      playerName: {
        type: String,
      }
    },

    components: {
      SelectGameType,
      SelectRankRange,
      SelectP1Archetype,
      SelectP1Class,
      SelectP2Archetype,
      SelectP2Class,
    }
  }
</script>

<style lang="stylus">
  .search-filters
    min-height 128px

  .search-stats
    border-bottom 1px solid rgba(0,0,0,0.15)

  .selector-group
    position relative

    .select-class-and-archetype
      display flex

      .selector:first-child
        margin-right 30px

    .selector
      .selected
        user-select none

        &:hover
          color #45abfe
          cursor pointer

      .selector-dropdown
        position absolute
        background white
        border-radius 2px
        box-shadow 0 1px 10px rgba(0,0,0,0.15)
        font-weight normal
        min-width 160px
        left 140px
        top 30px
        z-index 10
        padding 10px

        .select-dropdown-container
          position relative

          &:before
            content ""
            position absolute
            width 20px
            height 20px
            top -28px
            border 10px solid transparent
            border-bottom 10px solid white
            background none

        .option
          user-select none
          font-weight normal
          padding 5px 0

          &:hover
            color #45abfe
            cursor pointer

</style>
