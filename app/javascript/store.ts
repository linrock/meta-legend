import Vue from 'vue'
import Vuex from 'vuex'

import LikedReplays from './models/liked_replays'
import Replays from './models/replays'
import RouteMap from './models/route_map'
import AboutWinrates from './models/about_winrates'

Vue.use(Vuex)

const store = new Vuex.Store({
  state: {
    path: `/`,       // class path    = rogue, paladin, etc.
    rank: `all`,     // rank filter   = all, top-100, top-1000
    region: `all`,   // region filter = all, us, eu, sea
    page: 1,
    currentCard: null,
    aboutWinrates: new AboutWinrates({}),
    routeMap: new RouteMap({}),
    replays: new Replays(),
    replayFeedTitle: ``,
    replay: null,
    likedReplays: new LikedReplays(),
    activePlayers: [],
  },

  mutations: {
    setAboutWinrates(state, aboutWinrates) {
      state.aboutWinrates = aboutWinrates
    },
    setRouteMap(state, routeMap) {
      state.routeMap = routeMap
    },
    setPath(state, path) {
      state.path = path
    },
    setRankFilter(state, rankFilter) {
      state.rank = rankFilter
    },
    setRegionOption(state, regionFilter) {
      state.region = regionFilter
    },
    setReplays(state, replays) {
      state.replays = new Replays()
      state.replays.addReplays(replays)
    },
    addReplays(state, replays) {
      state.replays.addReplays(replays)
    },
    setReplayFeedTitle(state, replayFeedTitle) {
      state.replayFeedTitle = replayFeedTitle
    },
    setPage(state, page) {
      state.page = page
    },
    selectReplay(state, replay) {
      state.replay = replay
    },
    setActivePlayers(state, players) {
      state.activePlayers = players
    },
    setReplayLikes(state, { replayId, numLikes, liked }) {
      Vue.set(state.likedReplays.likeMap, replayId, { numLikes, liked })
    },
    setCurrentCard(state, cardId) {
      state.currentCard = cardId
    }
  },

  actions: {
    setInitialData({ commit }, initialData) {
      commit(`setRouteMap`, new RouteMap(initialData.routes))
      commit(`setAboutWinrates`, new AboutWinrates(initialData.about))
      if (initialData.players) {
        commit(`setActivePlayers`, initialData.players)
      }
    },
    setPath({ commit, dispatch, getters }, path) {
      const route = getters.routeMap(path)
      if (getters.currentReplay) {
        commit(`selectReplay`, null)
      }
      commit(`setPath`, path || `/`)
    },
    setRankFilter({ commit }, rankFilter) {
      commit(`setRankFilter`, rankFilter)
    },
    setRegionOption({ commit }, regionFilter) {
      commit(`setRegionOption`, regionFilter)
    },
    setReplays({ commit, getters, state }, replays) {
      commit(`setReplays`, replays)
    },
    setReplayFeedTitle({ commit, state }, route) {
      let replayFeedTitle
      if (!route.archetype) {
        replayFeedTitle = !route.class ? `Recent replays` : route.class
      } else {
        replayFeedTitle = `${route.archetype} ${route.class}`
      }
      if (state.region !== `all`) {
        const r = state.region
        replayFeedTitle = `${r[0].toUpperCase()}${r.slice(1)} - ${replayFeedTitle}`
      }
      if (state.rank === `top-100`) {
        replayFeedTitle = `Top 100 - ${replayFeedTitle}`
      } else if (state.rank === `top-1000`) {
        replayFeedTitle = `Top 1000 - ${replayFeedTitle}`
      }
      commit(`setReplayFeedTitle`, replayFeedTitle)
    },
    addReplays({ commit }, replays) {
      commit(`addReplays`, replays)
    },
    setPage({ commit }, page) {
      commit(`setPage`, page)
    },
    selectReplay({ commit }, replay) {
      commit(`selectReplay`, replay)
    },
    setReplayLikes({ commit }, { replayId, numLikes, liked }) {
      commit(`setReplayLikes`, { replayId, numLikes, liked })
    },
    setCurrentCard({ commit }, cardId) {
      commit(`setCurrentCard`, cardId)
    }
  },

  getters: {
    numReplays: state => state.aboutWinrates.numReplays,
    sinceDays: state => state.aboutWinrates.sinceDays,
    sinceDaysText: state => state.aboutWinrates.sinceDaysText,
    classArray: state => state.routeMap.classArray,
    classArchetypeRows: state => className => state.routeMap.classArchetypeRows(className),
    topArchetypeRows: state => state.routeMap.topArchetypeRows,
    currentRoute: (state, getters) => {
      return getters.routeMap ? getters.routeMap(state.path) : {}
    },
    currentPage: state => state.page,
    currentReplay: state => state.replay,
    routeMap: state => path => state.routeMap.getRoute(path),
    replays: state => state.replays.replayList,
    replayLikes: state => replayId => state.likedReplays.getReplayLikes(replayId),
    filterQueryString: state => {
      let queryStr = ``
      if (state.rank !== `all` && state.region !== `all`) {
        queryStr = `?filter=${state.rank}&region=${state.region}`
      } else if (state.rank !== `all`) {
        queryStr = `?filter=${state.rank}`
      } else if (state.region !== `all`) {
        queryStr = `?region=${state.region}`
      }
      return queryStr
    },
    filterPrefix: state => {
      const { rank, region } = state
      return [rank, region].filter(x => x && x !== `all`).join(`/`)
    },
    filterPath: (state, getters) => {
      const { rank, region } = state
      const classPath = getters.currentRoute.path
      return [rank, region, classPath].filter(x => x && x !== `all`).join(`/`)
    },
    fullPath: (state, getters) => {
      let path = ``
      if (getters.filterPath && state.path !== `/`) {
        path = `${getters.filterPath}/${state.path}`
      } else if (state.path !== `/`) {
        path = state.path
      } else {
        path = getters.filterPath
      }
      if (path[0] !== `/`) {
        path = `/${path}`
      }
      return path
    }
  }
})

export default store
