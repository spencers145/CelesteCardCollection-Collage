-- region Kevin

local kevin = {
	name = "ccc_Kevin",
	key = "kevin",
	config = {},
	pos = { x = 8, y = 3 },
	loc_txt = {
		name = 'Kevin',
		text = {
			"Scoring {C:attention}face cards{} act",
			"as a copy of the",
			"{C:attention}rightmost{} played card",
		}
	},
	rarity = 3,
	cost = 8,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Gappie"
	},
    description = "Scoring face cards act as a copy of the rightmost played card"
}

local evalcard_ref = eval_card
function eval_card(card, context)
	local ccard = card
	
	if context.cardarea == G.play 
	and card.playing_card and card:is_face() 
	and #SMODS.find_card('j_ccc_kevin') >= 1 
	and #G.play.cards >= 1 then
		ccard = G.play.cards[#G.play.cards]
	end
	return evalcard_ref(ccard, context)
end

return kevin
-- endregion Kevin