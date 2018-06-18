class ReplayOutcomeFilter
  FILTERS = %w( all top-100 top-1000 )

  def self.get_filter(filter)
    FILTERS.include?(filter) ? filter : FILTERS[0]
  end
end
