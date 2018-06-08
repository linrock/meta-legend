interface Route {
  class?: string;
  archetype?: string;
  winrate?: string;
}

type RouteObj = {
  [path: string]: Route
}

export default class RouteMap {

  constructor(public routeMap: RouteObj) {
    this.routeMap = routeMap
  }

  get classArray(): Array<[string, Route]> {
    return Object.entries(this.routeMap)
      .filter(r => !r[1].archetype)
      .sort((a,b) => parseFloat(b[1].winrate) - parseFloat(a[1].winrate))
  }

  // top 5 archetypes
  get topArchetypeRows(): Array<[string, Route]> {
    return Object.entries(this.routeMap)
      .sort((a,b) => parseFloat(b[1].winrate) - parseFloat(a[1].winrate))
      .filter(r => r[1].archetype)
      .slice(0, 5)
  }

  classArchetypeRows(className): Array<[string, Route]> {
    return Object.entries(this.routeMap)
      .filter(r => r[1].class === className && r[1].archetype)
      .sort((a,b) => parseFloat(b[1].winrate) - parseFloat(a[1].winrate))
  }

  getRoute(path): Route {
    return this.routeMap[path.replace(/^\//, '')] || {}
  }
}
