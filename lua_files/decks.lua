local trigger_effect_callbacks = {}

-- region virus deck -----------------------

local eval_cardRef = eval_card
function eval_card(card, context) 
	local ret = eval_cardRef(card, context)

    if context.repetition_only and context.cardarea == G.play and G.GAME.selected_back.effect.config.virus then
		if not ret.seals then
			ret.seals = {
				message = localize('k_again_ex'),
				repetitions = 1,
				card = card
			}
		else
			ret.seals.repetitions = ret.seals.repetitions + 1
		end
    end

	return ret
end

local debuff_cardRef = Blind.debuff_card

function Blind.debuff_card(self, card, from_blind)
	if G.GAME.selected_back.effect.config.virus and card.ability.played_this_ante then
		card:set_debuff(true)
		return
	end

	debuff_cardRef(self, card, from_blind)
end

function virus_effect(self, args)
    if G.GAME.selected_back.effect.config.virus and args.context == 'final_scoring_step' then
		
        G.E_MANAGER:add_event(Event({
            func = (function()
				for _, v in ipairs(G.playing_cards) do
					if G.GAME.selected_back.effect.config.virus and v.ability.played_this_ante then
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
    name = "Virus Deck",
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
    atlas= "b_ccc_decks"
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
			if G.GAME.selected_back.effect.config.add_slot_each_ante and G.GAME.round_resets.ante > G.GAME.selected_back.effect.config.add_slot_each_ante then
			
				
						G.jokers.config.card_limit = G.jokers.config.card_limit + 1
						G.GAME.selected_back.effect.config.add_slot_each_ante = G.GAME.selected_back.effect.config.add_slot_each_ante + 1
						
						attention_text({
							text = "+1 Joker Slot",
							scale = 0.5, 
							hold = 3.3,
							cover = G.jokers.children.area_uibox,
							cover_colour = G.C.CLEAR,
							offset = {x=-3.25,y=1.25}
						})
			end

			play_sound('generic1')
			return true
		end
	}))

end


table.insert(trigger_effect_callbacks, summit_effect)

local summit = SMODS.Back({
    name = "Summit Deck",
    key = "summit",
	config = {joker_slot = -5, add_slot_each_ante = 1},
	pos = {x = 1, y = 0},
	loc_txt = {
        name = "Summit Deck",
        text = {
            "Start with {C:attention}0{} Joker Slots",
            "{C:attention}+1{} Joker slot each Ante",
	    "{s:0.75}(if Ante has not been reached before){}"
        }
    },
    atlas= "b_ccc_decks"
})

-- endregion summit deck-----------------------

-- region HOOKS

local trigger_effectRef = Back.trigger_effect

function Back.trigger_effect(self, args)
	for _, callback in ipairs(trigger_effect_callbacks) do
		callback(self, args)
	end
	return trigger_effectRef(self, args)
end

-- endregion HOOKS

sendDebugMessage("[CCC] Decks loaded")
----------------------------------------------
------------MOD CODE END----------------------