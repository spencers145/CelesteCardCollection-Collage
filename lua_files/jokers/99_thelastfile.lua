
local lastjoker = {
	name = "ccc_thelastjoker",
	key = "thelastjoker",
    config = {extra = {what = 0},},
	pos = {x = 0, y = 9},
	loc_txt = {
        name = 'One Last Thing',
        text = {
			"???",
        }
    },
	rarity = 'ccc_what',
	cost = 33,
    no_collection = true,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "???",
		code = "???",
		concept = "???"
	},
    in_pool = function(self, args) 
        return (SMODS.find_card("j_ccc_crystalheart") ~= nil and SMODS.find_card("j_ccc_madeline") ~= nil and SMODS.find_card("j_ccc_eventhorizon") and SMODS.find_card("j_ccc_lettinggo") and SMODS.find_card("j_ccc_bunnyhop") and #G.deck.cards)
    end,
    add_to_deck = function(self, card, from_debuff)
        win_game()
    end
}

return lastjoker