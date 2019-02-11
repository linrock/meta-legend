import Vue from 'vue'
import FastClick from 'fastclick'

import Search from '../components/beta/search'
import FixedSidebar from '../components/beta/fixed_sidebar'
import store from '../beta_store'

document.addEventListener(`DOMContentLoaded`, () => {
  const replayDataEl: HTMLElement = document.querySelector(`.replay-data`)
  const replays = JSON.parse(replayDataEl.innerHTML)
  store.dispatch(`setReplays`, replays)

  new Vue({
    el: document.querySelector(`.search`),
    render: h => h(Search),
    store,
  })

  new Vue({
    el: document.querySelector(`.fixed-sidebar`),
    render: h => h(FixedSidebar),
    store,
  })

  if (`addEventListener` in document) {
    FastClick.attach(document.body)
  }
})
