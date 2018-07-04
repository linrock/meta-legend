<template lang="pug">
  .submit-replays
    h2 Share your replays!
    a.hsreplay-link(
      href="https://hsreplay.net/account/api/hooks/new/"
      target="_blank"
    )
      | Set up a webhook on hsreplay.net
    span with this Payload URL:
    .url https://metalegend.com/webhook

</template>

<script lang="ts">
  export default {}
</script>

<style lang="stylus" scoped>
  .submit-replays
    margin-bottom 40px

  h2
    font-weight bold
    text-align center
    margin-bottom 10px

  .submit-replays
    text-align center
    margin-bottom 45px
    background rgba(0,0,0,0.03)
    border-radius 3px
    padding 20px 0 25px

  .hsreplay-link
    color #45abfe
    text-decoration none
    margin 0 6px 0 2px

    &:hover 
      text-decoration underline

  .url
    font-weight bold
    font-size 18px
    margin-top 20px
    opacity 0.8

</style>
