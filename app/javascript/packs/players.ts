import Vue from 'vue'
import FastClick from 'fastclick'

import Player from '../player'
import store from '../store'

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: document.querySelector(".card-replays-list"),
    render: h => h(Player),
    store,
  })

  if ('addEventListener' in document) {
    FastClick.attach(document.body)
  }
})
