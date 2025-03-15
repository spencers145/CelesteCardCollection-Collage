local trigger_effect_callbacks = {}
local start_run_after_callbacks = {}
-- region virus deck -----------------------

local eval_cardRef = eval_card
function eval_card(card, context) 
	local ret, post = eval_cardRef(card, context)

    if context.repetition_only and context.cardarea == G.play and G.GAME.modifiers.ccc_virus then
		if not ret.seals then
			ret.seals = {
				message = localize('k_again_ex'),
				repetitions = G.GAME.modifiers.ccc_virus,
				card = card
			}
		else
			ret.seals.repetitions = ret.seals.repetitions + G.GAME.modifiers.ccc_virus
		end
    end

	return ret, post
end

local debuff_cardRef = Blind.debuff_card

function Blind.debuff_card(self, card, from_blind)
	if G.GAME.modifiers.ccc_virus and card.ability.played_this_ante then
		card:set_debuff(true)
		return
	end

	debuff_cardRef(self, card, from_blind)
end

function virus_effect(self, args)
    if G.GAME.modifiers.ccc_virus and args.context == 'final_scoring_step' then
		
        G.E_MANAGER:add_event(Event({
            func = (function()
				for _, v in ipairs(G.playing_cards) do
					if G.GAME.modifiers.ccc_virus and v.ability.played_this_ante then
						v:set_debuff(true)
					end
				end
                return true
			end)
		}))
	end
end

table.insert(trigger_effect_callbacks, virus_effect)

local virus = SMODS.Back({
    name = "ccc_Virus Deck",
    key = "virus",
	config = {virus = true},
	pos = {x = 0, y = 0},
	loc_txt = {
        name = "Virus Deck",
        text = {
            "Each played card is retriggered",
            "then {C:red}debuffed{}",
	    "until the end of the ante"
        }
    },
    apply = function(self)
        G.GAME.modifiers.ccc_virus = (G.GAME.modifiers.ccc_virus or 0) + 1
    end,
    atlas= "b_ccc_decks",
	credit = {
		art = "Aurora Aquir",
		code = "Aurora Aquir",
		concept = "Aurora Aquir"
	}
})

-- endregion virus deck-----------------------
-- region summit deck -----------------------

-- now displayed in ease_ante, this was old display in case we wanna switch back (end of round)
-- function summit_effect(self, args)
-- 	if self.effect.config.add_slot_each_ante and G.GAME.round_resets.ante > self.effect.config.add_slot_each_ante and args.context == 'eval' and G.GAME.last_blind and G.GAME.last_blind.boss then
-- 		G.E_MANAGER:add_event(Event({func = function()
-- 			if G.jokers then
-- 				local width = G.round_eval.T.w - 0.51
-- 				local slotAdded = {n=G.UIT.R, config={align = "cm", minw = width}, nodes={
-- 					{n=G.UIT.O, config={object = DynaText({string = {'+1 Joker Slot!'}, colours = {G.C.ORANGE},shadow = true, float = false, y_offset = 0, scale = 0.66, spacing = 0, font = G.LANGUAGES['en-us'].font, pop_in = 0})}}
-- 				}}
-- 				local spacer = {n=G.UIT.R, config={align = "cm", minw = width}, nodes={
-- 					{n=G.UIT.O, config={object = DynaText({string = {'......................................'}, colours = {G.C.WHITE},shadow = true, float = true, y_offset = -30, scale = 0.45, spacing = 13.5, font = G.LANGUAGES['en-us'].font, pop_in = 0})}}
-- 				}}
-- 				G.round_eval:add_child(spacer,G.round_eval:get_UIE_by_ID('base_round_eval'))
-- 				G.round_eval:add_child(slotAdded,G.round_eval:get_UIE_by_ID('base_round_eval'))
						
-- 			end
-- 			return true end }))
-- 	end
-- end

local ease_anteRef = ease_ante
function ease_ante(mod)
	ease_anteRef(mod)
	G.E_MANAGER:add_event(Event({
		trigger = 'immediate',
		func = function () 
			if G.GAME.modifiers.ccc_summit and G.GAME.round_resets.ante % G.GAME.win_ante ~= 0 and G.GAME.round_resets.ante > G.GAME.highest_ante then
						G.jokers.config.card_limit = G.jokers.config.card_limit + G.GAME.modifiers.ccc_summit.add
						G.GAME.highest_ante = G.GAME.round_resets.ante
						attention_text({
							text = "+"..G.GAME.modifiers.ccc_summit.add.." Joker Slot"..(G.GAME.modifiers.ccc_summit.add > 1 and 's' or ''),
							scale = 0.5, 
							hold = 3.3,
							cover = G.jokers.children.area_uibox,
							cover_colour = G.C.CLEAR,
							offset = {x=-2.75,y=1.25}
						})
			end
			return true
		end
	}))

end


--table.insert(trigger_effect_callbacks, summit_effect)

local summit = SMODS.Back({
    name = "ccc_Summit Deck",
    key = "summit",
	config = {joker_slot = -4, add_slot_each_ante = 1},
	pos = {x = 1, y = 0},
	loc_txt = {
        name = "Summit Deck",
        text = {
	"{C:attention}-4{} Joker slots",
            "{C:attention}+1{} Joker slot each Ante",
			"without a {C:red}final boss{}",
	    	"{s:0.75}(if Ante has not been reached before){}"
        }
    },
    apply = function(self)
        G.GAME.modifiers.ccc_summit = G.GAME.modifiers.ccc_summit or {minus = 0, add = 0}
        G.GAME.modifiers.ccc_summit.minus = G.GAME.modifiers.ccc_summit.minus + self.config.joker_slot	-- this isn't used... oops
        G.GAME.modifiers.ccc_summit.add = G.GAME.modifiers.ccc_summit.add + self.config.add_slot_each_ante
    end,
    atlas= "b_ccc_decks",
	credit = {
		art = "Aurora Aquir",
		code = "Aurora Aquir",
		concept = "Aurora Aquir"
	}
})


-- endregion summit deck-----------------------
-- region B-Side deck

local bside = SMODS.Back({
    name = "ccc_B-Side Deck",
    key = "bside",
	config = {everything_is_boss = true},
	pos = {x = 2, y = 0},
	loc_txt = {
        name = "B-Side Deck",
        text = {
		"Every blind is a {C:red}boss blind{}",
		"Start from {C:attention}Ante 0{}",
		"Skipping costs {C:red}$8{} multiplied",
		"by ({C:attention}Current Ante{} + {C:attention}1{})",
        }
    },
    apply = function(self)
        G.GAME.modifiers.ccc_bside = (G.GAME.modifiers.ccc_bside or 0) + 1
    end,
    atlas= "b_ccc_decks",
	credit = {
		art = "Aurora Aquir",
		code = "Aurora Aquir",
		concept = "Bred"
	}
})

local get_type_ref = Blind.get_type
function Blind:get_type()
	local ret = get_type_ref
	if G.GAME.blind_on_deck then 
		return G.GAME.blind_on_deck
	end
	
	return ret
end

local end_round_ref = end_round
function end_round()
	if (G.GAME.modifiers.ccc_bside and G.GAME.modifiers.ccc_bside >= 1) and G.GAME.blind_on_deck ~= "Boss" then 
		-- no money red stake
		if G.GAME.modifiers.no_blind_reward and G.GAME.modifiers.no_blind_reward[G.GAME.blind:get_type()] then G.GAME.blind.dollars = 0 end
	end
	return end_round_ref()
end

-- alter some joker statistics in b-side deck
local sabref = Card.set_ability
function Card:set_ability(center, initial, delay_sprites)
	sabref(self, center, initial, delay_sprites)
	if G.GAME and G.GAME.modifiers and G.GAME.modifiers.ccc_bside and (G.GAME.modifiers.ccc_bside and G.GAME.modifiers.ccc_bside >= 1) and initial then
		local k = self.config.center.key
		if k == 'j_campfire' or k == 'j_throwback' then
			self.ability.extra = self.ability.extra*3
		elseif k == 'j_rocket' then
			self.ability.extra.increase = self.ability.extra.increase/2
		elseif k == 'j_ccc_zipper' then
			self.ability.extra.chips_scale = self.ability.extra.chips_scale*3
		elseif k == 'j_ccc_goldenstrawberry' or k == 'j_ccc_wingedgoldenstrawberry' then
			self.ability.extra.money = math.floor(self.ability.extra.money/2)
		elseif k == 'j_ccc_checkpoint' then
			self.ability.extra.xmult_scale = self.ability.extra.xmult_scale/2
		elseif k == 'j_ccc_theocrystal' then
			self.ability.extra.base_scale = self.ability.extra.base_scale/2
			self.ability.extra.scale = self.ability.extra.scale/2
		end
	end
end

function bside_start_run(self)
	G.GAME.round_resets.blind_choices.ccc_bonus = {}
	if (G.GAME.modifiers.ccc_bside and G.GAME.modifiers.ccc_bside >= 1) then
		G.GAME.round_resets.ante = 0
		G.GAME.round_resets.blind_ante = 0
		G.GAME.round_resets.blind_choices.Small = get_new_boss()
		G.GAME.round_resets.blind_choices.Big = get_new_boss()
		if (G.GAME.modifiers.ccc_bside and G.GAME.modifiers.ccc_bside >= 2) then
			for _, v in ipairs({'Small', 'Big', 'Boss'}) do
				G.GAME.round_resets.blind_choices.ccc_bonus[v] = get_new_boss()
				local i = 0
				while G.GAME.round_resets.blind_choices.ccc_bonus[v] == G.GAME.round_resets.blind_choices[v] and i < 100 do
					G.GAME.round_resets.blind_choices.ccc_bonus[v] = get_new_boss()
					i = i + 1
				end
			end
		end
	end
end

-- overwrite this for double blind
function SMODS.juice_up_blind(blind)
	if (not blind) or (blind == true) then 
		blind = 'blind' 
	end
	local ui_elem = G.HUD_blind:get_UIE_by_ID('HUD_blind_debuff')
	for _, v in ipairs(ui_elem.children) do
		v.children[1]:juice_up(0.3, 0)
	end
	G.GAME[blind]:juice_up()
end

-- handle verdant leaf more specifically
function Blind:ccc_verdant_disable()
	self.disabled = true
	for _, v in ipairs(G.playing_cards) do
		self:debuff_card(v)
	end
end

table.insert(start_run_after_callbacks, bside_start_run)


-- endregion B-Side deck

-- region Heartside Deck

local heartside = SMODS.Back({
    name = "ccc_Heartside Deck",
    key = "heartside",
	config = {all_jokers_modded = true},
	pos = {x = 3, y = 0},
	loc_txt = {
        name = "Heartside Deck",
        text = {
            "Only {C:attention}Modded{} Jokers may appear",
			"{s:0.75}(and maybe {C:legendary,E:1,s:0.75}jimbo{}{s:0.75})"
        }
    },
    apply = function(self)
        G.GAME.modifiers.ccc_heartside = (G.GAME.modifiers.ccc_heartside or 0) + 1
    end,
    atlas= "b_ccc_decks",
	credit = {
		art = "Aurora Aquir",
		code = "Aurora Aquir",
		concept = "Aurora Aquir"
	}
})


function heartside_start_run(self)
	if G.GAME.modifiers.ccc_heartside then
		local jokerPool = {}
		for k, v in pairs(G.P_CENTERS) do
			if v.set == 'Joker' then
				if (not v.mod) then
					G.GAME.banned_keys[k] = true
				end
			end
		end
		G.GAME.pool_flags.heartside_deck = true
	else 
		G.GAME.pool_flags.heartside_deck = false
	end
end

table.insert(start_run_after_callbacks, heartside_start_run)

-- endregion 
-- region HOOKS

local trigger_effectRef = Back.trigger_effect

function Back.trigger_effect(self, args)
	for _, callback in ipairs(trigger_effect_callbacks) do
		callback(self, args)
	end
	return trigger_effectRef(self, args)
end

local start_run_ref = Game.start_run
function Game:start_run(args)
	local ret = start_run_ref(self, args)
	if not args.savetext then
		for _, callback in ipairs(start_run_after_callbacks) do
			callback(self)
		end
	
		self.GAME.highest_ante = self.GAME.highest_ante or 1	-- idk what this does
	end
	return ret
end

-- endregion HOOKS

-- region CREDITS

function G.UIDEF.ccc_generate_credits(credits)
	return {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes={
	{n=G.UIT.R, config={align = "cm"}, nodes={
		{n=G.UIT.O, config={object = DynaText({string = credits and "Art by " or " ", colours = {G.C.WHITE}, shadow = true, offset_y = -0.05, silent = true, spacing = 1, scale = 0.25})}},
		{n=G.UIT.O, config={object = DynaText({string = credits and credits.art or " ", colours = {G.C.CCC_COLOUR}, float = true, shadow = true, offset_y = -0.05, silent = true, spacing = 1, scale = 0.25})}}}},
	{n=G.UIT.R, config={align = "cm"}, nodes={
		{n=G.UIT.O, config={object = DynaText({string = credits and "Code by " or "", colours = {G.C.WHITE}, shadow = true, offset_y = -0.05, silent = true, spacing = 1, scale = 0.25})}},
		{n=G.UIT.O, config={object = DynaText({string = credits and credits.code or G.GAME.viewed_back.effect.center.mod and "Modded Deck" or "Vanilla Deck", colours = {credits and G.C.CCC_COLOUR or G.C.DARK_EDITION}, float = true, shadow = true, offset_y = -0.05, silent = true, spacing = 1, scale = 0.25})}}}},
	{n=G.UIT.R, config={align = "cm"}, nodes={
		{n=G.UIT.O, config={object = DynaText({string = credits and "Concept by " or " ", colours = {G.C.WHITE}, shadow = true, offset_y = -0.05, silent = true, spacing = 1, scale = 0.25})}},
		{n=G.UIT.O, config={object = DynaText({string = credits and credits.concept or " ", colours = {G.C.CCC_COLOUR }, float = true, shadow = true, offset_y = -0.05, silent = true, spacing = 1, scale = 0.25})}}}},}}
end

function ccc_generate_deck_credit_payload()
	local obj = Moveable()
	obj= UIBox{
		definition = G.UIDEF.ccc_generate_credits(G.GAME.viewed_back.effect.center.credit),
		config = {offset = {x=0,y=0}, align = 'cm'}
	}

	local e = {n=G.UIT.R, config={align = "cm"}, nodes={
		{n=G.UIT.O, config={id = G.GAME.viewed_back.name, func = 'RUN_SETUP_check_back_credits', object = obj}}
	}}  
	return e
end
function G.FUNCS.RUN_SETUP_check_back_credits(e)
	if G.GAME.viewed_back.name ~= e.config.id then 
		--removes the UI from the previously selected back and adds the new one
		if e.config.object then e.config.object:remove() end 
		e.config.object = UIBox{
			definition = G.UIDEF.ccc_generate_credits(G.GAME.viewed_back.effect.center.credit),
			config = {offset = {x=0,y=0}, align = 'cm', parent = e}
		}
		e.config.id = G.GAME.viewed_back.name
		e.config.object:recalculate()
	end
end

-- endregion CREDITS
sendDebugMessage("[CCC] Decks loaded")
----------------------------------------------
------------MOD CODE END----------------------
