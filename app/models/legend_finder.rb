# Finds and verifies legend players from recent replay data

class LegendFinder

  def find_legends
    battletags = User.pluck(:battletag)
    seen_legend_tags = Set.new
    ReplayXmlData.order('id DESC').limit(10000).pluck(:extracted_data).map do |data|
      next unless data.present?
      [data['p1']['tag'], data['p2']['tag']].compact.each do |tag|
        seen_legend_tags.add tag
      end
    end
    battletags.select {|tag| seen_legend_tags.include? tag }
  end

  def verify_legends!
    User.where(battletag: find_legends).each do |u|
      next if u.is_legend
      u.is_legend = true
      u.save!
    end
  end
end
