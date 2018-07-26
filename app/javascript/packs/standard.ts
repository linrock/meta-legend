/* eslint no-console: 0 */

import Vue from 'vue'
import VueRouter from 'vue-router'
import FastClick from 'fastclick'

import Standard from '../layouts/standard'
import store from '../store'

Vue.use(VueRouter)

const router = new VueRouter({
  mode: 'history',
  routes: [
    {
      path: '/:filter/:filter2/:path',
      component: Standard,
    },
    {
      path: '/:filter/:path',
      component: Standard,
    },
    {
      path: '/:path',
      component: Standard,
    },
  ]
})

document.addEventListener('DOMContentLoaded', () => {
  const appContainerEl = document.querySelector(".app-container")
  new Vue({
    el: appContainerEl.appendChild(document.createElement('main')),
    render: h => h(Standard),
    router,
    store,
  })

  if ('addEventListener' in document) {
    FastClick.attach(document.body)
  }
})
