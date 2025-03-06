CardSleeves.Sleeve({
	key = "virus_sleeve",
	name = "ccc_Virus Sleeve",
	atlas = "s_ccc_sleeves",
	pos = { x = 0, y = 0 },
	config = {virus = true},
	unlocked = true,
	loc_txt = {
		name = "Virus Sleeve",
		text = {
			"Each played card is retriggered",
			"then {C:red}debuffed{}",
			"until the end of the ante"
		}
	},
	unlock_condition = { deck = "ccc_Virus Deck", stake = 1 },
	loc_vars = function(self)
		return { vars = {} }
	end,
	trigger_effect = function(self, args) end,
	apply = function(self)
		G.GAME.modifiers.ccc_virus = (G.GAME.modifiers.ccc_virus or 0) + 1
	end,
})

CardSleeves.Sleeve({
	key = "summit_sleeve",
	name = "ccc_Summit Sleeve",
	atlas = "s_ccc_sleeves",
	pos = { x = 1, y = 0 },
	config = {joker_slot = -4, add_slot_each_ante = 1},
	unlocked = true,
	loc_txt = {
		name = "Summit Sleeve",
		text = {
			"{C:attention}-4{} Joker slots",
			"{C:attention}+1{} Joker slot each Ante",
			"without a {C:red}final boss{}",
		    	"{s:0.75}(if Ante has not been reached before){}"
		}
	},
	unlock_condition = { deck = "ccc_Summit Deck", stake = 1 },
	loc_vars = function(self)
		return { vars = {} }
	end,
	trigger_effect = function(self, args) end,
	apply = function(self)
		G.GAME.modifiers.ccc_summit = G.GAME.modifiers.ccc_summit or {minus = 0, add = 0}
		G.GAME.modifiers.ccc_summit.minus = G.GAME.modifiers.ccc_summit.minus + self.config.joker_slot	-- this isn't used... oops
		G.GAME.modifiers.ccc_summit.add = G.GAME.modifiers.ccc_summit.add + self.config.add_slot_each_ante

		G.GAME.starting_params.joker_slots = G.GAME.starting_params.joker_slots + self.config.joker_slot	-- needs to be done for sleeves but NOT for decks
	end,
})

CardSleeves.Sleeve({
	key = "bside_sleeve",
	name = "ccc_B-Side Sleeve",
	atlas = "s_ccc_sleeves",
	pos = { x = 2, y = 0 },
	config = {everything_is_boss = true},
	unlocked = true,
	loc_txt = {
		name = "B-Side Deck",
		text = {
			"Every blind is a {C:red}boss blind{}",
			"Start from {C:attention}Ante 0{}",
			"Skipping costs {C:red}$8{} multiplied",
			"by ({C:attention}Current Ante{} + {C:attention}1{})",
		}
	},
	unlock_condition = { deck = "ccc_B-Side Deck", stake = 1 },
	loc_vars = function(self)
		return { vars = {} }
	end,
	trigger_effect = function(self, args) end,
	apply = function(self)
		G.GAME.modifiers.ccc_bside = (G.GAME.modifiers.ccc_bside or 0) + 1
	end,
})

CardSleeves.Sleeve({
	key = "heartside_sleeve",
	name = "ccc_Heartside Sleeve",
	atlas = "s_ccc_sleeves",
	pos = { x = 3, y = 0 },
	config = {all_jokers_modded = true},
	unlocked = true,
	loc_txt = {
		name = "Heartside Deck",
		text = {
			"Only {C:attention}Modded{} Jokers may appear",
			"{s:0.75}(and maybe {C:legendary,E:1,s:0.75}jimbo{}{s:0.75})"
		}
	},
	unlock_condition = { deck = "ccc_Heartside Deck", stake = 1 },
	loc_vars = function(self)
		return { vars = {} }
	end,
	trigger_effect = function(self, args) end,
	apply = function(self)
		G.GAME.modifiers.ccc_heartside = (G.GAME.modifiers.ccc_heartside or 0) + 1
	end,
})

sendDebugMessage("[CCC] Sleeves loaded")
----------------------------------------------
------------MOD CODE END----------------------
