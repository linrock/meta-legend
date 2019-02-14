import Vue from 'vue'
import Vuex from 'vuex'

import Replays from './models/replays'
import api from '../api'
import { paramsToString } from '../utils'

Vue.use(Vuex)

const store = new Vuex.Store({
  state: {
    replays: new Replays(),  // all replays in the current list

    currentReplay: null,     // if a replay was clicked
    currentDropdown: null,   // homepage select dropdowns

    // controls for api and infinite scroll
    isReady: true,           // set to true to start making requests
    infScrollEnabled: true,
    isFetching: false,

    // params for api requests
    cardId: null,
    gameType: `all`,         // all, standard, wild
    rankRange: `rank-5`,     // rank-5, legend, top-1000, top-500, top-100
    p1Class: `all`,
    p2Class: `all`,
    page: 1,
  },

  mutations: {
    setReplays(state, replays) {
      state.replays = new Replays()
      state.replays.addReplays(replays)
      state.isFetching = false
    },
    addReplays(state, replays) {
      state.replays.addReplays(replays)
      state.isFetching = false
    },
    selectReplay(state, replay) {
      state.currentReplay = replay
    },
    toggleDropdown(state, dropdownType) {
      state.currentDropdown = dropdownType
    },
    selectGameType(state, gameType) {
      state.gameType = gameType
      state.page = 1
    },
    selectRankRange(state, rankRange) {
      state.rankRange = rankRange
      state.page = 1
    },
    selectP1Class(state, p1Class) {
      state.p1Class = p1Class
      state.page = 1
    },
    selectP2Class(state, p2Class) {
      state.p2Class = p2Class
      state.page = 1
    },
    setIsFetching(state, isFetching) {
      state.isFetching = isFetching
    },
    nextPage(state) {
      state.page = state.page + 1
    },
    setInitialProps(state, props) {
      state.isReady = false
      if (props.cardId) {
        state.cardId = props.cardId
      }
    },
    setInfScrollEnabled(state, enabled) {
      state.infScrollEnabled = enabled
    },
    apiIsReady(state) {
      state.isReady = true
    }
  },

  actions: {
    setReplays({ commit }, replays) {
      commit(`setReplays`, replays)
    },
    addReplays({ commit }, replays) {
      commit(`addReplays`, replays)
    },
    selectReplay({ commit }, replay) {
      commit(`selectReplay`, replay)
    },
    toggleDropdown({ commit, getters }, dropdownType) {
      if (dropdownType === getters.currentDropdown) {
        commit(`toggleDropdown`, null)
      } else {
        commit(`toggleDropdown`, dropdownType)
      }
    },
    selectGameType({ commit }, gameType) {
      commit(`toggleDropdown`, null)
      commit(`selectGameType`, gameType)
    },
    selectRankRange({ commit }, rankRange) {
      commit(`toggleDropdown`, null)
      commit(`selectRankRange`, rankRange)
    },
    selectP1Class({ commit }, p1Class) {
      commit(`toggleDropdown`, null)
      commit(`selectP1Class`, p1Class)
    },
    selectP2Class({ commit }, p2Class) {
      commit(`toggleDropdown`, null)
      commit(`selectP2Class`, p2Class)
    },
    fetchReplays({ commit }, apiPath) {
      api.get(apiPath)
        .then(response => response.data)
        .then(({ page, replays }) => {
          if (page === 1) {
            commit(`setReplays`, replays)
          } else {
            commit(`addReplays`, replays)
          }
          commit(`setInfScrollEnabled`, replays.length > 0)
          commit(`setIsFetching`, false)
        })
    },
    fetchNextPage({ commit, state }, apiPath) {
      if (state.isFetching) {
        return
      }
      commit(`setIsFetching`, true)
      commit(`nextPage`)
    },
    setInitialProps({ commit }, props) {
      commit(`setInitialProps`, props)
    }
  },

  getters: {
    replays: state => state.replays.replayList,
    currentReplay: state => state.currentReplay,
    currentDropdown: state => state.currentDropdown,
    gameType: state => state.gameType,
    rankRange: state => state.rankRange,
    p1Class: state => state.p1Class,
    p2Class: state => state.p2Class,
    apiPath: state => {
      const queryParams: any = {
        game_type: state.gameType,
        rank_range: state.rankRange,
        p1_class: state.p1Class,
        p2_class: state.p2Class,
        page: state.page,
      }
      if (state.cardId) {
        queryParams.card_id = state.cardId
      }
      return `/search.json?${paramsToString(queryParams)}`
    },
  },
})

store.watch(() => store.getters.apiPath, apiPath => {
  if (!store.state.isReady) {
    console.log(`ignoring: ${apiPath}`)
    store.commit(`apiIsReady`)
  } else {
    console.log(`fetching: ${apiPath}`)
    store.dispatch(`fetchReplays`, apiPath)
  }
})

export default store
