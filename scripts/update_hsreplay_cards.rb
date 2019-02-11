# Updates the data/archetype_card_map.json file
# used by the archetype matcher.
# Fetches hsreplay card data

HsreplayCardImporter.import_all
ArchetypeCardMap.new.export!
