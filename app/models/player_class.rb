class PlayerClass
  NAMES = %w(
    Druid
    Hunter
    Mage
    Paladin
    Priest
    Rogue
    Shaman
    Warlock
    Warrior
  )

  REGEX = /#{NAMES.join("|")}/i
end
