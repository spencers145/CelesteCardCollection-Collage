--- STEAMODDED HEADER
--- MOD_NAME: Celeste Card Collection
--- MOD_ID: CelesteCardCollection
--- PREFIX: ccc
--- MOD_AUTHOR: [AuroraAquir, toneblock, Gappie, bein, sunsetquasar, goose!]
--- MOD_DESCRIPTION: Featuring 4 new decks, 50+ new jokers, and 2 new vouchers! Additional thanks to Bred and Fytos for concepts!
--- PRIORITY: 0
--- DISPLAY_NAME: CCC
--- BADGE_COLOUR: ffc0ff

----------------------------------------------
------------MOD CODE -------------------------

assert(SMODS.load_file("lua_files/_helper_functions.lua"))()

SMODS.Atlas({key = "j_ccc_jokers", path = "j_ccc_jokers.png", px = 71, py = 95, atlas = "asset_atlas"})
assert(SMODS.load_file("lua_files/jokers.lua"))()

SMODS.Atlas({key = "b_ccc_decks", path = "b_ccc_decks.png", px = 71, py = 95, atlas = "asset_atlas"})
assert(SMODS.load_file("lua_files/decks.lua"))()

SMODS.Atlas({key = "v_ccc_vouchers", path = "v_ccc_vouchers.png", px = 71, py = 95, atlas = "asset_atlas"})
assert(SMODS.load_file("lua_files/vouchers.lua"))()

SMODS.Atlas({key = "bl_ccc_blinds", path = "bl_ccc_blinds.png", px = 34, py = 34, frames = 21, atlas_table = "ANIMATION_ATLAS"})
assert(SMODS.load_file("lua_files/blinds.lua"))()

-- SMODS.Atlas({key = "i_ccc_instapix", path = "i_ccc_instapix.png", px = 71, py = 95, atlas = "asset_atlas"})
-- assert(SMODS.load_file("lua_files/instapix.lua"))()

SMODS.Atlas({key = "c_ccc_consumables", path = "c_ccc_consumables.png", px = 71, py = 95, atlas = "asset_atlas"})
assert(SMODS.load_file("lua_files/consumables.lua"))()

assert(SMODS.load_file("lua_files/editions.lua"))()

assert(SMODS.load_file("lua_files/localization/en-us.lua"))()

SMODS.Atlas({
    key = "modicon",
    path = "ccc_icon.png",
    px = 34,
    py = 34
}):register()


----------------------------------------------
------------MOD CODE END----------------------
