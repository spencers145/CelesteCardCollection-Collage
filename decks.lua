--- STEAMODDED HEADER
--- SECONDARY MOD FILE

----------------------------------------------
------------MOD CODE--------------------------

----------- Definitions ----------------------

local virus_def = {
	["name"]="Virus Deck",
	["text"]={
		[1]="Each played card is retriggered",
		[2]="then {C:red}debuffed{}",
		[3]="until the end of the ante",
	},
}

local summit_def = {
	["name"]="Summit Deck",
	["text"]={
		[1]="Start with {C:attention}1{} Joker Slot",
		[2]="{C:attention}+1{} Joker slot each Ante",
		[3]="{s:0.75}(if Ante has not been reached before){}"
	},
}

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

local virus = SMODS.Deck:new("Virus Deck", "virus", {virus = true, atlas= "b_cccdecks"}, {x = 0, y = 0}, virus_def)
virus:register()

-- endregion virus deck-----------------------
-- region summit deck -----------------------

function summit_effect(self, args)
	if self.effect.config.add_slot_each_ante and G.GAME.round_resets.ante > self.effect.config.add_slot_each_ante and args.context == 'eval' and G.GAME.last_blind and G.GAME.last_blind.boss then
		G.E_MANAGER:add_event(Event({func = function()
			if G.jokers then
				G.jokers.config.card_limit = G.jokers.config.card_limit + 1
				self.effect.config.add_slot_each_ante = self.effect.config.add_slot_each_ante + 1

				local width = G.round_eval.T.w - 0.51
				local slotAdded = {n=G.UIT.R, config={align = "cm", minw = width}, nodes={
					{n=G.UIT.O, config={object = DynaText({string = {'+1 Joker Slot!'}, colours = {G.C.ORANGE},shadow = true, float = false, y_offset = 0, scale = 0.66, spacing = 0, font = G.LANGUAGES['en-us'].font, pop_in = 0})}}
				}}
				local spacer = {n=G.UIT.R, config={align = "cm", minw = width}, nodes={
					{n=G.UIT.O, config={object = DynaText({string = {'......................................'}, colours = {G.C.WHITE},shadow = true, float = true, y_offset = -30, scale = 0.45, spacing = 13.5, font = G.LANGUAGES['en-us'].font, pop_in = 0})}}
				}}
				G.round_eval:add_child(spacer,G.round_eval:get_UIE_by_ID('base_round_eval'))
				G.round_eval:add_child(slotAdded,G.round_eval:get_UIE_by_ID('base_round_eval'))
                        
			end
			return true end }))
    end
end

table.insert(trigger_effect_callbacks, summit_effect)

local summit = SMODS.Deck:new("Summit Deck", "summit", {joker_slot = -4, add_slot_each_ante = 1, atlas= "b_cccdecks"}, {x = 1, y = 0}, summit_def)
summit:register()

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