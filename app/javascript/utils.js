const now = new Date()

export function trackEvent(event, category, label) {
  if (window.gtag) {
    window.gtag('event', event, {
      event_category: category,
      event_label: label
    })
  } else {
    console.log(`event: ${event}, category: ${category}, label: ${label}`)
  }
}

export function timeAgo(timestamp) {
  let timeAgo = ``
  const date = new Date(timestamp)
  const secondsSinceFound = (now - date) / 1000
  const minutesSinceFound = secondsSinceFound / 60
  if (minutesSinceFound < 60) {
    const minutes = parseInt(minutesSinceFound, 10)
    if (minutes <= 1) {
      timeAgo = `1 minute ago`
    } else {
      timeAgo = `${minutes} minutes ago`
    }
  } else {
    const hoursSinceFound = parseInt(minutesSinceFound / 60, 10)
    if (hoursSinceFound === 1) {
      timeAgo = `1 hour ago`
    } else if (hoursSinceFound < 24) {
      timeAgo = `${parseInt(hoursSinceFound, 10)} hours ago`
    } else {
      const daysSinceFound = parseInt(hoursSinceFound / 24, 10)
      if (daysSinceFound === 1) {
        timeAgo = `1 day ago`
      } else {
        timeAgo = `${daysSinceFound} days ago`
      }
    }
  }
  return timeAgo
}
