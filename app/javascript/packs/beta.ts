import Vue from 'vue'
import FastClick from 'fastclick'

import SearchFilters from '../beta/components/search_filters'
import SearchResults from '../beta/components/search_results'
import FixedSidebar from '../beta/components/fixed_sidebar'
import store from '../beta/store'

document.addEventListener(`DOMContentLoaded`, () => {
  new Vue({
    el: document.querySelector(`.search-filters`),
    render: h => h(SearchFilters),
    store,
  })

  const searchResultsEl = document.querySelector(`.search-results`)
  if (searchResultsEl) {
    const replayDataEl: HTMLElement = document.querySelector(`.replay-data`)
    const replays = JSON.parse(replayDataEl.innerHTML)
    store.dispatch(`setReplays`, replays)
    new Vue({
      el: searchResultsEl,
      render: h => h(SearchResults),
      store,
    })
  }

  new Vue({
    el: document.querySelector(`.fixed-sidebar`),
    render: h => h(FixedSidebar),
    store,
  })

  if (`addEventListener` in document) {
    FastClick.attach(document.body)
  }
})
