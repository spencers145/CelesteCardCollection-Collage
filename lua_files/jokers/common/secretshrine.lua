-- region Secret Shrine

local secretshrine = {
	name = "ccc_Secret Shrine",
	key = "secretshrine",
	config = { extra = { seven_tally = 4, factor = 3 } },
	pos = { x = 6, y = 5 },
	loc_txt = {
		name = 'Secret Shrine',
		text = {
			"Gives {C:mult}+#2#{} Mult for",
			"each {C:attention}7{} in {C:attention}full deck{}",
			"{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult){}"
		}
	},
	rarity = 1,
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "9Ts",
		code = "toneblock",
		concept = "Aurora Aquir"
	},
	description = "Gives +4 Mult for each 7 in full deck"
}

-- lovely used to update seven_tally

secretshrine.calculate = function(self, card, context)
	if context.joker_main then
		if card.ability.extra.seven_tally ~= 0 then
			return {
				message = localize {
					type = 'variable',
					key = 'a_mult',
					vars = { card.ability.extra.factor * card.ability.extra.seven_tally }
				},
				mult_mod = card.ability.extra.factor * card.ability.extra.seven_tally
			}
		end
	end
end

function secretshrine.loc_vars(self, info_queue, card)
	return { vars = { card.ability.extra.factor * card.ability.extra.seven_tally, card.ability.extra.factor } }
end

return secretshrine
-- endregion Secret Shrine