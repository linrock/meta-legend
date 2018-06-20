<template lang="pug">
  .submit-replays
    h2 Share your replays! One hsreplay id or url per line
    form(
      action="/replays.json"
      type="post"
      @submit.prevent="submitReplays"
    )
      textarea(
        ref="submit"
        name="replays"
        placeholder="ex. https://hsreplay.net/replay/zwaG2JCQLBogUdminRUuQQ"
      )
      .submit-row
        input(type="submit" value="Submit replays")
        .thanks(v-if="thanks") Thanks, keep it up!
      .under-submit
        .webhook-prompt
          span Or
          a.hsreplay-link(
            href="https://hsreplay.net/account/api/hooks/new/"
            target="_blank"
          )
            | set up a webhook on hsreplay.net
          span with this Payload URL:
        .url https://metalegend.com/webhook

</template>

<script lang="ts">
  import axios from 'axios'
  import { trackEvent } from '../utils'

  export default {
    data() {
      return {
        thanks: false
      }
    },

    methods: {
      submitReplays() {
        trackEvent('submit replay', 'submitted', null)
        const replays = this.$refs.submit.value.trim()
        if (replays === "") {
          return
        }
        axios.post('/replays.json', { replays })
          .then(response => response.data)
          .then(data => {
            if (data.success) {
              this.thanks = true 
              this.$refs.submit.value = ''
            }
          })
          .catch(error => {
            console.error(error)
          })
      }
    }
  }
</script>

<style lang="stylus" scoped>
  .submit-replays
    margin-bottom 20px

  h2
    font-weight bold
    text-align center
    margin-bottom 10px

  textarea
    background white
    border 1px solid rgba(0,0,0,0.2)
    border-radius 3px
    font-size 16px
    padding 10px
    width 100%
    height 100px
    margin-bottom 3px

  input[type="submit"]
    border 0
    border-radius 3px
    color white
    font-size 16px
    padding 7px 19px
    background #45abfe

    &:hover
      cursor pointer
      opacity 0.7

  .submit-row
    display flex
    align-items center

    .thanks
      margin-left 20px

  .under-submit
    margin 20px 0

    .webhook-prompt
      margin 10px 0

    .hsreplay-link
      margin 0 6px 0 2px

    .url
      font-weight bold

</style>
