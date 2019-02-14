import Vue from 'vue'
import FastClick from 'fastclick'

import Search from '../beta/components/search'
import FixedSidebar from '../beta/components/fixed_sidebar'
import store from '../beta/store'

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
