--- STEAMODDED HEADER
--- MOD_NAME: Celeste Card Collection
--- MOD_ID: CelesteCardCollection
--- PREFIX: ccc
--- MOD_AUTHOR: [AuroraAquir, toneblock, Gappie]
--- MOD_DESCRIPTION: Featuring 2 new decks, 16 new jokers, and 2 new vouchers! Special thanks to Fytos, Gappie and Bred for joker ideas
--- PRIORITY: 0
--- DISPLAY_NAME: CCC
--- BADGE_COLOUR: ffc0ff
--- ICON_ATLAS: ccc_icon

----------------------------------------------
------------MOD CODE -------------------------

SMODS.Atlas({key = "j_ccc_jokers", path = "j_ccc_jokers.png", px = 71, py = 95, atlas = "asset_atlas"})
assert(load(love.filesystem.read(SMODS.current_mod.path .. "lua_files/jokers.lua")))()

SMODS.Atlas({key = "b_ccc_decks", path = "b_ccc_decks.png", px = 71, py = 95, atlas = "asset_atlas"})
assert(load(love.filesystem.read(SMODS.current_mod.path .. "lua_files/decks.lua")))()

SMODS.Atlas({key = "v_ccc_vouchers", path = "v_ccc_vouchers.png", px = 71, py = 95, atlas = "asset_atlas"})
assert(load(love.filesystem.read(SMODS.current_mod.path .. "lua_files/vouchers.lua")))()

assert(load(love.filesystem.read(SMODS.current_mod.path .. "lua_files/editions.lua")))()

SMODS.Atlas({
    key = "ccc_icon",
    atlas = "ASSET_ATLAS",
    path = "ccc_icon.png",
    px = 34,
    py = 34
})

----------------------------------------------
------------MOD CODE END----------------------
