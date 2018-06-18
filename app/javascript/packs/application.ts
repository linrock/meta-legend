/* eslint no-console: 0 */

import Vue from 'vue'
import VueRouter from 'vue-router'
import FastClick from 'fastclick'

import App from '../app.vue'
import store from '../store'

Vue.use(VueRouter)

const router = new VueRouter({
  mode: 'history',
  routes: [
    {
      path: '/:path',
      component: App,
    },
    {
      path: '/:filter/:path',
      component: App,
    },
    {
      path: '/:filter/:filter2/:path',
      component: App,
    },
  ]
})

document.addEventListener('DOMContentLoaded', () => {
  const appContainerEl = document.querySelector(".app-container")
  new Vue({
    el: appContainerEl.appendChild(document.createElement('main')),
    render: h => h(App),
    router,
    store,
  })

  if ('addEventListener' in document) {
    FastClick.attach(document.body)
  }
})
