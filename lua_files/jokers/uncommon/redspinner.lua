-- region Red Spinner

local redspinner = {
	name = "ccc_Red Spinner",
	key = "redspinner",
	config = { extra = { prob_success = 2 } },
	pos = { x = 2, y = 4 },
	loc_txt = {
		name = 'Red Spinner',
		text = {
			"When a card with a {C:red}Red Seal{}",
			"is {C:attention}discarded{}, {C:green}#1# in #2#{} chance",
			"to add a {C:red}Red Seal{} to each",
			"{C:attention}adjacent{} card in discarded hand",
			"{C:inactive,s:0.87}(Unaffected by retriggers){}"
		}
	},
	rarity = 2,
	cost = 6,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "toneblock",
		code = "toneblock",
		concept = "sunsetquasar"
	},
    description = "When a card with a Red Seal is discarded, 1 in 2 chance to add a Red Seal to each card in discarded hand (Unaffected by retriggers)"
}

redspinner.calculate = function(self, card, context)
	if context.pre_discard and not context.blueprint then
		local rainbow_spinner_seal_override = false
		if next(find_joker('ccc_Rainbow Spinner')) then
			rainbow_spinner_seal_override = true
		else
			rainbow_spinner_seal_override = false
		end
		redspinner_seal_candidates = {}
		for k = 1, #G.hand.highlighted do
			if k == 1 then
				if k ~= #G.hand.highlighted then
					if G.hand.highlighted[k + 1].seal == 'Red' or (rainbow_spinner_seal_override == true and G.hand.highlighted[k + 1].seal == 'Gold') then
						if pseudorandom('RED1') < G.GAME.probabilities.normal / card.ability.extra.prob_success then
							redspinner_seal_candidates[#redspinner_seal_candidates + 1] = G.hand.highlighted[k]
						end
					end
				end
			elseif k == #G.hand.highlighted then
				if k ~= 1 then
					if G.hand.highlighted[k - 1].seal == 'Red' or (rainbow_spinner_seal_override == true and G.hand.highlighted[k - 1].seal == 'Gold') then
						if pseudorandom('redge2') < G.GAME.probabilities.normal / card.ability.extra.prob_success then
							redspinner_seal_candidates[#redspinner_seal_candidates + 1] = G.hand.highlighted[k]
						end
					end
				end
			else
				if G.hand.highlighted[k + 1].seal == 'Red' or (rainbow_spinner_seal_override == true and G.hand.highlighted[k + 1].seal == 'Gold') then
					if pseudorandom('reeeeeeeed3') < G.GAME.probabilities.normal / card.ability.extra.prob_success then
						redspinner_seal_candidates[#redspinner_seal_candidates + 1] = G.hand.highlighted[k]
					end
				elseif G.hand.highlighted[k - 1].seal == 'Red' or (rainbow_spinner_seal_override == true and G.hand.highlighted[k - 1].seal == 'Gold') then
					if pseudorandom('dontknowhattoputhere4') < G.GAME.probabilities.normal / card.ability.extra.prob_success then
						redspinner_seal_candidates[#redspinner_seal_candidates + 1] = G.hand.highlighted[k]
					end
				end
			end
		end
		if #redspinner_seal_candidates > 0 then
			for k = 1, #redspinner_seal_candidates do
				if (rainbow_spinner_seal_override == true and redspinner_seal_candidates[k].seal ~= 'Red' and redspinner_seal_candidates[k].seal ~= 'Gold') or (rainbow_spinner_seal_override == false and redspinner_seal_candidates[k].seal ~= 'Red') then
					G.E_MANAGER:add_event(Event({
						trigger = 'after',
						delay = 0.0,
						func = function()
							redspinner_seal_candidates[k]:set_seal('Red', true, false)
							redspinner_seal_candidates[k]:juice_up()
							play_sound('gold_seal', 1.2, 0.4)
							card:juice_up()
							return true
						end
					}))
					delay(0.5)
				end
			end
			return nil, true
		end
	end
end

function redspinner.loc_vars(self, info_queue, card)
	info_queue[#info_queue + 1] = { key = 'red_seal', set = 'Other' }
	return { vars = { '' .. (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.prob_success } }
end

function redspinner.in_pool(self)
	for i, v in ipairs(G.playing_cards) do
		if v.seal and v.seal == 'Red' then return true end
	end
	return false
end

return redspinner
-- endregion Red Spinner