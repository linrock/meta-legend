import Route from './route'

type RouteObj = {
  [path: string]: Route
}

export default class RouteMap {

  constructor(public routeMap: RouteObj) {
    this.routeMap = routeMap || {}
  }

  get routeMapEntries(): Array<[string, Route]> {
    return Object.entries(this.routeMap)
  }

  get classArray(): Array<[string, Route]> {
    return this.routeMapEntries
      .filter(r => !r[1].archetype)
      .sort((a,b) => parseFloat(b[1].winrate) - parseFloat(a[1].winrate))
  }

  // top 5 archetypes on homepage
  get topArchetypeRows(): Array<[string, Route]> {
    return this.routeMapEntries
      .sort((a,b) => b[1].n - a[1].n)
      .filter(r => r[1].archetype)
      .slice(0, 5)
  }

  classArchetypeRows(className): Array<[string, Route]> {
    return this.routeMapEntries
      .filter(r => r[1].class === className && r[1].archetype)
      .sort((a,b) => b[1].n - a[1].n)
  }

  getRoute(path): Route|object {
    return this.routeMap[path.replace(/^\//, '')] || {}
  }
}
