/* eslint no-console: 0 */

import Vue from 'vue'
import VueRouter from 'vue-router'
import FastClick from 'fastclick'

import App from '../app'
import store from '../store'

Vue.use(VueRouter)

const mountBasePath = pathname => {
  const match = pathname.match(/^\/([^/]+)\//)
  return match ? match[0] : `/`
}

const router = new VueRouter({
  mode: 'history',
  base: mountBasePath(window.location.pathname),
  routes: [
    {
      path: '/:path',
      component: App,
    }
  ]
})

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: document.querySelector(".app-container").appendChild(document.createElement('main')),
    render: h => h(App),
    router,
    store,
  })

  if ('addEventListener' in document) {
    FastClick.attach(document.body)
  }
})
