import Vue from 'vue'
import Vuex from 'vuex'

import Replays from './models/replays'

Vue.use(Vuex)

const store = new Vuex.Store({
  state: {
    replays: new Replays(),
    currentReplay: null,
  },

  mutations: {
    setReplays(state, replays) {
      state.replays = new Replays()
      state.replays.addReplays(replays)
    },
    selectReplay(state, replay) {
      state.currentReplay = replay
    }
  },

  actions: {
    setReplays({ commit }, replays) {
      commit(`setReplays`, replays)
    },
    selectReplay({ commit }, replay) {
      commit(`selectReplay`, replay)
    }
  },

  getters: {
    replays: state => state.replays.replayList,
    currentReplay: state => state.currentReplay
  },
})

export default store
