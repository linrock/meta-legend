require 'open-uri'

class ReplayExtractor

  def self.extract_all!(replay_outcomes = nil)
    replay_outcomes ||=
      ReplayOutcome.legend_players.since(5.days.ago).top_legend(1000)
    replay_outcomes.each do |r|
      begin
        re = self.new(r.hsreplay_id)
        re.save! unless re.exists?
      rescue => e
        puts "Error fetching replay #{r.hsreplay_id}"
        puts "#{e.class.name}: #{e.message}"
        puts e.backtrace
        sleep 60
      end
    end
  end

  def initialize(hsreplay_id)
    @hsreplay_id = hsreplay_id
  end

  def exists?
    File.exists?(html_filename) && File.exists?(xml_filename)
  end

  def replay_xml_link
    link = doc.css("a[download]").first.attr "href"
    link = link.gsub(/&amp;/, '&')
    puts link
    link
  end

  def replay_xml
    @xml ||= open(replay_xml_link).read.force_encoding("utf-8")
  end

  def save_html!
    open(html_filename, "w") do |f|
      f.write html
    end
  end

  def save_xml!
    open(xml_filename, "w") do |f|
      begin
        f.write replay_xml
      rescue
        binding.pry
      end
    end
  end

  def save!
    puts "Saving #{@hsreplay_id}..."
    t0 = Time.now
    save_html!
    save_xml!
    puts "Took #{Time.now - t0}s to save replay data"
  end

  private

  def html_filename
    "data/#{@hsreplay_id}.html"
  end

  def xml_filename
    "data/#{@hsreplay_id}.xml"
  end

  def html
    @html ||= open("https://hsreplay.net/replay/#{@hsreplay_id}").read
  end

  def doc
    @doc ||= Nokogiri::HTML.parse html
  end
end
