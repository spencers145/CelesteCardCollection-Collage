
-- region Theo Crystal

local theocrystal = {
	name = "ccc_Theo Crystal",
	key = "theocrystal",
	config = { extra = { base_probs = 0, base_scale = 1, scale = 1, probs = 0 } },
	pixel_size = { w = 71, h = 71 },
	pos = { x = 9, y = 2 },
	loc_txt = {
		name = 'Theo Crystal',
		text = {
			"Forces 1 card to",
			"{C:attention}always{} be selected",
			"Adds {C:green}+#1#{} to {C:attention}listed{} {C:green,E:1}probabilities{}",
			"on defeat of {C:attention}Boss Blind",
			"{C:inactive}(ex: {C:green}2 in 7{C:inactive} -> {C:green}3 in 7{C:inactive})",
			"{C:inactive}(Currently {C:green}+#2#{C:inactive})"
		}
	},
	rarity = 3,
	cost = 12,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "j_ccc_jokers",
	add_to_deck = function(self, card, from_debuff)
		local oops_factor = 1
		if G.jokers ~= nil then -- this is always true?
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i].ability.set == 'Joker' then
					if G.jokers.cards[i].ability.name == 'Oops! All 6s' then
						oops_factor = oops_factor * 2
					end
				end
			end
			for k, v in pairs(G.GAME.probabilities) do
				G.GAME.probabilities[k] = v + (card.ability.extra.base_probs * oops_factor)
			end
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		local oops_factor = 1
		if G.jokers ~= nil then
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i].ability.set == 'Joker' then
					if G.jokers.cards[i].ability.name == 'Oops! All 6s' then
						oops_factor = oops_factor * 2
					end
				end
			end
		end
		for k, v in ipairs(G.hand.cards) do
			if v.ability.forced_selection then
				v.ability.forced_selection = false
			end
		end
		for k, v in pairs(G.GAME.probabilities) do
			G.GAME.probabilities[k] = v - (card.ability.extra.base_probs * oops_factor)
		end
	end,
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "toneblock"
	},
    description = "Forces one card to always be selected. Adds +1 to all listed probabilites at round end."
}

-- lovely injections to deal with the probability system (what a pain)

-- scale and probs are only for display purposes and are not actually used

-- also using lovely to hijack Blind:drawn_to_hand? this is so scuffed

theocrystal.set_ability = function(self, card, initial, delay_sprites)
	if (G.GAME.blind_on_deck and G.GAME.blind_on_deck == "Boss") or 
	(G.GAME.modifiers and (G.GAME.modifiers.ccc_bside and G.GAME.modifiers.ccc_bside >= 1)) then
		card.ability.extra.boss = true
	else
		card.ability.extra.boss = false
	end
end

theocrystal.calculate = function(self, card, context)
	if context.setting_blind and not context.blueprint then
		if context.blind.boss 
		or (G.GAME.modifiers and (G.GAME.modifiers.ccc_bside and G.GAME.modifiers.ccc_bside >= 1)) then
			card.ability.extra.boss = true
		else
			card.ability.extra.boss = false
		end
	end
	
	if context.end_of_round and card.ability.extra.boss and not context.blueprint and not context.individual and not context.repetition then
		card.ability.extra.base_probs = card.ability.extra.base_probs + card.ability.extra.base_scale
		local oops_factor = 1
		for i = 1, #G.jokers.cards do
			if G.jokers.cards[i].ability.set == 'Joker' then
				if G.jokers.cards[i].ability.name == 'Oops! All 6s' then
					oops_factor = oops_factor * 2
				end
			end
		end
		for k, v in pairs(G.GAME.probabilities) do
			G.GAME.probabilities[k] = v +
			card.ability.extra.base_scale * oops_factor                    -- this is fragile but should work in normal circumstances
		end
		card_eval_status_text(card, 'extra', nil, nil, nil, { message = "+" .. (card.ability.extra.base_scale*oops_factor), colour = G.C.GREEN })
	end
end

function theocrystal.loc_vars(self, info_queue, card)
	return { vars = { card.ability.extra.scale, card.ability.extra.probs } }
end

return theocrystal
-- endregion Theo Crystal	