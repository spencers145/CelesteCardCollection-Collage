-- region Purple Spinner

local purplespinner = {
	name = "ccc_Purple Spinner",
	key = "purplespinner",
	config = { extra = { prob_success = 2 } },
	pos = { x = 1, y = 4 },
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
    description = "When a card with a Purple Seal is held in hand at end of round, 1 in 2 chance to add a Purple Seal to each adjacent card in hand (Unaffected by retriggers)"
}

purplespinner.calculate = function(self, card, context)
	if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
		local rainbow_spinner_seal_override = false
		if next(find_joker('ccc_Rainbow Spinner')) then
			rainbow_spinner_seal_override = true
		else
			rainbow_spinner_seal_override = false
		end
		purplespinner_seal_candidates = {}
		for k = 1, #G.hand.cards do
			if k == 1 then
				if k ~= #G.hand.cards then
					if G.hand.cards[k + 1].seal == 'Purple' or (rainbow_spinner_seal_override == true and G.hand.cards[k + 1].seal == 'Gold') then
						if pseudorandom('purple1') < G.GAME.probabilities.normal / card.ability.extra.prob_success then
							purplespinner_seal_candidates[#purplespinner_seal_candidates + 1] = G.hand.cards[k]
						end
					end
				end
			elseif k == #G.hand.cards then
				if k ~= 1 then
					if G.hand.cards[k - 1].seal == 'Purple' or (rainbow_spinner_seal_override == true and G.hand.cards[k - 1].seal == 'Gold') then
						if pseudorandom('is2') < G.GAME.probabilities.normal / card.ability.extra.prob_success then
							purplespinner_seal_candidates[#purplespinner_seal_candidates + 1] = G.hand.cards[k]
						end
					end
				end
			else
				if G.hand.cards[k + 1].seal == 'Purple' or (rainbow_spinner_seal_override == true and G.hand.cards[k + 1].seal == 'Gold') then
					if pseudorandom('best3') < G.GAME.probabilities.normal / card.ability.extra.prob_success then
						purplespinner_seal_candidates[#purplespinner_seal_candidates + 1] = G.hand.cards[k]
					end
				elseif G.hand.cards[k - 1].seal == 'Purple' or (rainbow_spinner_seal_override == true and G.hand.cards[k - 1].seal == 'Gold') then
					if pseudorandom('colour4') < G.GAME.probabilities.normal / card.ability.extra.prob_success then
						purplespinner_seal_candidates[#purplespinner_seal_candidates + 1] = G.hand.cards[k]
					end
				end
			end
		end
		if #purplespinner_seal_candidates > 0 then
			for k = 1, #purplespinner_seal_candidates do
				if (rainbow_spinner_seal_override == true and purplespinner_seal_candidates[k].seal ~= 'Purple' and purplespinner_seal_candidates[k].seal ~= 'Gold') or (rainbow_spinner_seal_override == false and purplespinner_seal_candidates[k].seal ~= 'Purple') then
					G.E_MANAGER:add_event(Event({
						trigger = 'after',
						delay = 0.0,
						func = function()
							purplespinner_seal_candidates[k]:set_seal('Purple', true, false)
							purplespinner_seal_candidates[k]:juice_up()
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

function purplespinner.loc_vars(self, info_queue, card)
	info_queue[#info_queue + 1] = { key = 'purple_seal', set = 'Other' }
	return { vars = { '' .. (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.prob_success } }
end

function purplespinner.in_pool(self)
	for i, v in ipairs(G.playing_cards) do
		if v.seal and v.seal == 'Purple' then return true end
	end
	return false
end

return purplespinner
-- endregion Purple Spinner