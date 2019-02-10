import Vue from 'vue'
import FastClick from 'fastclick'

import Replay from '../models/replay'
import Search from '../components/beta/search'
import store from '../beta_store'

document.addEventListener(`DOMContentLoaded`, () => {
  const replayDataEl: HTMLElement = document.querySelector(`.replay-data`)
  store.replays = JSON.parse(replayDataEl.innerHTML).map(replayData => {
    return new Replay(replayData)
  })
  const searchEl = document.querySelector(`.search`)
  new Vue({
    el: searchEl,
    render: h => h(Search),
  })

  if (`addEventListener` in document) {
    FastClick.attach(document.body)
  }
})
