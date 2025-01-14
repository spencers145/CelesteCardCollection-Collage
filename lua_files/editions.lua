-- region Mirrored

SMODS.Shader({key = 'mirrored', path = "mirrored.fs"})

local mirrored = SMODS.Edition({
    key = "mirrored",
    loc_txt = {
        name = "Mirrored",
        label = "Mirrored",
        text = {
		"{C:attention}Retrigger{} this card",
		"If a {C:attention}Mirror{} is not",
		"present, {C:red}self-destructs{}",
		"at end of round"
        }
    },
    discovered = true,
    unlocked = true,
    disable_base_shader = true,
    disable_shadow = true,
    shader = 'mirrored',
    config = {},
    in_shop = false,
    calculate = function(self, card, context)
	-- yeah ngl i took this directly from ortalab... i hope this works?
	if context.repetition_only or (context.retrigger_joker_check and context.other_card == card) then
		return {
			repetitions = 1,
			card = card,
			colour = G.C.FILTER,
			message = localize('k_again_ex')
		}     
	end
    end,
})

function ccc_find_mirror()
	local mirrors = {
		'j_ccc_ominousmirror',
		'j_ccc_badeline',
		'j_ccc_partofyou',
	}
	for i = 1, #mirrors do
		if next(SMODS.find_card(mirrors[i])) then
			return true
		end
	end
	return false
end

local endroundref = end_round
function end_round()
	local destroyed_cards = {}
	for i, v in ipairs(G.playing_cards) do
		if v.edition and v.edition.ccc_mirrored then
			if not ccc_find_mirror() then
				destroyed_cards[#destroyed_cards+1] = v
			end
		end
	end
	for j=1, #G.jokers.cards do
		eval_card(G.jokers.cards[j], {cardarea = G.jokers, remove_playing_cards = true, removed = cards_destroyed})
	end
	for i=1, #destroyed_cards do
		G.E_MANAGER:add_event(Event({
			func = function()
				if destroyed_cards[i].ability.name == 'Glass Card' then 
					destroyed_cards[i]:shatter()
				else
					destroyed_cards[i]:start_dissolve()
				end
			return true
			end
		}))
	end
	endroundref()
end
-- endregion Mirrored