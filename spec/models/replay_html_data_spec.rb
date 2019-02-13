require 'rails_helper'

describe ReplayHtmlData, type: :model do
  let(:hsreplay_id) { "123" }
  let(:html_data) do
    ReplayHtmlData.new({
      hsreplay_id: hsreplay_id,
      data: %(
        <div id="react_context">{"own_turns": 5, "player_name": "name"}</div>
      )
    })
  end

  it "is valid" do
    expect(html_data.valid?).to eq(true)
  end

  it "is invalid if it has no data" do
    expect(ReplayHtmlData.new(hsreplay_id: hsreplay_id).valid?).to eq(false)
  end

  it "extracts data upon saving" do
    expect(html_data.extracted_data).to eq(nil)
    html_data.save!
    expect(html_data.extracted_data["own_turns"]).to eq(5)
    expect(html_data.extracted_data["player_name"]).to eq("name")
  end

  it "doesn't delete extracted data when deleting source data" do
    expect(html_data.extracted_data).to eq(nil)
    html_data.save!
    expect(html_data.extracted_data["own_turns"]).to eq(5)
    html_data = ReplayHtmlData.find_by(hsreplay_id: hsreplay_id)
    html_data.data = nil
    html_data.save!
    expect(html_data.extracted_data["own_turns"]).to eq(5)
    expect(html_data.extracted_data["player_name"]).to eq("name")
  end
end
