--- STEAMODDED HEADER
--- SECONDARY MOD FILE

----------------------------------------------
------------MOD CODE -------------------------

-- region gondola

-- SMODS.Voucher:new(name, slug, config, pos, loc_txt, cost, unlocked, discovered, available, requires, atlas)
local v_gondola = SMODS.Voucher:new('Gondola', 'gondola', {extra = 1}, { x = 0, y = 0 }, {
    name = 'Fast Track',
    text = { 
        [1]='{C:attention}+1{} Ante',
        [2]='Blinds require {C:red}30%{} less chips'
 },
}, 10, true, false, true, {}, 'b_cccvouchers')

v_gondola:register()
function SMODS.Vouchers.v_gondola.redeem(center_table)
    if G.GAME.round_resets.blind_ante == G.GAME.win_ante then
        G.GAME.win_ante = G.GAME.win_ante + 1
    end
    -- center_table has 2 fields: name (the center's name) and extra (the extra field of the voucher config)
    ease_ante(center_table.extra)
    G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
    G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante+center_table.extra
    G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling * 0.7
end

-- local gondolaOnlyOnce = false
-- local get_current_poolRef = get_current_pool
-- function get_current_pool(_type, _rarity, _legendary, _append)
--     if not gondolaOnlyOnce then
--         for index, value in ipairs(G.P_CENTER_POOLS.Voucher) do
--             if value.key == "v_gondola" then
--                 value.no_pool_flag = "gondola_ante8"
--             end
--         end
--         gondolaOnlyOnce = true
--     end
--     if G.GAME then
--         local gondola = G.P_CENTER_POOLS.Voucher[33]
--         sendDebugMessage(dump(gondola))
--         sendDebugMessage(dump(G.GAME.pool_flags))
--         sendDebugMessage(tostring(gondola.no_pool_flag and G.GAME.pool_flags[gondola.no_pool_flag]))
--         G.GAME.pool_flags.gondola_ante8 = G.GAME.round_resets.blind_ante == 8
--     end
-- 	return get_current_poolRef(_type, _rarity, _legendary, _append)
-- end

local v_feather = SMODS.Voucher:new('Mindfulness', 'feather', {}, { x = 0, y = 1 }, {
    name = 'Mindfulness',
    text = {'Blinds require {C:red}30%{} less chips'},
}, 10, true, false, true, {'v_gondola'}, 'b_cccvouchers')
v_feather:register()
function SMODS.Vouchers.v_feather.redeem(center_table)
    G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling * 0.7
end


-- endregion gondola

sendDebugMessage("[CCC] Vouchers loaded")
----------------------------------------------
------------MOD CODE END----------------------
