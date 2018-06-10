class ReplayHtmlData < ApplicationRecord
  validates_uniqueness_of :hsreplay_id
  validate :has_either_data_or_extracted_data

  before_save :extract_and_save_html_data

  delegate :num_turns, :player_names, :pilot_name,
           :replay_xml_link, :json_data, :doc,
           to: :replay_html_parser

  def extract_and_save_html_data
    self.extracted_data = json_data
  end

  def replay_html_parser
    @replay_html_parser ||= ReplayHtmlParser.new(data)
  end

  private

  def has_either_data_or_extracted_data
    unless data.present? or extracted_data.present?
      errors.add(:data, "can't be empty if extracted_data does not exist")
    end
  end
end
