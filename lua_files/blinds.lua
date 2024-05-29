-- region Snow

local snow = SMODS.Blind{
	name = "The Snow",
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

-- endregion Snow

-- region Stone

local stone = SMODS.Blind{
	name = "The Stone",
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

-- endregion Stone

-- region Crystal

local crystal = SMODS.Blind{
	name = "The Crystal",
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

-- endregion Crystal

-- region Berry

local berry = SMODS.Blind{
	name = "The Berry",
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

-- endregion Berry