require 'rails_helper'

describe ReplayXmlData, type: :model do
  let(:xml_data) do
    ReplayXmlData.new({
      hsreplay_id: "123",
      data: %(
        <?xml version='1.0' encoding='utf-8'?>
        <!DOCTYPE hsreplay SYSTEM "https://hearthsim.info/hsreplay/dtd/hsreplay-1.7.dtd">
        <HSReplay build="28855" version="1.7">
          <Game ts="2019-02-09T00:55:10.898859-05:00">
            <Player id="2" playerID="1" name="battletag#1337" legendRank="1">
              <Deck>
                #{30.times.map { '<Card id="1"/>' }.join("\n")}
              </Deck>
            </Player>
            <Player id="2" playerID="1" name="btag#1337" legendRank="2">
            </Player>
          </Game>
        </HSReplay>
      )
    })
  end

  it "is valid" do
    expect(xml_data.valid?).to eq(true)
    expect(xml_data.save!).to eq(true)
  end

  it "extracts data from xml" do
    expect(xml_data.extracted_data).to_not be_present
    xml_data.save!
    data = xml_data.extracted_data
    expect(data["played_at"]).to_not be(nil)
    expect(data["p1"]["tag"]).to eq("battletag#1337")
    expect(data["p1"]["legend_rank"]).to eq("1")
    expect(data["p2"]["tag"]).to eq("btag#1337")
    expect(data["p2"]["legend_rank"]).to eq("2")
    expect(data["deck_card_ids"].length).to be(30)
  end

  it "doesn't delete extracted data when deleting source data" do
    expect(xml_data.data).to be_present
    expect(xml_data.extracted_data).to_not be_present
    xml_data.save!
    expect(xml_data.data).to be_present
    expect(xml_data.extracted_data).to be_present
    xml_data.data = nil
    xml_data.save!
    expect(xml_data.data).to_not be_present
    expect(xml_data.extracted_data).to be_present
  end
end
