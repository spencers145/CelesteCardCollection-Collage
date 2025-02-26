-- region Snow

local snow = SMODS.Blind{
	name = "ccc_The Snow",
	slug = "snow", 
	key = 'snow',
	atlas = 'bl_ccc_blinds',
	pos = {x = 0, y = 0},
	dollars = 5, 
	mult = 2, 
	vars = {}, 
	debuff = {},
	discovered = true,
	boss = {min = 2, max = 10},
	boss_colour = HEX('d8d8d8'),
	loc_txt = {
        	['default'] = {
			name = "The Snow",
			text = {
				"All Clubs are",
				"drawn face down"
			}
		}
	}
}

-- Snow, Stone, Crystal and Berry use lovely to keep suits flipped

snow.disable = function(self)
	for i = 1, #G.hand.cards do
		if G.hand.cards[i].facing == 'back' then
			G.hand.cards[i]:flip()
		end
	end
	for k, v in pairs(G.playing_cards) do
		v.ability.wheel_flipped = nil
	end
end

snow.stay_flipped = function(self, area, card)
	if card:is_suit('Clubs', true) then
		return true
	end
end

-- endregion Snow

-- region Stone

local stone = SMODS.Blind{
	name = "ccc_The Stone",
	slug = "stone", 
	key = 'stone',
	atlas = 'bl_ccc_blinds',
	pos = {x = 0, y = 1},
	dollars = 5, 
	mult = 2, 
	vars = {}, 
	debuff = {},
	discovered = true,
	boss = {min = 2, max = 10},
	boss_colour = HEX('575f7d'),
	loc_txt = {
        	['default'] = {
			name = "The Stone",
			text = {
				"All Spades are",
				"drawn face down"
			}
		}
	}
}

stone.disable = function(self)
	for i = 1, #G.hand.cards do
		if G.hand.cards[i].facing == 'back' then
			G.hand.cards[i]:flip()
		end
	end
	for k, v in pairs(G.playing_cards) do
		v.ability.wheel_flipped = nil
	end
end

stone.stay_flipped = function(self, area, card)
	if card:is_suit('Spades', true) then
		return true
	end
end

-- endregion Stone

-- region Crystal

local crystal = SMODS.Blind{
	name = "ccc_The Crystal",
	slug = "crystal", 
	key = 'crystal',
	atlas = 'bl_ccc_blinds',
	pos = {x = 0, y = 2},
	dollars = 5, 
	mult = 2, 
	vars = {}, 
	debuff = {},
	discovered = true,
	boss = {min = 2, max = 10},
	boss_colour = HEX('fd7a30'),
	loc_txt = {
        	['default'] = {
			name = "The Crystal",
			text = {
				"All Diamonds are",
				"drawn face down"
			}
		}
	}
}

crystal.disable = function(self)
	for i = 1, #G.hand.cards do
		if G.hand.cards[i].facing == 'back' then
			G.hand.cards[i]:flip()
		end
	end
	for k, v in pairs(G.playing_cards) do
		v.ability.wheel_flipped = nil
	end
end

crystal.stay_flipped = function(self, area, card)
	if card:is_suit('Diamonds', true) then
		return true
	end
end

-- endregion Crystal

-- region Berry

local berry = SMODS.Blind{
	name = "ccc_The Berry",
	slug = "berry", 
	key = 'berry',
	atlas = 'bl_ccc_blinds',
	pos = {x = 0, y = 3},
	dollars = 5, 
	mult = 2, 
	vars = {}, 
	debuff = {},
	discovered = true,
	boss = {min = 2, max = 10},
	boss_colour = HEX('f3639b'),
	loc_txt = {
        	['default'] = {
			name = "The Berry",
			text = {
				"All Hearts are",
				"drawn face down"
			}
		}
	}
}

berry.disable = function(self)
	for i = 1, #G.hand.cards do
		if G.hand.cards[i].facing == 'back' then
			G.hand.cards[i]:flip()
		end
	end
	for k, v in pairs(G.playing_cards) do
		v.ability.wheel_flipped = nil
	end
end

berry.stay_flipped = function(self, area, card)
	if card:is_suit('Hearts', true) then
		return true
	end
end

-- endregion Berry

-- region Fallacy

local fallacy = SMODS.Blind{
	name = "ccc_The Fallacy",
	slug = "fallacy", 
	key = 'fallacy',
	atlas = 'bl_ccc_blinds',
	pos = {x = 0, y = 4},
	dollars = 5, 
	mult = 2, 
	vars = {}, 
	debuff = {},
	discovered = true,
	boss = {min = 3, max = 10},
	boss_colour = HEX('2f4063'),
	loc_txt = {
        	['default'] = {
			name = "The Fallacy",
			text = {
				"Playing cards lose",
				"a rank when played"
			}
		}
	}
}

fallacy.press_play = function(self)
	G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
        for i = 1, #G.play.cards do
		G.E_MANAGER:add_event(Event({func = function()
			local card = G.play.cards[i]
			local new_rank = 'Ace'
			for _, v in pairs(SMODS.Ranks) do
				for __, _v in ipairs(v.next) do
					if card.base.value == _v then
						new_rank = v.key
						break
					end
				end
			end
                        assert(SMODS.change_base(card, nil, new_rank))
			card:juice_up()
			play_sound('tarot1')
		return true end }))
		delay(0.23)
        end
        return true end }))
	G.GAME.blind.triggered = true
        return true
end


