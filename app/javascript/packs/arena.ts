import Vue from 'vue'
import VueRouter from 'vue-router'
import FastClick from 'fastclick'

import Arena from '../layouts/arena'
import store from '../store'

Vue.use(VueRouter)

document.addEventListener('DOMContentLoaded', () => {
  const appContainerEl = document.querySelector(`.app-container`)
  new Vue({
    el: appContainerEl.appendChild(document.createElement(`main`)),
    render: h => h(Arena),
    store,
  })

  if ('addEventListener' in document) {
    FastClick.attach(document.body)
  }
})
