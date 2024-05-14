-- region gondola

local v_gondola = SMODS.Voucher({
	name = "Fast Track",
	key = "gondola",  -- ACTUAL KEY IS "v_ccc_gondola"
    config = {extra = 1},
	pos = {x = 0, y = 0},
	loc_txt = {
        name = 'Fast Track',
        text = {
	"{C:attention}+1{} Ante",
	"Blinds require {C:red}30%{} less chips"
        }
    },
	cost = 10,
	discovered = true,
	unlocked = true,
	available = true,
	requires = {},
	atlas = "b_ccc_vouchers"
})

v_gondola:register()

function v_gondola.redeem(center_table)
    if G.GAME.round_resets.blind_ante == G.GAME.win_ante then
        G.GAME.win_ante = G.GAME.win_ante + 1
    end
    -- center_table has 2 fields: name (the center's name) and extra (the extra field of the voucher config)
    -- apparently the above comment is no longer applicable so i just replaced both instances of center_table.extra with 1... surely that won't cause any problems
    ease_ante(1)
    G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
    G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante + 1
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

local v_feather = SMODS.Voucher({
	name = "Mindfulness",
	key = "feather", -- ACTUAL KEY IS "v_ccc_feather"
    config = {},
	pos = {x = 0, y = 1},
	loc_txt = {
        name = 'Mindfulness',
        text = {
	"Blinds require {C:red}30%{} less chips"
        }
    },
	cost = 10,
	discovered = true,
	unlocked = true,
	available = true,
	requires = {'v_ccc_gondola'},
	atlas = "b_ccc_vouchers"
})



function v_feather.redeem(center_table)
    G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling * 0.7
end



-- endregion gondola

sendDebugMessage("[CCC] Vouchers loaded")