-- region Collapsing Bridge

local collapsingbridge = {
	name = "ccc_Collapsing Bridge",
	key = "collapsingbridge",
	config = { extra = { xmult = 5, prob_success = 5 } },
	pos = { x = 8, y = 1 },
	loc_txt = {
		name = 'Collapsing Bridge',
		text = {
			"{X:mult,C:white} X#2# {} Mult when played hand",
			"contains a {C:attention}Straight{}",
			"All {C:attention}played{} cards have a {C:green}#1# in #3#{}",
			"chance of being {C:red}destroyed{}"
		}
	},
	rarity = 3,
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
    description = "X5 Mult when played hand contains a Straight. All played cards have a 1 in 5 chance of being destroyed"
}

collapsingbridge.calculate = function(self, card, context)
	if context.joker_main then
		if next(context.poker_hands['Straight']) then
			return {
				message = localize {
					type = 'variable',
					key = 'a_xmult',
					vars = { card.ability.extra.xmult }
				},
				Xmult_mod = card.ability.extra.xmult
			}
		end
	end

	if context.destroying_card and (context.cardarea == G.play or context.cardarea == "unscored") then
		if pseudorandom('bridge') < G.GAME.probabilities.normal / card.ability.extra.prob_success then
			return { remove = true }
		end
	end
end

function collapsingbridge.loc_vars(self, info_queue, card)
	return { vars = { '' .. (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.xmult, card.ability.extra.prob_success } }
end

return collapsingbridge
-- endregion Collapsing Bridge