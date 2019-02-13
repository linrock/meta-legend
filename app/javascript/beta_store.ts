import Vue from 'vue'
import Vuex from 'vuex'

import Replays from './models/replays'
import api from './api'
import { paramsToString } from './utils'

Vue.use(Vuex)

const store = new Vuex.Store({
  state: {
    replays: new Replays(),  // all replays in the current list
    currentReplay: null,     // if a replay was clicked
    currentDropdown: null,   // homepage select dropdowns
    gameType: `all`,         // all, standard, wild
    rankRange: `rank-5`,     // rank-5, legend, top-1000, top-500, top-100
    p1Class: `all`,
    p2Class: `all`,
    isFetching: false,
    page: 1,
  },

  mutations: {
    setReplays(state, replays) {
      state.replays = new Replays()
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
    },
    selectRankRange(state, rankRange) {
      state.rankRange = rankRange
    },
    selectP1Class(state, p1Class) {
      state.p1Class = p1Class
    },
    selectP2Class(state, p2Class) {
      state.p2Class = p2Class
    },
    setIsFetching(state, isFetching) {
      state.isFetching = isFetching
    }
  },

  actions: {
    setReplays({ commit }, replays) {
      commit(`setReplays`, replays)
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
    fetchReplays({ commit, dispatch }, apiPath) {
      commit(`setIsFetching`, true)
      api.get(apiPath)
        .then(response => response.data)
        .then(jsonData => dispatch(`setReplays`, jsonData.replays))
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
      const queryParams = {
        game_type: state.gameType,
        rank_range: state.rankRange,
        p1_class: state.p1Class,
        p2_class: state.p2Class,
      }
      return `/search.json?${paramsToString(queryParams)}`
    },
  },
})

store.watch(() => store.getters.apiPath, apiPath => {
  console.log(`api path changed - ${apiPath}`)
  store.dispatch(`fetchReplays`, apiPath)
})

export default store
