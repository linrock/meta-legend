import Vue from 'vue'
import FastClick from 'fastclick'

import Card from '../card'
import store from '../store'

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: document.querySelector(".card-replays-list"),
    render: h => h(Card),
    store,
  })

  if ('addEventListener' in document) {
    FastClick.attach(document.body)
  }
})
