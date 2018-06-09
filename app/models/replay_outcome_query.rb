class ReplayOutcomeQuery

  PAGE_SIZE = 50

  def initialize(query = {})
    @class = query[:class] || 'any'
    @archetype = query[:archetype] || 'any'
    @outcome = query[:outcome] || 'any'
  end

  def replay_outcomes(page = 1)
    all_replay_outcomes
      .order('replay_outcomes.created_at DESC')
      .limit(PAGE_SIZE)
      .offset((page - 1) * PAGE_SIZE)
  end

  def all_replay_outcomes
    if archetype_ids
      ReplayOutcome.legend_players.with_archetypes(archetype_ids)
    else
      ReplayOutcome.legend_players
    end
  end

  def archetype_ids
    return @archetype_ids if defined? @archetype_ids
    @archetype_ids = archetype_ids!
  end

  def archetype_ids!
    return if @class == 'any'
    if @archetype != 'any'
      [Archetype.id_by_archetype_name("#{@archetype} #{@class}").to_s]
    else
      Archetype.ids_by_class_name @class
    end
  end

  def to_query
    {
      class: @class,
      archetype: @archetype,
      outcome: @outcome,
    }
  end
end
