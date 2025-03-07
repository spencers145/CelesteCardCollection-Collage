-- region Event Horizon

local eventhorizon = {
	name = "ccc_Event Horizon",
	key = "eventhorizon",
	config = { extra = { uses = 0 } },
	pos = { x = 8, y = 4 },
	loc_txt = {
		name = 'Event Horizon',
		text = {
			"Every {C:attention}5th{} {C:planet}Planet{} card",
			"used acts as a",
			"{C:legendary,E:1,S:1.1}Black Hole{}",
			"{C:inactive}(Currently {C:attention}#1#{C:inactive}/{C:attention}5{C:inactive})"
		}
	},
	rarity = 2,
	cost = 7,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "sunsetquasar + toneblock",
		code = "toneblock",
		concept = "Fytos"
	},
    description = "Every 5th Planet card used acts as a Black Hole"
}

eventhorizon.calculate = function(self, card, context)
	if context.using_consumeable then
		if context.consumeable.ability.set == 'Planet' and not context.blueprint then
			if card.ability.extra.uses < 3 then
				return {
					G.E_MANAGER:add_event(Event({
						trigger = 'after',
						func = function()
							card.ability.extra.uses = card.ability.extra.uses + 1
							card_eval_status_text(card, 'extra', nil, nil, nil,
								{ message = card.ability.extra.uses .. "/5", colour = G.C.FILTER })
							return true
						end
					})),
				}
			end
			if card.ability.extra.uses == 3 then
				return {
					G.E_MANAGER:add_event(Event({
						trigger = 'after',
						func = function()
							card.ability.extra.uses = card.ability.extra.uses + 1
							card_eval_status_text(card, 'extra', nil, nil, nil,
								{ message = localize('k_active_ex'), colour = G.C.FILTER })
							ccc_GLOBAL_eventhorizon_override = (0 or ccc_GLOBAL_eventhorizon_override) + 1
							return true
						end
					})),
				}
			end
			if card.ability.extra.uses == 4 then
				card:juice_up()
				card.ability.extra.uses = 0
				return {
					G.E_MANAGER:add_event(Event({
						trigger = 'after',
						func = function()
							if card.ability.extra.uses == 0 then
								ccc_GLOBAL_eventhorizon_override = ccc_GLOBAL_eventhorizon_override - 1
							end
							card_eval_status_text(card, 'extra', nil, nil, nil,
								{ message = localize('k_reset'), colour = G.C.FILTER })
							return true
						end
					})),
				}
			end
		end
	end
end

function eventhorizon.loc_vars(self, info_queue, card)
	info_queue[#info_queue + 1] = G.P_CENTERS.c_black_hole
	return { vars = { card.ability.extra.uses } }
end

return eventhorizon
-- endregion Event Horizon