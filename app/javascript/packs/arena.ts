import Vue from 'vue'
import FastClick from 'fastclick'

import Wild from '../wild.vue'
import store from '../store'

document.addEventListener('DOMContentLoaded', () => {
  const appContainerEl = document.querySelector(`.app-container`)
  new Vue({
    el: appContainerEl.appendChild(document.createElement(`main`)),
    render: h => h(Wild),
    store,
  })

  if ('addEventListener' in document) {
    FastClick.attach(document.body)
  }
})
