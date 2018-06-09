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
    rank_query = "
      replay_outcomes.data ->> 'player1_legend_rank' != 'None'
      AND
      replay_outcomes.data ->> 'player2_legend_rank' != 'None'
    "
    archetype_query = nil
    if archetype_ids
      archetype_query = "
        (replay_outcomes.data ->> 'player1_archetype' IN (?))
        OR
        (replay_outcomes.data ->> 'player2_archetype' IN (?))
      "
    end
    query = [ rank_query, archetype_query ].compact.join (" AND ")
    prepared_variables = [(archetype_ids if archetype_ids)].compact
    ReplayOutcome.where(query, *prepared_variables*2)
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
