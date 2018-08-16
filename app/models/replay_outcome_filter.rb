class ReplayOutcomeFilter
  FILTERS = %w( all top-100 top-500 top-1000 )
  REGIONS = %w( all americas europe asia )

  def self.get_rank_filter(filter)
    FILTERS.include?(filter) ? filter : FILTERS[0]
  end

  def self.get_region_filter(region)
    REGIONS.include?(region) ? region : REGIONS[0]
  end
end
