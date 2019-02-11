import Vue from 'vue'
import Vuex from 'vuex'

import Replays from './models/replays'

Vue.use(Vuex)

const store = new Vuex.Store({
  state: {
    replays: new Replays(),   // all replays in the current list
    currentReplay: null,      // if a replay was clicked
    currentDropdown: null,    // homepage select dropdowns
    gameType: `all`,          // all, standard, wild
    rankRange: `rank5`,       // rank5, legend, top-1000, top-500, top-100
  },

  mutations: {
    setReplays(state, replays) {
      state.replays = new Replays()
      state.replays.addReplays(replays)
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
  },

  getters: {
    replays: state => state.replays.replayList,
    currentReplay: state => state.currentReplay,
    currentDropdown: state => state.currentDropdown,
    gameType: state => state.gameType,
    rankRange: state => state.rankRange,
  },
})

export default store
