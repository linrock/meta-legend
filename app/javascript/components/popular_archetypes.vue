<template lang="pug">
  .archetype-stats-container
    transition(name="fade")
      .popular-archetypes(v-if="archetypeStats && !currentRoute.class")
        h2 {{ title }}
        .label-row
          .class-label deck type
          .winrate-label # games
        .archetype-stats
          router-link.stats-row(
            v-for="archetype in archetypeStats.frequencies"
            :key="archetype.path"
            :to="archetype.path"
          )
            .name {{ archetype.name }}
            .n-games {{ archetype.n_games }}
        h3
          | From {{ archetypeStats.n }} games
          template(v-if="sinceDays > 0")
            | &nbsp;in the past {{ sinceDays }} days

</template>

<script>
  import axios from 'axios'

  const titleSuffix = `Frequent decks`

  export default {
    data() {
      return {
        archetypeStats: null,
        title: titleSuffix,
        sinceDays: 0,
      }
    },

    created() {
      this.fetchPopularArchetypes()
    },

    methods: {
      fetchPopularArchetypes() {
        axios.get(this.apiQuery)
          .then(response => response.data)
          .then(data => {
            this.archetypeStats = data
            if (data.filter === `top1000`) {
              this.title = `Top 1000 - ${titleSuffix}`
            } else if (data.filter === `top100`) {
              this.title = `Top 100 - ${titleSuffix}`
            } else {
              this.title = titleSuffix
            }
            const since = new Date(data.since).getTime()
            const secondsSince = ((new Date()).getTime() - since) / 1000
            const sinceDays = Math.round(secondsSince / 86400)
            this.sinceDays = sinceDays
          })
      },
    },

    computed: {
      currentRoute() {
        return this.$store.getters.currentRoute
      },
      filter() {
        return this.$store.state.filter
      },
      apiQuery() {
        let path = `popular.json`
        if (this.filter) {
          path = `${path}?filter=${this.filter}`
        }
        return path
      },
    },

    watch: {
      apiQuery() {
        this.fetchPopularArchetypes()
      }
    }
  }
</script>

<style lang="stylus" scoped>
  h2
    font-weight bold
    padding-bottom 10px
    border-bottom 1px solid rgba(0,0,0,0.05)
    margin-bottom 10px

  h3
    font-size 12px
    margin-top 20px
    opacity 0.4

  .label-row
    font-size 10px
    letter-spacing 0.4px
    text-transform uppercase
    display flex
    opacity 0.5
    margin-bottom 8px

    .class-label
      text-align left

    .winrate-label
      text-align right
      margin-left auto

  .stats-row
    display flex
    line-height 24px
    padding 2px 0
    border-radius 2px
    text-decoration none
    color #333

    &:hover, &.active
      color #45ABFE
      cursor pointer

    .name
      font-weight bold

    .n-games
      width 60px
      font-weight normal
      margin-left auto
      text-align right

  a
    display block
    color inherit
    font-weight bold
    text-decoration none

    &:hover
      color #45ABFE

  .fade-enter-active, .fade-leave-active
    transition all 0.05s
    opacity 1

  .fade-enter, .fade-leave-to
    opacity 0

</style>
