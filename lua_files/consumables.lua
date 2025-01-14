-- region Crystallic

local crystallic = SMODS.Consumable({
	name = "ccc_Crystallic",
	key = "crystallic",
	set = "Spectral",
	config = {extra = {destroy = 2, add = 2}},
	pos = {x = 0, y = 0},
	loc_txt = {
		name = 'Crystallic',
		text = {
			"Destroys {C:attention}#1#{} random cards in",
			"hand, then adds {C:dark_edition}Mirrored{} to",
			"{C:attention}#2#{} random cards in hand",
		}
	},
	cost = 4,
	discovered = true,
	atlas = "c_ccc_consumables",
	credit = {
		art = "bein",
		code = "toneblock",
		concept = "Fytos"
	}
})

function crystallic.can_use(self, card)
	if G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.PLANET_PACK then
		if #G.hand.cards > 1 then
			return true
		end
	end
end

function crystallic.use(self, card, area, copier)
	local used_card = copier or card
	local temp_hand = {}
	local indexes_to_remove = {}
	local destroyed_cards = {}
	local mirrored_cards = {}
	for k, v in ipairs(G.hand.cards) do temp_hand[#temp_hand+1] = v end
	table.sort(temp_hand, function (a, b) return not a.playing_card or not b.playing_card or a.playing_card < b.playing_card end)
	pseudoshuffle(temp_hand, pseudoseed('crystallic'))

	for i = 1, card.ability.extra.destroy do 
		destroyed_cards[#destroyed_cards+1] = table.remove(temp_hand, 1)
	end
	for i = 1, card.ability.extra.add do 
		mirrored_cards[#mirrored_cards+1] = table.remove(temp_hand, 1)
	end

	G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
		play_sound('tarot1')
                used_card:juice_up(0.3, 0.5)
                return true end 
	}))
	G.E_MANAGER:add_event(Event({
		trigger = 'after',
		delay = 0.1,
		func = function() 
			for i=#destroyed_cards, 1, -1 do
				local _card = destroyed_cards[i]
				if _card.ability.name == 'Glass Card' then 
					_card:shatter()
				else
					_card:start_dissolve(nil, i == #destroyed_cards)
				end
			end
		return true end 
	}))
	delay(0.5)
	for i = 1, #mirrored_cards do
		local _card = mirrored_cards[i]
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.15,
			func = function()
				_card:set_edition({ccc_mirrored = true})
				return true
			end,
		}))
	end
end

function crystallic.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = G.P_CENTERS.e_ccc_mirrored
	return {vars = {card.ability.extra.destroy, card.ability.extra.add}}
end

function crystallic.in_pool(self)
	if ccc_find_mirror() then
		return true
	end
	return false
end

-- endregion Crystallic
