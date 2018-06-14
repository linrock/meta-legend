class LegendFinder

  def find_legends
    battletags = User.pluck(:battletag)
    seen_legend_tags = Set.new
    ReplayXmlData.pluck(:extracted_data).map do |data|
      next unless data.present?
      [data['p1']['tag'], data['p2']['tag']].compact.each do |tag|
        seen_legend_tags.add tag
      end
    end
    battletags.select {|tag| seen_legend_tags.include? tag }
  end

  def verify_legends!
    User.find_by(battletag: find_legends, is_legend: false).each do |u|
      u.is_legend = true
      u.save!
    end
  end
end
