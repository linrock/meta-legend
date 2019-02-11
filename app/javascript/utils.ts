const now = +(new Date())

export function trackEvent(event, category, label): void {
  const gtag = (<any>window).gtag
  if (gtag) {
    gtag('event', event, {
      event_category: category,
      event_label: label
    })
  } else {
    console.log(`event: ${event}, category: ${category}, label: ${label}`)
  }
}

export function timeAgo(timestamp): string {
  let timeAgo = ``
  const date = +(new Date(timestamp))
  const secondsSinceFound = (now - date) / 1000
  const minutesSinceFound = secondsSinceFound / 60
  if (minutesSinceFound < 60) {
    if (minutesSinceFound <= 1) {
      timeAgo = `1 minute ago`
    } else {
      timeAgo = `${Math.round(minutesSinceFound)} minutes ago`
    }
  } else {
    const hoursSinceFound = Math.round(minutesSinceFound / 60)
    if (hoursSinceFound === 1) {
      timeAgo = `1 hour ago`
    } else if (hoursSinceFound < 24) {
      timeAgo = `${hoursSinceFound} hours ago`
    } else {
      const daysSinceFound = Math.round(hoursSinceFound / 24)
      if (daysSinceFound === 1) {
        timeAgo = `1 day ago`
      } else {
        timeAgo = `${daysSinceFound} days ago`
      }
    }
  }
  return timeAgo
}

export function paramsToString(params: Object): string {
  return Object.entries(params).map(([k,v]) => `${k}=${v}`).join(`&`)
}
