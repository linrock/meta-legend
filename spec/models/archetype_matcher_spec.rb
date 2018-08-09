require 'rails_helper'

describe ArchetypeMatcher, type: :model do
  before(:all) do
    Archetype.create_from_archetypes_json!
  end

  it 'matches shudderwock shaman' do
    matcher = ArchetypeMatcher.new([
      "UNG_840", "LOOT_373", "LOOT_373", "CS2_053", "CS2_053", "EX1_246", "EX1_246", "UNG_928", "UNG_928", "LOOT_358", "EX1_575", "EX1_575", "LOOT_516", "UNG_205", "UNG_205", "EX1_085", "UNG_025", "UNG_025", "GIL_622", "GIL_622", "GIL_820", "ICC_851", "EX1_245", "EX1_245", "GIL_504", "ICC_466", "ICC_466", "UNG_946", "EX1_259", "EX1_259"
    ], 'Shaman')
    expect(matcher.top_match[:name]).to eq('Shudderwock Shaman')
  end
end
