<template lang="pug">
  .top-players
    .header-row
      h2 Active players
      h3 past {{ $store.getters.sinceDays }} days
    .label-row
      .class-label name
      .winrate-label # games
    .archetype-stats
      router-link.stats-row(
        v-for="([path, deck]) in topArchetypeRows"
        :key="path"
        :to="path"
      )
        .name {{ deck.archetype }} {{ deck.class }}
        .winrate {{ deck.winrate }}%

</template>
