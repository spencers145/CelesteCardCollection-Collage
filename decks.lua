--- STEAMODDED HEADER
--- SECONDARY MOD FILE

----------------------------------------------
------------MOD CODE--------------------------

----------- VIRUS DECK -----------------------

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

local trigger_effectRef = Back.trigger_effect

function Back.trigger_effect(self, args)
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

	return trigger_effectRef(self, args)
end

local virus_def = {
	["name"]="Virus Deck",
	["text"]={
		[1]="Each scored card is retriggered",
		[2]="then {C:attention}debuffed{}",
		[3]="until the end of the ante",
	},
}

local virus = SMODS.Deck:new("Virus Deck", "virus", {virus = true, atlas= "b_decks"}, {x = 0, y = 0}, virus_def)
virus:register()

----------- VIRUS DECK END -----------------------

sendDebugMessage("[CCC] Decks loaded")
----------------------------------------------
------------MOD CODE END----------------------