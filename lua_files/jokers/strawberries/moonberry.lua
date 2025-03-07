
-- region Moon Berry

local moonberry = {
	name = "ccc_Moon Berry",
	key = "moonberry",
	config = { extra = { condition_satisfied = false, winged_poker_hand = 'Pair', old_winged_poker_hand = 'Pair' } }, -- old_winged_poker_hand is internal, winged_poker_hand is external
	pos = { x = 5, y = 1 },
	loc_txt = {
		name = 'Moon Berry',
		text = {
			"If round ends without playing",
			"hand that contains a {C:attention}#1#{},",
			"create its {C:planet}Planet{} card with",
			"added {C:dark_edition}Negative{} edition,",
			"{s:0.8}poker hand changes at end of round"
		}
	},
	rarity = 2,
	cost = 8,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Gappie"
	},
    description = "IF round ends without playing hand that contains a randomly chosen Hand create its Planet card as a negative. Hand changes every round",
	set_badges = function(self, card, badges)
		badges[#badges+1] = create_badge(localize('k_ccc_strawberry_badge', "labels"), G.C.RED, G.C.WHITE, 1)
	end,
}

moonberry.set_ability = function(self, card, initial, delay_sprites)
	local _poker_hands = {}
	for k, v in pairs(G.GAME.hands) do
		if v.visible and k ~= 'High Card' then
			_poker_hands[#_poker_hands + 1] = k
		end
	end
	card.ability.extra.winged_poker_hand = pseudorandom_element(_poker_hands, pseudoseed('SPAAAAAAAACE'))
	card.ability.extra.old_winged_poker_hand = card.ability.extra.winged_poker_hand
end

moonberry.calculate = function(self, card, context)
	if context.setting_blind and not context.blueprint then
		card.ability.extra.old_winged_poker_hand = card.ability.extra
		.winged_poker_hand                                                        -- delay old_winged_poker_hand from changing due to brainstorm
	end
	if context.end_of_round and not context.repetition and not context.individual then
		local card_type = 'Planet'
		if card.ability.extra.condition_satisfied == true then
			G.E_MANAGER:add_event(Event({
				trigger = 'before',
				delay = 0.0,
				func = (function()
					local _planet = 0
					for k, v in pairs(G.P_CENTER_POOLS.Planet) do
						if v.config.hand_type == card.ability.extra.old_winged_poker_hand then -- use old_winged_poker_hand
							_planet = v.key
						end
					end
					local card = create_card(card_type, G.consumeables, nil, nil, nil, nil, _planet, 'blusl')
					card:set_edition({ negative = true }, true)
					card:add_to_deck()
					G.consumeables:emplace(card)
					return true
				end)
			}))
		end
		if not context.blueprint then
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.0,
				func = (function()
					local _poker_hands = {}
					for k, v in pairs(G.GAME.hands) do
						if v.visible and k ~= card.ability.extra.winged_poker_hand and k ~= 'High Card' then
							_poker_hands[#_poker_hands + 1] = k
						end
					end
					card.ability.extra.winged_poker_hand = pseudorandom_element(_poker_hands, pseudoseed('SPAAAAAAAACE')) -- change winged_poker_hand
					card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Reset", colour = G.C.FILTER })
					return true
				end)
			}))
		end
		if card.ability.extra.condition_satisfied == true then
			card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,
				{ message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet })
			return nil, true
		end
	end
	if context.cardarea == G.jokers then
		if context.before and not context.end_of_round then
			if next(context.poker_hands[card.ability.extra.winged_poker_hand]) then
				card.ability.extra.condition_satisfied = false
			end
		end
	end
	if context.setting_blind then
		card.ability.extra.condition_satisfied = true
	end
end

function moonberry.loc_vars(self, info_queue, card)
	info_queue[#info_queue + 1] = { key = 'e_negative_consumable', set = 'Edition', config = { extra = 1 } }
	return { vars = { card.ability.extra.winged_poker_hand } }
end

return moonberry
-- endregion Moon Berry