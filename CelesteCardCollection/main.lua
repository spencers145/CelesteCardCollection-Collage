--- STEAMODDED HEADER
--- MOD_NAME: Celeste Card Collection
--- MOD_ID: CelesteCardCollection
--- PREFIX: ccc
--- MOD_AUTHOR: [AuroraAquir, toneblock]
--- MOD_DESCRIPTION: 2 Decks, 9 Jokers, 2 Vouchers. Features ideas by: Fytos
--- PRIORITY: 0
--- DISPLAY_NAME: CCC
--- BADGE_COLOUR: ffc0ff
--- ICON_ATLAS: icon

----------------------------------------------
------------MOD CODE -------------------------

local sprite_card = SMODS.Sprite({key = "b_ccc_jokers", path = "ccc_jokers.png", px = 71, py = 95, atlas = "asset_atlas"})
sprite_card:register()
assert(load(love.filesystem.read(SMODS.current_mod.path .. "lua_files/jokers.lua")))()

local sprite_card = SMODS.Sprite({key = "b_ccc_decks", path = "ccc_decks.png", px = 71, py = 95, atlas = "asset_atlas"})
sprite_card:register()
assert(load(love.filesystem.read(SMODS.current_mod.path .. "lua_files/decks.lua")))()

local sprite_card = SMODS.Sprite({key = "b_ccc_vouchers", path = "ccc_vouchers.png", px = 71, py = 95, atlas = "asset_atlas"})
sprite_card:register()
assert(load(love.filesystem.read(SMODS.current_mod.path .. "lua_files/vouchers.lua")))()

assert(load(love.filesystem.read(SMODS.current_mod.path .. "lua_files/editions.lua")))()




SMODS.Sprite({
    key = "icon",
    atlas = "ASSET_ATLAS",
    path = "ccc_icon.png",
    px = 34,
    py = 34
}):register()

----------------------------------------------
------------MOD CODE END----------------------