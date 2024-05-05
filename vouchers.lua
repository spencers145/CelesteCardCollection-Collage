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
    -- center_table has 2 fields: name (the center's name) and extra (the extra field of the voucher config)
    ease_ante(center_table.extra)
    G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
    G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante+center_table.extra
    G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling * 0.7
end


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
