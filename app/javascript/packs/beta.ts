import Vue from 'vue'
import FastClick from 'fastclick'

import SearchFilters from '../beta/components/search_filters'
import SearchResults from '../beta/components/search_results'
import FixedSidebar from '../beta/components/fixed_sidebar'
import store from '../beta/store'

document.addEventListener(`DOMContentLoaded`, () => {
  const searchFiltersEl: HTMLElement = document.querySelector(`.search-filters`)
  if (searchFiltersEl) {
    if (Object.entries(searchFiltersEl.dataset).length > 0) {
      store.dispatch(`setInitialProps`, searchFiltersEl.dataset)
    }
    new Vue({
      el: searchFiltersEl,
      render: h => h(SearchFilters, {
        props: searchFiltersEl.dataset
      }),
      store,
    })
  }

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

  const fixedSidebarEl = document.querySelector(`.fixed-sidebar`)
  if (fixedSidebarEl) {
    const props: any = {}
    const content = fixedSidebarEl.innerHTML.trim()
    if (content.length > 0) {
      props.content = content
    }
    console.dir(props)
    new Vue({
      el: fixedSidebarEl,
      render: h => h(FixedSidebar, { props }),
      store,
    })
  }

  if (`addEventListener` in document) {
    FastClick.attach(document.body)
  }
})
