--- STEAMODDED HEADER
--- MOD_NAME: Celeste Card Collection
--- MOD_ID: CelesteCardCollection
--- MOD_AUTHOR: [AuroraAquir, toneblock]
--- MOD_DESCRIPTION: Virus Deck + 2 Jokers
--- PRIORITY: 0
--- DISPLAY_NAME: CCC
--- BADGE_COLOUR: ffc0ff

----------------------------------------------
------------MOD CODE -------------------------


function SMODS.INIT.CCC()
	local ccc_mod = SMODS.findModByID("CelesteCardCollection")
	assert(load(love.filesystem.read(ccc_mod.path .. "blinds.lua")))()
	
    local sprite_card = SMODS.Sprite:new("b_cccdecks", ccc_mod.path, "decks.png", 71, 95, "asset_atli")
    sprite_card:register()

	assert(load(love.filesystem.read(ccc_mod.path .. "decks.lua")))()
	
    local sprite_card = SMODS.Sprite:new("b_cccjokers", ccc_mod.path, "jokers.png", 71, 95, "asset_atli")
    sprite_card:register()

	assert(load(love.filesystem.read(ccc_mod.path .. "jokers.lua")))()
end


function dump(o)
	if type(o) == 'table' then
	   local s = '{ '
	   for k,v in pairs(o) do
		  if type(k) ~= 'number' then k = '"'..k..'"' end
		  s = s .. '['..k..'] = ' .. dump(v) .. ','
	   end
	   return s .. '} '
	else
	   return tostring(o)
	end
 end

----------------------------------------------
------------MOD CODE END----------------------