<template lang="pug">
  .replay-comment
    .prompt Tell us about the replay!
    form(
      action="/replay_comments.json"
      type="post"
      @submit.prevent="submitComment"
    )
      input(type="hidden" :value="replay.hsreplayId")
      textarea(ref="comment")
      input(
        type="submit"
        value="Save comment"
      )

</template>

<script>
  import axios from 'axios'
  import Replay from '../models/replay'
  import { trackEvent } from '../utils'

  export default {
    props: {
      replay: {
        type: Replay,
        required: true,
      },
      callback: {
        type: Function,
        required: true,
      }
    },

    methods: {
      submitComment() {
        trackEvent('comment box', 'submitted', this.replay.hsreplayId)
        const data = {
          comment: {
            hsreplay_id: this.replay.hsreplayId,
            text: this.$refs.comment.value,
          }
        }
        axios.post('/replay_comments.json', data)
          .then(response => response.data)
          .then(data => {
            console.dir(data)
            this.callback()
          })
          .catch(error => {
            console.error(error)
          })
      }
    }
  }
</script>

<style lang="stylus" scoped>
  .prompt
    font-size 15px
    font-weight bold
    margin-top 50px

  textarea
    border 1px solid rgba(0,0,0,0.5)
    border-radius 2px
    width 100%
    height 110px
    margin 10px 0
    font-size 14px
    padding 10px

  input[type="submit"]
    border 0
    border-radius 4px
    background #45abfe
    color white
    font-size 18px
    padding 6px 12px

    &:hover
      cursor pointer

</style>
