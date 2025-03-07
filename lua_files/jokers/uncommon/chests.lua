-- region Huge Mess: Chests

local chests = {
	name = "ccc_Huge Mess: Chests",
	key = "chests",
	config = { extra = { mult = 0, mult_scale = 3 } },
	pos = { x = 1, y = 3 },
	loc_txt = {
		name = 'Huge Mess: Chests',
		text = {
			"When played hand contains a",
			"{C:attention}Three of a Kind{}, gains",
			"{C:mult}+#2#{} Mult for each possible",
			"{C:attention}Pair{} held in hand",
			"{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
		}
	},
	rarity = 2,
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "j_ccc_jokers",
	credit = {
		art = "toneblock",
		code = "toneblock",
		concept = "Bred"
	},
    description = "When played hand contains a Three of a Kind, gains +3 Mult for each possible Pair held in hand."
}

chests.calculate = function(self, card, context)
	if context.before and not context.blueprint then
		card.boxes_rank_array = {}
		card.boxes_card_array_length = 0
		card.boxes_pair_amounts = 0
		card.boxes_card_pair_candidate = 0
	end

	if context.individual and context.poker_hands ~= nil and ((next(context.poker_hands['Three of a Kind']) or next(context.poker_hands['Full House']) or next(context.poker_hands['Four of a Kind']) or next(context.poker_hands['Five of a Kind']) or next(context.poker_hands['Flush Five']))) and not context.blueprint then
		if context.cardarea == G.hand then
			card.boxes_card_array_length = card.boxes_card_array_length + 1
			card.boxes_rank_array[card.boxes_card_array_length] = context.other_card:get_id()
		end
	end

	if context.joker_main and not context.blueprint then
		for v = 1, 13 do
			card.boxes_card_pair_candidate = 0
			for i = 1, card.boxes_card_array_length do
				if card.boxes_rank_array[i] == v + 1 then
					card.boxes_card_pair_candidate = card.boxes_card_pair_candidate + 1
				end
			end
			card.boxes_pair_amounts = card.boxes_pair_amounts +
			((card.boxes_card_pair_candidate - 1) * (card.boxes_card_pair_candidate)) / 2
		end
		if card.boxes_pair_amounts > 0 then
			card.ability.extra.mult = card.ability.extra.mult + (card.boxes_pair_amounts) * card.ability.extra
			.mult_scale
			card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Upgrade!", colour = G.C.MULT })
		end
	end
	if context.joker_main then
		if card.ability.extra.mult ~= 0 then
			return {
				message = localize {
					type = 'variable',
					key = 'a_mult',
					vars = { card.ability.extra.mult }
				},
				mult_mod = card.ability.extra.mult
			}
		end
	end
end

function chests.loc_vars(self, info_queue, card)
	return { vars = { card.ability.extra.mult, card.ability.extra.mult_scale } }
end

return chests
-- endregion Huge Mess: Chests