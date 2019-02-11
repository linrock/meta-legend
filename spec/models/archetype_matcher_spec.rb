require 'rails_helper'

describe ArchetypeMatcher, type: :model do
  before(:all) do
    Archetype.create_from_archetypes_json!
  end

  it 'matches shudderwock shaman' do
    matcher = ArchetypeMatcher.new(
      [
        "UNG_840", "LOOT_373", "LOOT_373", "CS2_053", "CS2_053", "EX1_246", "EX1_246", "UNG_928", "UNG_928", "LOOT_358", "EX1_575", "EX1_575", "LOOT_516", "UNG_205", "UNG_205", "EX1_085", "UNG_025", "UNG_025", "GIL_622", "GIL_622", "GIL_820", "ICC_851", "EX1_245", "EX1_245", "GIL_504", "ICC_466", "ICC_466", "UNG_946", "EX1_259", "EX1_259"
      ],
      'Shaman'
    )
    expect(matcher.top_match[:name]).to eq('Shudderwock Shaman')
  end

  it 'matches deathrattle rogue' do
    matcher = ArchetypeMatcher.new(
      ["UNG_083", "BOT_286", "LOOT_161", "BOT_508"],
      'Rogue'
    )
    expect(matcher.top_match[:name]).to eq('Deathrattle Rogue')
  end

  it 'matches mechathun priest' do
    matcher = ArchetypeMatcher.new(["BOT_424"], 'Priest')
    expect(matcher.top_match[:name]).to eq("Mecha'thun Priest")
  end

  it 'matches mechathun warlock' do
    matcher = ArchetypeMatcher.new(["BOT_424"], 'Warlock')
    expect(matcher.top_match[:name]).to eq("Mecha'thun Warlock")
  end

  it 'matches mechathun druid' do
    matcher = ArchetypeMatcher.new(["BOT_424"], 'Druid')
    expect(matcher.top_match[:name]).to eq("Mecha'thun Druid")
  end

  it 'matches subject 9 to secret hunter' do
    matcher = ArchetypeMatcher.new(["BOT_573"], 'Hunter')
    expect(matcher.top_match[:name]).to eq("Secret Hunter")
  end

  it 'matches odd quest warrior' do
    matcher = ArchetypeMatcher.new(["GIL_826", "UNG_934"], 'Warrior')
    expect(matcher.top_match[:name]).to eq("Odd Quest Warrior")
  end

  it 'matches odd warrior' do
    matcher = ArchetypeMatcher.new(["GIL_826"], 'Warrior')
    expect(matcher.top_match[:name]).to eq("Odd Warrior")
  end
end
