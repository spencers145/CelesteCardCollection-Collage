--region CREDITS
-- Code to allow for credits

local generate_UIBox_ability_table_ref = Card.generate_UIBox_ability_table

function Card.generate_UIBox_ability_table(self)
	local AUT = generate_UIBox_ability_table_ref(self)
	AUT.mod_credit = self.config.center.credit or nil 
	return AUT
end

-- local card_h_popup_ref = G.UIDEF.card_h_popup

-- function G.UIDEF.card_h_popup(card)
-- 	local ret = card_h_popup_ref(card)
	
--     if card.ability_UIBox_table and ret.nodes then
-- 		local AUT = card.ability_UIBox_table
-- 		if AUT.mod_credit then
-- 			local main = ret.nodes[1]
-- 			local thing = {n=G.UIT.ROOT,  config={align = "cm", r = 0.1, padding = 0.05, emboss = 0.05}, nodes={
-- 				{n=G.UIT.R, config={align = "cm", colour = lighten(G.C.JOKER_GREY, 0.5), r = 0.1, padding = 0.05, emboss = 0.05}, nodes={
-- 				{n=G.UIT.R, config={align = "cm", colour = lighten(G.C.GREY, 0.15), r = 0.1, padding=0.2}, nodes={
-- 				{n=G.UIT.R, config={align = "cm"}, nodes={
-- 					{n=G.UIT.O, config={object = DynaText({string = "Art by ", colours = {G.C.WHITE}, shadow = true, offset_y = -0.05, silent = true, spacing = 1, scale = 0.33})}},
-- 					{n=G.UIT.O, config={object = DynaText({string = AUT.mod_credit.art, colours = {G.C.CCC_COLOUR}, float = true, shadow = true, offset_y = -0.05, silent = true, spacing = 1, scale = 0.33})}}}},
-- 				{n=G.UIT.R, config={align = "cm"}, nodes={
-- 					{n=G.UIT.O, config={object = DynaText({string = "Code by ", colours = {G.C.WHITE}, shadow = true, offset_y = -0.05, silent = true, spacing = 1, scale = 0.33})}},
-- 					{n=G.UIT.O, config={object = DynaText({string = AUT.mod_credit.code, colours = {G.C.CCC_COLOUR }, float = true, shadow = true, offset_y = -0.05, silent = true, spacing = 1, scale = 0.33})}}}},
-- 				{n=G.UIT.R, config={align = "cm"}, nodes={
-- 					{n=G.UIT.O, config={object = DynaText({string = "Concept by ", colours = {G.C.WHITE}, shadow = true, offset_y = -0.05, silent = true, spacing = 1, scale = 0.33})}},
-- 					{n=G.UIT.O, config={object = DynaText({string = AUT.mod_credit.concept, colours = {G.C.CCC_COLOUR }, float = true, shadow = true, offset_y = -0.05, silent = true, spacing = 1, scale = 0.33})}}}},
-- 			}}}}}}

-- 			main.children = main.children or {}
-- 			main.children.credits = UIBox{
-- 				definition = thing,
-- 				config = {offset = {x=  0.03,y=0}, align = 'cr', parent = main}
-- 			}
-- 			main.children.credits:align_to_major()
-- 		end
-- 	end
-- 	return ret 
-- end

--endregion CREDITS


-- region Feather

local feather = SMODS.Joker({
	name = "Feather",
	key = "feather",
    config = {},
	pos = {x = 0, y = 0},
	loc_txt = {
        name = 'Feather',
        text = {
	"Gains {X:mult,C:white} X0.05 {} Mult for",
	"each card {C:attention}drawn{} from",
	"deck during round",
	"{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult){}"
        }
    },
	rarity = 2,
	cost = 6,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "toneblock",
		code = "toneblock",
		concept = "toneblock"
	}
})

feather.calculate = function(self, card, context)
        if context.joker_main then
                            return {
                                message = localize{type='variable',key='a_xmult',vars={1+(0.05*(#G.playing_cards - #G.deck.cards))}},
                                Xmult_mod = 1+(0.05*(#G.playing_cards - #G.deck.cards)), 
                                colour = G.C.MULT
                            }
        end
end

function feather.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra, 1+(0.05*((G.deck and G.deck.cards and G.playing_cards) and #G.playing_cards - #G.deck.cards or 0))}}
end

--endregion Feather

-- region Zipper

local zipper = SMODS.Joker({
	name = "Zipper",
	key = "zipper",
    config = {extra = {chips = 0}},
	pos = {x = 4, y = 0},
	loc_txt = {
        name = 'Zipper',
        text = {
	"Gains {C:chips}+30{} Chips for each",
	"{C:attention}Blind{} skipped this run",
	"{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"
        }
    },
	rarity = 1,
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "toneblock",
		code = "toneblock",
		concept = "toneblock"
	}
})

zipper.set_ability = function(self, card, initial, delay_sprites)
        if card.ability.name == 'Zipper' then
            card.ability.extra.chips = G.GAME.skips*30
	end
end

zipper.calculate = function(self, card, context)
        if card.ability.name == 'Zipper' then
            card.ability.extra.chips = G.GAME.skips*30
	end
        if context.skip_blind then
            if not context.blueprint then
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                            message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips}},
                                colour = G.C.CHIPS
                        }) 
                        return true
                    end}))
            end
	end
	if context.joker_main then
		if card.ability.extra.chips ~= 0 then
                return {
                    message = localize {
                        type = 'variable',
                        key = 'a_chips',
                        vars = { card.ability.extra.chips }
                    },
                    chip_mod = card.ability.extra.chips
                }
end
end
end

function zipper.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.chips}}
end

-- endregion Zipper

--region Temple Eyes

local templeeyes = SMODS.Joker({
	name = "Temple Eyes",
	key = "templeeyes",
    config = {},
	pos = {x = 1, y = 0},
	loc_txt = {
        name = 'Temple Eyes',
        text = {
	"If {C:attention}Blind{} is selected with",
	"{C:money}$4{} or less, create a",
	"{C:tarot}Hanged Man{}",
	"{C:inactive}(Must have room)"
        }
    },
	rarity = 2,
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "toneblock",
		code = "toneblock",
		concept = "toneblock"
	}
})

templeeyes.calculate = function(self, card, context)
	if context.setting_blind and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
	if G.GAME.dollars <= 4 then
        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            return {
		G.E_MANAGER:add_event(Event({
                    func = (function()
                        G.E_MANAGER:add_event(Event({
                            func = function() 
                                local card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_hanged_man', 'see')
                                card:add_to_deck()
                                G.consumeables:emplace(card)
                                G.GAME.consumeable_buffer = 0
                                return true
                            end}))   
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})                       
                        return true
                    end)}))}
		end
        end
end

function templeeyes.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = G.P_CENTERS.c_hanged_man
end

-- endregion Temple Eyes

-- region Mini Heart

local miniheart = SMODS.Joker({
	name = "Mini Heart",
	key = "miniheart",
    config = {},
	pos = {x = 5, y = 0},
	loc_txt = {
        name = 'Mini Heart',
        text = {
	"{C:green}#1# in 20{} chance to add {C:dark_edition}Foil{}",
	"edition to scored cards",
	"{C:inactive,s:0.87}(Unaffected by retriggers){}"
        }
    },
	rarity = 1,
	cost = 5,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "toneblock",
		code = "toneblock",
		concept = "toneblock"
	}
})

miniheart.calculate = function(self, card, context)
	if context.cardarea == G.jokers then
		if context.joker_main then
			if not context.blueprint then
				for k, v in ipairs(context.scoring_hand) do
					if pseudorandom('crystal') < G.GAME.probabilities.normal/20 then
						G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
							v:set_edition({foil = true}, true)
							card:juice_up()
							v:juice_up()
						return true end}))
					end
				end
			end
		end
	end
end

function miniheart.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = G.P_CENTERS.e_foil
	return {vars = {''..(G.GAME and G.GAME.probabilities.normal or 1)}}
end

-- endregion Mini Heart

--region Bird

local bird = SMODS.Joker({
	name = "Bird",
	key = "bird",
    config = {extra = {active = false}},
	pos = {x = 2, y = 0},
	loc_txt = {
        name = 'Bird',
        text = {
	"Whenever a {C:planet}Planet{} card",
	"is used, draw {C:attention}4{} cards"
        }
    },
	rarity = 3,
	cost = 8,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "toneblock",
		code = "toneblock",
		concept = "toneblock"
	}
})

-- mid round judgement won't work but maan
-- i really want to change this but this stupid bird is so dumb

bird.calculate = function(self, card, context)
	if context.setting_blind then
		card.ability.extra.active = true
	end
	if context.end_of_round then
		card.ability.extra.active = false
	end
    if context.using_consumeable then
        if context.consumeable.ability.set == 'Planet' then
            if G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or card.ability.extra.active == true then
                return {
                        G.E_MANAGER:add_event(Event({
                                            func = function() 
                                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "+4 Cards", colour = G.C.FILTER})
                                G.FUNCS.draw_from_deck_to_hand(4)          
                                                return true
                                end}))
                        }
            end
        end
    end
end

-- endregion Bird

-- region Part Of You

local partofyou = SMODS.Joker({
	name = "Part Of You",
	key = "partofyou",
    config = {},
	pos = {x = 3, y = 0},
	loc_txt = {
        name = 'Part Of You',
        text = {
	"If {C:attention}first hand{} of round",
	"contains exactly {C:attention}2{} cards,",
	"convert both their {C:attention}ranks{}",
	"into their {C:attention}complements{}"
        }
    },
	rarity = 3,
	cost = 7,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "toneblock",
		code = "toneblock",
		concept = "Fytos"
	}
})

partofyou.calculate = function(self, card, context)  -- if you're looking at this code to use it as a reference... don't
	if context.before then
	if not context.blueprint then
     	  if G.GAME.current_round.hands_played == 0 then
            if #context.full_hand == 2 then
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() context.full_hand[1]:flip();play_sound('card1', 1);context.full_hand[1]:juice_up(0.3, 0.3);return true end }))
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() context.full_hand[2]:flip();play_sound('card1', 1);context.full_hand[2]:juice_up(0.3, 0.3);return true end }))
 		G.E_MANAGER:add_event(Event({trigger = 'before',
                            func = function() 
				card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Mirrored!", colour = G.C.FILTER})   
                                return true
				end}))
                        local suit = string.sub(context.full_hand[1].config.card.suit, 1, 1) .. "_"
		if context.full_hand[1]:get_id() == 14 then
                        local rank = "K"
                G.E_MANAGER:add_event(Event({func = function()  context.full_hand[1]:set_base(G.P_CARDS[suit .. rank]);return true end }))
		elseif context.full_hand[1]:get_id() == 13 then
                        local rank = "A"
                G.E_MANAGER:add_event(Event({func = function()  context.full_hand[1]:set_base(G.P_CARDS[suit .. rank]);return true end }))
		elseif context.full_hand[1]:get_id() == 12 then
                        local rank = "2"
                G.E_MANAGER:add_event(Event({func = function()  context.full_hand[1]:set_base(G.P_CARDS[suit .. rank]);return true end }))
		elseif context.full_hand[1]:get_id() == 11 then
                        local rank = "3"
                G.E_MANAGER:add_event(Event({func = function()  context.full_hand[1]:set_base(G.P_CARDS[suit .. rank]);return true end }))
		elseif context.full_hand[1]:get_id() == 10 then
                        local rank = "4"
                G.E_MANAGER:add_event(Event({func = function()  context.full_hand[1]:set_base(G.P_CARDS[suit .. rank]);return true end }))
		elseif context.full_hand[1]:get_id() == 9 then
                        local rank = "5"
                G.E_MANAGER:add_event(Event({func = function()  context.full_hand[1]:set_base(G.P_CARDS[suit .. rank]);return true end }))
		elseif context.full_hand[1]:get_id() == 8 then
                        local rank = "6"
                G.E_MANAGER:add_event(Event({func = function()  context.full_hand[1]:set_base(G.P_CARDS[suit .. rank]);return true end }))
		elseif context.full_hand[1]:get_id() == 7 then
                        local rank = "7"
                G.E_MANAGER:add_event(Event({func = function()  context.full_hand[1]:set_base(G.P_CARDS[suit .. rank]);return true end }))
		elseif context.full_hand[1]:get_id() == 6 then
                        local rank = "8"
                G.E_MANAGER:add_event(Event({func = function()  context.full_hand[1]:set_base(G.P_CARDS[suit .. rank]);return true end }))
		elseif context.full_hand[1]:get_id() == 5 then
                        local rank = "9"
                G.E_MANAGER:add_event(Event({func = function()  context.full_hand[1]:set_base(G.P_CARDS[suit .. rank]);return true end }))
		elseif context.full_hand[1]:get_id() == 4 then
                        local rank = "T"
                G.E_MANAGER:add_event(Event({func = function()  context.full_hand[1]:set_base(G.P_CARDS[suit .. rank]);return true end }))
		elseif context.full_hand[1]:get_id() == 3 then
                        local rank = "J"
                G.E_MANAGER:add_event(Event({func = function()  context.full_hand[1]:set_base(G.P_CARDS[suit .. rank]);return true end }))
		elseif context.full_hand[1]:get_id() == 2 then
                        local rank = "Q"
                G.E_MANAGER:add_event(Event({func = function()  context.full_hand[1]:set_base(G.P_CARDS[suit .. rank]);return true end }))
		end
                        local suit = string.sub(context.full_hand[2].config.card.suit, 1, 1) .. "_"
		if context.full_hand[2]:get_id() == 14 then
                        local rank = "K"
                G.E_MANAGER:add_event(Event({func = function()  context.full_hand[2]:set_base(G.P_CARDS[suit .. rank]);return true end }))
		elseif context.full_hand[2]:get_id() == 13 then
                        local rank = "A"
                G.E_MANAGER:add_event(Event({func = function()  context.full_hand[2]:set_base(G.P_CARDS[suit .. rank]);return true end }))
		elseif context.full_hand[2]:get_id() == 12 then
                        local rank = "2"
                G.E_MANAGER:add_event(Event({func = function()  context.full_hand[2]:set_base(G.P_CARDS[suit .. rank]);return true end }))
		elseif context.full_hand[2]:get_id() == 11 then
                        local rank = "3"
                G.E_MANAGER:add_event(Event({func = function()  context.full_hand[2]:set_base(G.P_CARDS[suit .. rank]);return true end }))
		elseif context.full_hand[2]:get_id() == 10 then
                        local rank = "4"
                G.E_MANAGER:add_event(Event({func = function()  context.full_hand[2]:set_base(G.P_CARDS[suit .. rank]);return true end }))
		elseif context.full_hand[2]:get_id() == 9 then
                        local rank = "5"
                G.E_MANAGER:add_event(Event({func = function()  context.full_hand[2]:set_base(G.P_CARDS[suit .. rank]);return true end }))
		elseif context.full_hand[2]:get_id() == 8 then
                        local rank = "6"
                G.E_MANAGER:add_event(Event({func = function()  context.full_hand[2]:set_base(G.P_CARDS[suit .. rank]);return true end }))
		elseif context.full_hand[2]:get_id() == 7 then
                        local rank = "7"
                G.E_MANAGER:add_event(Event({func = function()  context.full_hand[2]:set_base(G.P_CARDS[suit .. rank]);return true end }))
		elseif context.full_hand[2]:get_id() == 6 then
                        local rank = "8"
                G.E_MANAGER:add_event(Event({func = function()  context.full_hand[2]:set_base(G.P_CARDS[suit .. rank]);return true end }))
		elseif context.full_hand[2]:get_id() == 5 then
                        local rank = "9"
                G.E_MANAGER:add_event(Event({func = function()  context.full_hand[2]:set_base(G.P_CARDS[suit .. rank]);return true end }))
		elseif context.full_hand[2]:get_id() == 4 then
                        local rank = "T"
                G.E_MANAGER:add_event(Event({func = function()  context.full_hand[2]:set_base(G.P_CARDS[suit .. rank]);return true end }))
		elseif context.full_hand[2]:get_id() == 3 then
                        local rank = "J"
                G.E_MANAGER:add_event(Event({func = function()  context.full_hand[2]:set_base(G.P_CARDS[suit .. rank]);return true end }))
		elseif context.full_hand[2]:get_id() == 2 then
                        local rank = "Q"
                G.E_MANAGER:add_event(Event({func = function()  context.full_hand[2]:set_base(G.P_CARDS[suit .. rank]);return true end }))
		end
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.75,func = function() context.full_hand[1]:flip();play_sound('tarot2', 1, 0.6);context.full_hand[1]:juice_up(0.3, 0.3);return true end }))
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() context.full_hand[2]:flip();play_sound('tarot2', 1, 0.6);context.full_hand[2]:juice_up(0.3, 0.3);return true end }))
                end
             end
	  end
       end
end

function partofyou.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'partofyou_complements', set = 'Other'}
end

-- endregion Part Of You

-- region Huge Mess: Towels

local towels = SMODS.Joker({
	name = "Huge Mess: Towels",
	key = "towels",
    config = {extra = {chips = 0}},
	pos = {x = 0, y = 3},
	loc_txt = {
        name = 'Huge Mess: Towels',
        text = {
	"When played hand contains a",
	"{C:attention}Flush{}, gains {C:chips}+8{} Chips for",
	"each card held in hand that",
	"shares the same {C:attention}suit{}",
	"{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"
        }
    },
	rarity = 2,
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "j_ccc_jokers",
	credit = {
		art = "toneblock",
		code = "toneblock",
		concept = "Bred"
	}
})

towels.calculate = function(self, card, context)

	if context.before and context.poker_hands ~= nil and next(context.poker_hands['Flush']) and not context.blueprint then

		local suits = {}
		local used_suits = {}
		for i = 1, #context.scoring_hand do
			if context.scoring_hand[i].ability.name ~= 'Wild Card' then
				if not suits[context.scoring_hand[i].base.suit] then
					suits[context.scoring_hand[i].base.suit] = 1
					used_suits[#used_suits + 1] = context.scoring_hand[i].base.suit
				else
					suits[context.scoring_hand[i].base.suit] = suits[context.scoring_hand[i].base.suit] + 1
				end
			end
		end
		local value = 0
		if #used_suits ~= 0 then
			for i = 1, #used_suits do
				if suits[used_suits[i]] > value then
					towels_flush_suit = used_suits[i]
					value = suits[used_suits[i]]
				end
			end
		else
			towels_flush_suit = 'Wild'
		end
	end	

	if context.individual and context.poker_hands ~= nil and next(context.poker_hands['Flush']) and not context.blueprint then
        	if context.cardarea == G.hand then
	         	if context.other_card:is_suit(towels_flush_suit, true) or towels_flush_suit == 'Wild' then
                        card.ability.extra.chips = card.ability.extra.chips + 8
                        	    return {
                            message = localize('k_upgrade_ex'),
                            colour = G.C.CHIPS
                        }
        		end
	        end
	end
	if context.joker_main then
            if card.ability.extra.chips ~= 0 then
                return {
                    message = localize {
                        type = 'variable',
                        key = 'a_chips',
                        vars = { card.ability.extra.chips }
                    },
                    chip_mod = card.ability.extra.chips
                }
	    end
	end
end

function towels.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.chips}}
end

-- endregion Huge Mess: Towels

-- region Huge Mess: Chests

local chests = SMODS.Joker({
	name = "Huge Mess: Chests",
	key = "chests",
    config = {extra = {mult = 0}},
	pos = {x = 1, y = 3},
	loc_txt = {
        name = 'Huge Mess: Chests',
        text = {
	"When played hand contains a",
	"{C:attention}Three of a Kind{}, gains",
	"{C:mult}+3{} Mult for each possible",
	"{C:attention}Pair{} held in hand",
	"{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
        }
    },
	rarity = 2,
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "j_ccc_jokers",
	credit = {
		art = "toneblock",
		code = "toneblock",
		concept = "Bred"
	}
})

chests.calculate = function(self, card, context)

	if context.before and not context.blueprint then
	boxes_rank_array = {}
	boxes_card_array_length = 0
	boxes_pair_amounts = 0
	boxes_card_pair_candidate = 0
	end

	if context.individual and context.poker_hands ~= nil and ((next(context.poker_hands['Three of a Kind']) or next(context.poker_hands['Full House']) or next(context.poker_hands['Four of a Kind']) or next(context.poker_hands['Five of a Kind']) or next(context.poker_hands['Flush Five']))) and not context.blueprint then
       		if context.cardarea == G.hand then
			boxes_card_array_length = boxes_card_array_length + 1
			boxes_rank_array[boxes_card_array_length] = context.other_card:get_id()
		end
	end

	if context.joker_main and not context.blueprint then
		for v = 1, 13 do
			boxes_card_pair_candidate = 0
			for i = 1, boxes_card_array_length do
				if boxes_rank_array[i] == v + 1 then
					boxes_card_pair_candidate = boxes_card_pair_candidate + 1
				end
			end
			boxes_pair_amounts = boxes_pair_amounts + ((boxes_card_pair_candidate - 1)*(boxes_card_pair_candidate)) / 2
		end
		if boxes_pair_amounts > 0 then
			card.ability.extra.mult = card.ability.extra.mult + (boxes_pair_amounts)*3
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Upgrade!", colour = G.C.MULT}) 
		end
	end
	if context.joker_main then
		if card.ability.extra.mult ~= 0 then
                	return {
                   	message = localize {
                  		type = 'variable',
                   		key = 'a_mult',
                  		vars = { card.ability.extra.mult }
                		},
                	mult_mod = card.ability.extra.mult
                	}
		end
	end
end

function chests.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.mult}}
end

-- endregion Huge Mess: Chests

-- region Huge Mess: Books

local books = SMODS.Joker({
	name = "Huge Mess: Books",
	key = "books",
    config = {extra = {xmult = 1}},
	pos = {x = 2, y = 3},
	loc_txt = {
	default = {
        name = 'Huge Mess: Books',
        text = {
	"When played hand contains a",
	"{C:attention}Straight{}, gains {X:mult,C:white} X0.14 {} Mult",
	"for each additional card in",
	"the {C:attention}sequence{} held in hand",
	"{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult){}"
        }
    },
	fr = {
        name = 'Huge Mess: Books',
        text = {
	"When played hand contains a",
	"{C:attention}Straight{}, gains {X:mult,C:white} X0.14 {} Mult",
	"for each additional card in",
	"the {C:attention}sequence{} held in hand",
	"{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult){}"
        }
    }
},
	rarity = 2,
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "j_ccc_jokers",
	credit = {
		art = "toneblock",
		code = "toneblock",
		concept = "Bred"
	}
})

books.calculate = function(self, card, context)

	if context.before and not context.blueprint then
	books_rank_array = {}
	books_card_array_length = 0
	books_pair_amounts = 0
	books_card_pair_candidate = 0
	books_scoring_straight_array = {}
	books_scoring_pair = false
	books_highest_rank_found = false
	books_lowest_rank_found = false
	books_additional_sequence_cards = 0
	books_straight_border_high = 0
	books_straight_border_low = 0
	books_ace_high_scored = false
	books_ace_high_scored_in_hand = false
	books_ace_low_scored = false
	books_skipped_ranks = false
	books_allowed_skipped_ranks = {}
	books_repeat_non_shortcut = true
	end

	if context.individual and context.poker_hands ~= nil and (next(context.poker_hands['Straight'])) and not context.blueprint then
       		if context.cardarea == G.hand then
			books_card_array_length = books_card_array_length + 1
			books_rank_array[books_card_array_length] = context.other_card:get_id()
			table.sort(books_rank_array)
		end
	end

	if context.joker_main and context.poker_hands ~= nil and (next(context.poker_hands['Straight'])) and not context.blueprint then
		for i = 1, #context.scoring_hand do
			books_scoring_straight_array[i] = context.scoring_hand[i]:get_id()
		end
		table.sort(books_scoring_straight_array)

		if not next(find_joker('Four Fingers')) then
			if not next(find_joker('Shortcut')) then
				if books_scoring_straight_array[#books_scoring_straight_array] == 14 then
					if books_scoring_straight_array[1] == 2 then
						books_ace_low_scored = true
						books_scoring_straight_array[#books_scoring_straight_array] = 1
						table.sort(books_scoring_straight_array)
					else
						books_ace_high_scored = true
					end
				end
			else
				if books_scoring_straight_array[#books_scoring_straight_array] == 14 then
					if books_scoring_straight_array[1] == 2 or books_scoring_straight_array[1] == 3 then
						books_ace_low_scored = true
						books_scoring_straight_array[#books_scoring_straight_array] = 1
						table.sort(books_scoring_straight_array)
					else
						books_ace_high_scored = true
					end
				end
			end
		end

		if next(find_joker('Four Fingers')) then 	-- things get a whole lot more complicated, that's what :(
			for i = 1, (#books_scoring_straight_array - 1) do
				if books_scoring_straight_array[i] == books_scoring_straight_array[i + 1] then
					books_scoring_pair = true	
				end
			end
			if books_scoring_pair ~= true then
				if not next(find_joker('Shortcut')) then
					if books_scoring_straight_array[1] ~= books_scoring_straight_array[2] - 1 then
						table.remove(books_scoring_straight_array, 1)
					end
					if books_scoring_straight_array[#books_scoring_straight_array] ~= books_scoring_straight_array[#books_scoring_straight_array - 1] + 1 then
						if books_scoring_straight_array[#books_scoring_straight_array] == 14 then
							if books_scoring_straight_array[1] == 2 then
								books_ace_low_scored = true
								books_scoring_straight_array[#books_scoring_straight_array] = 1
								table.sort(books_scoring_straight_array)
								if books_scoring_straight_array[#books_scoring_straight_array] ~= books_scoring_straight_array[#books_scoring_straight_array - 1] + 1 then
									books_scoring_straight_array[#books_scoring_straight_array] = nil
								end
							else
								books_scoring_straight_array[#books_scoring_straight_array] = nil
							end
						else
							books_scoring_straight_array[#books_scoring_straight_array] = nil
						end
					end
					if books_ace_low_scored == false and books_scoring_straight_array[#books_scoring_straight_array] == 14 then
						books_ace_high_scored = true
					end
				else
					if (books_scoring_straight_array[1] ~= books_scoring_straight_array[2] - 1) and (books_scoring_straight_array[1] ~= books_scoring_straight_array[2] - 2) then
						table.remove(books_scoring_straight_array, 1)
					end
					if (books_scoring_straight_array[#books_scoring_straight_array] ~= books_scoring_straight_array[#books_scoring_straight_array - 1] + 1) and (books_scoring_straight_array[#books_scoring_straight_array] ~= books_scoring_straight_array[#books_scoring_straight_array - 1] + 2) then
						if books_scoring_straight_array[#books_scoring_straight_array] == 14 then
							if books_scoring_straight_array[1] == 2 or books_scoring_straight_array[1] == 3 then
								books_ace_low_scored = true
								books_scoring_straight_array[#books_scoring_straight_array] = 1
								table.sort(books_scoring_straight_array)
								if (books_scoring_straight_array[#books_scoring_straight_array] ~= books_scoring_straight_array[#books_scoring_straight_array - 1] + 1) and (books_scoring_straight_array[#books_scoring_straight_array] ~= books_scoring_straight_array[#books_scoring_straight_array - 1] + 2) then
									books_scoring_straight_array[#books_scoring_straight_array] = nil
								end
							else
								books_scoring_straight_array[#books_scoring_straight_array] = nil
							end
						else
							books_scoring_straight_array[#books_scoring_straight_array] = nil
						end
					end
					if books_ace_low_scored == false and books_scoring_straight_array[#books_scoring_straight_array] == 14 then
						books_ace_high_scored = true
					end
				end
			else
				if books_scoring_straight_array[#books_scoring_straight_array] == 14 then
					if books_scoring_straight_array[1] == 2 then
						books_ace_low_scored = true
						books_scoring_straight_array[#books_scoring_straight_array] = 1
						table.sort(books_scoring_straight_array)
					else
						books_ace_high_scored = true
					end
				end
				if books_scoring_straight_array[#books_scoring_straight_array] == 14 then
					if books_scoring_straight_array[1] == 2 or books_scoring_straight_array[1] == 3 then
						books_ace_low_scored = true
						books_scoring_straight_array[#books_scoring_straight_array] = 1
						table.sort(books_scoring_straight_array)
					else
						books_ace_high_scored = true
					end
				end
			end			
			if books_scoring_straight_array[#books_scoring_straight_array] == 14 and books_ace_low_scored == true then 	-- have to check if the player played another fucking ace in a low ace straight for whatever reason
				books_scoring_straight_array[#books_scoring_straight_array] = nil
			end
		end
		
		-- now we have an accurate books_scoring_straight_array! woo i sure hope there aren't any other problems!
		
		if next(find_joker('Shortcut')) then
			if (books_scoring_straight_array[#books_scoring_straight_array] - books_scoring_straight_array[1]) > (#books_scoring_straight_array - 1) then
				books_skipped_ranks = true
				for i = 1, (#books_scoring_straight_array - 1) do
					if books_scoring_straight_array[i] == (books_scoring_straight_array[i + 1] - 2) then
						books_allowed_skipped_ranks[#books_allowed_skipped_ranks + 1] = books_scoring_straight_array[i] + 1
					end
				end
			end
		end
		
		books_straight_border_low = books_scoring_straight_array[1]
		books_straight_border_high = books_scoring_straight_array[#books_scoring_straight_array]
		
		if not next(find_joker('Shortcut')) then
			while books_highest_rank_found == false do
				books_highest_rank_found = true
				for i = 1, books_card_array_length do
					if books_rank_array[i] == books_straight_border_high + 1 then
						if books_rank_array[i] == 14 and books_ace_high_scored == false then
							books_ace_high_scored = true
							books_ace_high_scored_in_hand = true
							books_straight_border_high = books_rank_array[i]
							books_additional_sequence_cards = books_additional_sequence_cards + 1
						end
						if books_rank_array[i] ~= 14 then
							books_highest_rank_found = false
							books_straight_border_high = books_rank_array[i]
							books_additional_sequence_cards = books_additional_sequence_cards + 1
						end
					end
				end
			end
			while books_lowest_rank_found == false do
				books_lowest_rank_found = true
				for i = 1, books_card_array_length do
					if books_rank_array[i] == books_straight_border_low - 1 then
						if books_rank_array[i] ~= 14 then
							books_lowest_rank_found = false
							books_straight_border_low = books_rank_array[i]
							books_additional_sequence_cards = books_additional_sequence_cards + 1
						end
					end
				end
				if books_straight_border_low - 1 == 1 then
					if books_rank_array[#books_rank_array] == 14 and books_ace_low_scored == false then
						if books_ace_high_scored_in_hand == true then
							if books_rank_array[#books_rank_array - 1] == 14 then
								books_ace_low_scored = true
								books_straight_border_low = 1
								books_additional_sequence_cards = books_additional_sequence_cards + 1
							end
						else
							books_ace_low_scored = true
							books_straight_border_low = 1
							books_additional_sequence_cards = books_additional_sequence_cards + 1
						end
					end	
				end		
			end
		else
			while books_highest_rank_found == false do
				books_highest_rank_found = true
				while books_repeat_non_shortcut == true do
					books_repeat_non_shortcut = false
					for i = 1, books_card_array_length do
						if books_rank_array[i] == books_straight_border_high + 1 then
							if books_rank_array[i] == 14 and books_ace_high_scored == false then
								books_ace_high_scored = true
								books_ace_high_scored_in_hand = true
								books_straight_border_high = books_rank_array[i]
								books_additional_sequence_cards = books_additional_sequence_cards + 1
							end
							if books_rank_array[i] ~= 14 then
								books_highest_rank_found = false
								books_repeat_non_shortcut = true
								books_straight_border_high = books_rank_array[i]
								books_additional_sequence_cards = books_additional_sequence_cards + 1
							end
						end
					end
				end
				for i = 1, books_card_array_length do
					if books_repeat_non_shortcut == false then
						if books_rank_array[i] == (books_straight_border_high + 2) then
							if books_rank_array[i] == 14 and books_ace_high_scored == false then
								books_ace_high_scored = true
								books_ace_high_scored_in_hand = true
								books_straight_border_high = books_rank_array[i]
								books_additional_sequence_cards = books_additional_sequence_cards + 1
							end
							if books_rank_array[i] ~= 14 then
								books_highest_rank_found = false
								books_repeat_non_shortcut = true
								books_straight_border_high = books_rank_array[i]
								books_additional_sequence_cards = books_additional_sequence_cards + 1
							end				
						end
					end
				end
			end
			books_repeat_non_shortcut = true
			while books_lowest_rank_found == false do
				books_lowest_rank_found = true
				while books_repeat_non_shortcut == true do
					books_repeat_non_shortcut = false
					for i = 1, books_card_array_length do
						if books_rank_array[i] == books_straight_border_low - 1 then
							if books_rank_array[i] ~= 14 then
								books_lowest_rank_found = false
								books_repeat_non_shortcut = true
								books_straight_border_low = books_rank_array[i]
								books_additional_sequence_cards = books_additional_sequence_cards + 1
							end
						end
					end
					if books_straight_border_low - 1 == 1 then
						if books_rank_array[#books_rank_array] == 14 and books_ace_low_scored == false then
							if books_ace_high_scored_in_hand == true then
								if books_rank_array[#books_rank_array - 1] == 14 then
									books_ace_low_scored = true
									books_straight_border_low = 1
									books_additional_sequence_cards = books_additional_sequence_cards + 1
								end
							else
								books_ace_low_scored = true
								books_straight_border_low = 1
								books_additional_sequence_cards = books_additional_sequence_cards + 1
							end
						end
					end
				end
				for i = 1, books_card_array_length do
					if books_repeat_non_shortcut == false then
						if books_rank_array[i] == books_straight_border_low - 2 then
							if books_rank_array[i] ~= 14 then
								books_lowest_rank_found = false
								books_repeat_non_shortcut = true
								books_straight_border_low = books_rank_array[i]
								books_additional_sequence_cards = books_additional_sequence_cards + 1
							end
						end				
					end
				end
				if books_straight_border_low - 1 == 1 then
					if books_rank_array[#books_rank_array] == 14 and books_ace_low_scored == false then
						if books_ace_high_scored_in_hand == true then
							if books_rank_array[#books_rank_array - 1] == 14 then
								books_ace_low_scored = true
								books_straight_border_low = 1
								books_additional_sequence_cards = books_additional_sequence_cards + 1
							end
						else
							books_ace_low_scored = true
							books_straight_border_low = 1
							books_additional_sequence_cards = books_additional_sequence_cards + 1
						end
					end
				end
			end
			if books_skipped_ranks == true then
				for i = 1, #books_allowed_skipped_ranks do
					for v = 1, #books_rank_array do
						if books_rank_array[v] == books_allowed_skipped_ranks[i] then
							books_additional_sequence_cards = books_additional_sequence_cards + 1
							books_allowed_skipped_ranks[i] = 0
						end
					end
				end
			end
		end
		if books_additional_sequence_cards > 0 then
			card.ability.extra.xmult = card.ability.extra.xmult + (0.14*(books_additional_sequence_cards))
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Upgrade!", colour = G.C.MULT}) 
		end
	end
	if context.joker_main then
		if card.ability.extra.xmult ~= 1 then
                	return {
                   	message = localize {
                  		type = 'variable',
                   		key = 'a_xmult',
                  		vars = { card.ability.extra.xmult }
                		},
                	mult_mod = card.ability.extra.xmult
                	}
		end
	end
end

function books.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.xmult}}
end

-- endregion Huge Mess: Books

-- region Ominous Mirror

local ominousmirror = SMODS.Joker({
	name = "Ominous Mirror",
	key = "ominousmirror",
    config = {extra = {broken = false, pos_override = {x = 0, y = 2}}},
	pos = {x = 0, y = 2},
	loc_txt = {
        name = ('Ominous Mirror'),
        text = {
	"{C:green}#1# in 2{} chance to copy a",
	"scored card to your hand,",
	"adding {C:dark_edition}Mirrored{} edition",
	"{C:green}#1# in 6{} chance to {C:inactive}break{}",
	"at end of round, leaving",
	"a {C:attention}Broken Mirror{}"
        }
    },
	rarity = 3,
	cost = 10,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie & sunsetquasar",
		code = "toneblock & Aurora Aquir",
		concept = "Gappie"
	},
	process_loc_text = function(self)
		SMODS.process_loc_text(G.localization.descriptions[self.set], self.key, self.loc_txt)
		SMODS.process_loc_text(G.localization.descriptions[self.set], "Broken Mirror", {
				name = ('Broken Mirror'),
				text = {
					"{C:inactive}Does nothing."
				}
		})
	end,
	afterload = function(self, card, card_table, other_card)
		card.children.center:set_sprite_pos(card_table.ability.extra.pos_override)
	end
})

ominousmirror.set_ability = function(self, card, initial, delay_sprites)
	card.children.center:set_sprite_pos(card.ability.extra.pos_override)
end


ominousmirror.calculate = function(self, card, context)
	card.children.center:set_sprite_pos(card.ability.extra.pos_override)
	if context.before and card.ability.extra.broken == false then
		if not context.repetition and not context.individual and card.ability.extra.broken == false then
			for k, v in ipairs(context.scoring_hand) do
				if pseudorandom('ominous') < G.GAME.probabilities.normal/2 then
					G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, func = function()
						card:juice_up()
						v:juice_up()
						local _card = copy_card(v, nil, nil, G.playing_card)
						_card:add_to_deck()
						_card:set_edition({mirrored = true}, true)
						G.deck.config.card_limit = G.deck.config.card_limit + 1
						table.insert(G.playing_cards, _card)
						G.hand:emplace(_card)
						return {
						playing_cards_created = {true}
						}
					end}))
				end
			end
		end
	end
	if context.end_of_round and not context.blueprint and not context.repetition and not context.individual and card.ability.extra.broken == false then
		if pseudorandom('oopsidroppedit') < G.GAME.probabilities.normal/6 then 
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, 
				func = function()
				play_sound('glass'..math.random(1, 6), math.random()*0.2 + 0.9,0.5)
				local childParts = Particles(0, 0, 0,0, {
					timer_type = 'TOTAL',
					timer = 0.007*1,
					scale = 0.3,
					speed = 4,
					lifespan = 0.5*1,
					attach = card,
					colours = {G.C.MULT},
					fill = true
				})
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					blockable = false,
					delay =  0.5*1,
					func = (function() childParts:fade(0.30*1) return true end)
				}))
				card.T.r = -0.2
				card:juice_up(0.3, 0.4)
				card.ability.extra.broken = true
				card.ability.extra.pos_override.x = 1
				card.ability.extra.pos_override.y = 2
				G.GAME.pool_flags.badeline_break = true
				return true
				end
			}))
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Broken", colour = G.C.MULT})
		else
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Safe..?", colour = G.C.FILTER})
		end
	end
end

function ominousmirror.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'e_mirrored', set = 'Other'}
	return {key = card.ability.extra.broken and "Broken Mirror" or card.config.center.key, vars = {''..(G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.broken}}
end

-- endregion Ominous Mirror

-- region ALL BERRIES

-- region Strawberry

local strawberry = SMODS.Joker({
	name = "Strawberry",
	key = "strawberry",
    config = {extra = {money = 8}},
	pos = {x = 1, y = 1},
	loc_txt = {
        name = 'Strawberry',
        text = {
	"Earn {C:money}$#1#{} at end of",
	"round, reduces by {C:money}$1{}",
	"at end of shop"
        }
    },
	rarity = 1,
	cost = 7,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Gappie"
	}
})

-- for some goddamn reason there's no easy way to add the dollar bonus at calculation... so i injected it via lovely. should work though

strawberry.calculate = function(self, card, context)
	if context.ending_shop and not context.blueprint then
		if card.ability.extra.money > 1 then
			card.ability.extra.money = card.ability.extra.money - 1
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = "-$1", colour = G.C.MONEY})
		else
			G.E_MANAGER:add_event(Event({
				func = function()
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Eaten!", colour = G.C.FILTER})
				play_sound('tarot1')
				card.T.r = -0.2
				card:juice_up(0.3, 0.4)
				card.states.drag.is = true
				card.children.center.pinch.x = true
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
					func = function()
						G.jokers:remove_card(card)
						card:remove()
						card = nil
					return true; end})) 
				return true
			end
                       	}))
		end 
	end
end

function strawberry.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.money}}
end


-- endregion Strawberry

-- region Winged Strawberry

local wingedstrawberry = SMODS.Joker({
	name = "Winged Strawberry",
	key = "wingedstrawberry",
    config = {extra = {winged_poker_hand = 'Pair'}},
	pos = {x = 2, y = 1},
	loc_txt = {
        name = 'Winged Strawberry',
        text = {
	"Earn {C:money}$3{} if {C:attention}poker hand{} does",
	"not contain a {C:attention}#1#{},",
	"poker hand changes",
	"at end of round"
        }
    },
	rarity = 1,
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Gappie"
	}
})

wingedstrawberry.set_ability = function(self, card, initial, delay_sprites)
	local _poker_hands = {}
	for k, v in pairs(G.GAME.hands) do
		if v.visible then 
			_poker_hands[#_poker_hands+1] = k 
		end
	end
	card.ability.extra.winged_poker_hand = pseudorandom_element(_poker_hands, pseudoseed('winged'))
end

wingedstrawberry.calculate = function(self, card, context)
	if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
		if not context.blueprint then
                    local _poker_hands = {}
                    for k, v in pairs(G.GAME.hands) do
                        if v.visible and k ~= card.ability.extra.winged_poker_hand then 
				_poker_hands[#_poker_hands+1] = k 
			end
                    end
                    card.ability.extra.winged_poker_hand = pseudorandom_element(_poker_hands, pseudoseed('winged'))
		end
		card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Reset", colour = G.C.FILTER})
	end
        if context.cardarea == G.jokers then
		if context.before and not context.end_of_round then
			if not next(context.poker_hands[card.ability.extra.winged_poker_hand]) then
				ease_dollars(3)
				G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + 3
				G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
				return {
					message = localize('$')..3,
					dollars = 3,
					colour = G.C.MONEY
					}
			end
		end
	end
end
		
	

function wingedstrawberry.loc_vars(self, info_queue, card)
	return {vars = {(card.ability.extra.winged_poker_hand)}}
end

-- endregion Winged Strawberry

-- region Golden Strawberry

local goldenstrawberry = SMODS.Joker({
	name = "Golden Strawberry",
	key = "goldenstrawberry",
    config = {extra = {after_boss = false}},
	pos = {x = 3, y = 1},
	loc_txt = {
        name = 'Golden Strawberry',
        text = {
	"Earn {C:money}$12{} at end of",
	"{C:attention}Boss Blind{}"
        }
    },
	rarity = 2,
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
	}
})

-- literally the simplest code in the entire mod lmao

goldenstrawberry.calculate = function(self, card, context)
	if context.setting_blind and not context.blueprint then
		if context.blind.boss then
			card.ability.extra.after_boss = true
		else
			card.ability.extra.after_boss = false
		end
	end
end

-- endregion Golden Strawberry

-- region Winged Golden Strawberry

local wingedgoldenstrawberry = SMODS.Joker({
	name = "Winged Golden Strawberry",
	key = "wingedgoldenstrawberry",
    config = {extra = {condition_satisfied = 'true', winged_poker_hand = 'Pair', after_boss = false}},
	pos = {x = 4, y = 1},
	loc_txt = {
        name = 'Winged Golden Strawberry',
        text = {
	"Earn {C:money}$15{} at end of {C:attention}Boss Blind{} if",
	"beaten without playing a hand",
	"that contains a {C:attention}#1#{},",
	"poker hand changes",
	"at end of round"
        }
    },
	rarity = 2,
	cost = 7,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Gappie"
	}
})

wingedgoldenstrawberry.set_ability = function(self, card, initial, delay_sprites)
	local _poker_hands = {}
	for k, v in pairs(G.GAME.hands) do
		if v.visible then 
			_poker_hands[#_poker_hands+1] = k 
		end
	end
	card.ability.extra.winged_poker_hand = pseudorandom_element(_poker_hands, pseudoseed('wingedgolden'))
end

wingedgoldenstrawberry.calculate = function(self, card, context)
	if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
		if not context.blueprint then
                    local _poker_hands = {}
                    for k, v in pairs(G.GAME.hands) do
                        if v.visible and k ~= card.ability.extra.winged_poker_hand then 
				_poker_hands[#_poker_hands+1] = k 
			end
                    end
                    card.ability.extra.winged_poker_hand = pseudorandom_element(_poker_hands, pseudoseed('wingedgolden'))
		end
		card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Reset", colour = G.C.FILTER})
	end
        if context.cardarea == G.jokers then
		if context.before and not context.end_of_round then
			if next(context.poker_hands[card.ability.extra.winged_poker_hand]) then
				card.ability.extra.condition_satisfied = false
			end
		end
	end
	if context.setting_blind then
		card.ability.extra.condition_satisfied = true
		if context.blind.boss then
			card.ability.extra.after_boss = true
		else
			card.ability.extra.after_boss = false
		end
	end
end

function wingedgoldenstrawberry.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.winged_poker_hand}}
end

-- endregion Winged Golden Strawberry

-- region Moon Berry

local moonberry = SMODS.Joker({
	name = "Moon Berry",
	key = "moonberry",
    config = {extra = {condition_satisfied = false, winged_poker_hand = 'Pair'}},
	pos = {x = 5, y = 1},
	loc_txt = {
        name = 'Moon Berry',
        text = {
	"If round ends without playing",
	"hand that contains a {C:attention}#1#{},",
	"create its {C:planet}Planet{} card with",
	"added {C:dark_edition}Negative{} edition,",
	"poker hand changes",
	"at end of round"
        }
    },
	rarity = 2,
	cost = 8,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Gappie"
	}
})

moonberry.set_ability = function(self, card, initial, delay_sprites)
	local _poker_hands = {}
	for k, v in pairs(G.GAME.hands) do
		if v.visible then 
			_poker_hands[#_poker_hands+1] = k 
		end
	end
	card.ability.extra.winged_poker_hand = pseudorandom_element(_poker_hands, pseudoseed('SPAAAAAAAACE'))
end

moonberry.calculate = function(self, card, context)
	if context.end_of_round and not context.repetition and not context.individual then
		local card_type = 'Planet'
		if card.ability.extra.condition_satisfied == true then
			G.E_MANAGER:add_event(Event({
			trigger = 'before',
			delay = 0.0,
			func = (function()
				local _planet = 0
				for k, v in pairs(G.P_CENTER_POOLS.Planet) do
					if v.config.hand_type == card.ability.extra.winged_poker_hand then
						_planet = v.key
					end
				end
                    		local card = create_card(card_type,G.consumeables, nil, nil, nil, nil, _planet, 'blusl')
				card:set_edition({negative = true}, true)
                    		card:add_to_deck()
                    		G.consumeables:emplace(card)
                		return true
            		end)}))
		end
		if not context.blueprint then
			G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.0,
			func = (function()
			local _poker_hands = {}
                    	for k, v in pairs(G.GAME.hands) do
                      	  	if v.visible and k ~= card.ability.extra.winged_poker_hand then 
					_poker_hands[#_poker_hands+1] = k 
				end
                    	end
			card.ability.extra.winged_poker_hand = pseudorandom_element(_poker_hands, pseudoseed('SPAAAAAAAACE'))
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Reset", colour = G.C.FILTER})
			return true
            		end)}))
		end
		if card.ability.extra.condition_satisfied == true then
			card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet})
		end
	end
        if context.cardarea == G.jokers then
		if context.before and not context.end_of_round then
			if next(context.poker_hands[card.ability.extra.winged_poker_hand]) then
				card.ability.extra.condition_satisfied = false
			end
		end
	end
	if context.setting_blind then
		card.ability.extra.condition_satisfied = true
	end
end

function moonberry.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'e_negative_consumable', set = 'Edition', config = {extra = 1}}
	return {vars = {card.ability.extra.winged_poker_hand}}
end

-- endregion Moon Berry

-- endregion ALL BERRIES

-- region To The Summit

local tothesummit = SMODS.Joker({
	name = "To The Summit",
	key = "tothesummit",
    config = {extra = {xmult = 1, min_money = 0}},	-- rip debt lovers
	pos = {x = 0, y = 1},
	loc_txt = {
        name = 'To The Summit',
        text = {
	"Gains {X:mult,C:white} X0.25 {} Mult for each",
	"{C:attention}consecutive Blind{} selected",
	"with more {C:money}money{} than",
	"the {C:attention}previous Blind{}",
	"{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult)",
	"{C:inactive}(Must be higher than {C:money}$#2#{C:inactive})"
        }
    },
	rarity = 2,
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Aurora Aquir"
	}
})

tothesummit.calculate = function(self, card, context)
	if context.setting_blind and not context.blueprint then
		if card.ability.extra.min_money >= math.max(0,(G.GAME.dollars + (G.GAME.dollar_buffer or 0))) then
			local last_xmult = card.ability.extra.xmult
			card.ability.extra.xmult = 1
			if last_xmult > 1 then
				card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Reset", colour = G.C.FILTER})
			end
			ccc_tothesummit_min_money = math.max(0,(G.GAME.dollars + (G.GAME.dollar_buffer or 0)))
		elseif card.ability.extra.min_money < math.max(0,(G.GAME.dollars + (G.GAME.dollar_buffer or 0))) then
			card.ability.extra.xmult = card.ability.extra.xmult + 0.25
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.xmult}}})
			card.ability.extra.min_money = math.max(0,(G.GAME.dollars + (G.GAME.dollar_buffer or 0)))
		end
	end		
	if context.joker_main then
            	if card.ability.extra.xmult ~= 1 then
                	return {
                    	message = localize {
                        	type = 'variable',
                        	key = 'a_xmult',
                        	vars = { card.ability.extra.xmult }
                    	},
			Xmult_mod = card.ability.extra.xmult
                	}
		end
	end
end

function tothesummit.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.xmult, card.ability.extra.min_money}}
end

-- endregion To The Summit

-- region Core Switch

local coreswitch = SMODS.Joker({
	name = "Core Switch",
	key = "coreswitch",
    config = {extra = {pos_override = {x = 6, y = 0}}},
	pos = {x = 6, y = 0},
	loc_txt = {
        name = 'Core Switch',
        text = {
	"Swap {C:blue}hands{} and {C:red}discards{}",
	"at start of round",
	"{C:red}+1{} discard after swap"
        }
    },
	rarity = 1,
	cost = 3,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie & Aurora Aquir",
		code = "toneblock",
		concept = "Aurora Aquir"
	},
	afterload = function(self, card, card_table, other_card)
		card.children.center:set_sprite_pos(card_table.ability.extra.pos_override)
	end
})

coreswitch.calculate = function(self, card, context)
	card.children.center:set_sprite_pos(card.ability.extra.pos_override)
	if context.first_hand_drawn and not card.getting_sliced and not context.blueprint and not context.individual then
		G.E_MANAGER:add_event(Event({trigger = 'before', delay = immediate, func = function()
			coreswitch_hand_juggle = G.GAME.current_round.discards_left
			ease_discard(1 + (G.GAME.current_round.hands_left - G.GAME.current_round.discards_left), nil, true)
			ease_hands_played(coreswitch_hand_juggle - G.GAME.current_round.hands_left, nil, true)
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Swapped", colour = G.C.FILTER})
			if card.ability.extra.pos_override.x == 6 then 
				card.ability.extra.pos_override.x = 7 
			else
				card.ability.extra.pos_override.x = 6
			end
			
			if coreswitch_hand_juggle == 0 then  -- you're a dumbass lol
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.6, func = function()
					G.STATE = G.STATES.GAME_OVER
                			if not G.GAME.won and not G.GAME.seeded and not G.GAME.challenge then 
						G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt = 0
					end
					G:save_settings()
					G.FILE_HANDLER.force = true
					G.STATE_COMPLETE = false
				return true end }))
			end
		return true end }))
	end
end

-- endregion Core Switch

-- region Temple Rock

local templerock = SMODS.Joker({
	name = "Temple Rock",
	key = "templerock",
    config = {},
	pos = {x = 8, y = 0},
	loc_txt = {
        name = 'Temple Rock',
        text = {
	"Each {C:attention}Stone Card{} held",
	"in hand gives {C:chips}+50{} chips"
        }
    },
	rarity = 1,
	cost = 4,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "N/A",
		code = "toneblock",
		concept = "sunsetquasar"
	}
})

templerock.calculate = function(self, card, context)
	if context.individual and context.poker_hands ~= nil then
        	if context.cardarea == G.hand then
	         	if context.other_card.ability.name == 'Stone Card' then
				hand_chips = mod_chips(hand_chips + 50)
                        	update_hand_text({delay = 0}, {chips = hand_chips})
                        	return {
                    			message = localize {
                        			type = 'variable',
                        			key = 'a_chips',
                        			vars = { 50 }
                    				},
					chip_mod = 50
				}
			end
        	end
	end
end

function templerock.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = G.P_CENTERS.m_stone
end

-- endregion Temple Rock

-- region Strong Winds

local strongwinds = SMODS.Joker({
	name = "Strong Winds",
	key = "strongwinds",
    config = {},
	pos = {x = 4, y = 2},
	loc_txt = {
        name = 'Strong Winds',
        text = {
	"{X:mult,C:white} X2.22 {} Mult",
	"Card of the highest {C:attention}rank{} in",
	"scoring hand is {C:red}destroyed{}"
        }
    },
	rarity = 3,
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "N/A",
		code = "toneblock",
		concept = "goose!"
	}
})

strongwinds.calculate = function(self, card, context)
	if context.cardarea == G.jokers then
		if context.joker_main then
			if not context.blueprint then
				local cards_destroyed = {}
				YOU_CANNOT_STOP_THE_WIND_BITCH = context.scoring_hand[1]
				for k = 1, #context.scoring_hand do
					if context.scoring_hand[k].ability.name ~= 'Stone Card' then
						if context.scoring_hand[k]:get_id() > YOU_CANNOT_STOP_THE_WIND_BITCH:get_id() then
							YOU_CANNOT_STOP_THE_WIND_BITCH = context.scoring_hand[k]
						end
					end
				end
            			highlight_card(YOU_CANNOT_STOP_THE_WIND_BITCH,(1-0.999)/(#context.scoring_hand-0.998),'down') -- i copied literally the entire goddamn card destruction code to fix this stupid bug... it's probably just this line that i was missing but oh my god i don't care at this point
				if YOU_CANNOT_STOP_THE_WIND_BITCH.ability.name == 'Glass Card' then 
					YOU_CANNOT_STOP_THE_WIND_BITCH.shattered = true
				else 
					YOU_CANNOT_STOP_THE_WIND_BITCH.destroyed = true
				end 
				cards_destroyed[#cards_destroyed+1] = YOU_CANNOT_STOP_THE_WIND_BITCH
       				for j=1, #G.jokers.cards do
					eval_card(G.jokers.cards[j], {cardarea = G.jokers, remove_playing_cards = true, removed = cards_destroyed})
				end
				for i=1, #cards_destroyed do
					G.E_MANAGER:add_event(Event({
						func = function()
							if cards_destroyed[i].ability.name == 'Glass Card' then 
								cards_destroyed[i]:shatter()
							else
								cards_destroyed[i]:start_dissolve()
							end
						return true
						end
					}))
				end
			end
			return {
				message = localize {
					type = 'variable',
					key = 'a_xmult',
					vars = { 2.22 }
				},
				Xmult_mod = 2.22
			}
		end
	end
end

			
-- endregion Strong Winds

-- region Coyote Jump

local coyotejump = SMODS.Joker({
	name = "Coyote Jump",
	key = "coyotejump",
    config = {},
	pos = {x = 9, y = 0},
	loc_txt = {
        name = 'Coyote Jump',
        text = {
	"If cards held in hand",
	"do not form a {C:attention}Pair{},",
	"{C:attention}Straight{}, or {C:attention}Flush{},",
	"gain {C:red}+1{} discard"
        }
    },
	rarity = 3,
	cost = 8,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "N/A",
		code = "toneblock",
		concept = "Bred"
	}
})

coyotejump.calculate = function(self, card, context) -- thank you bred?????

	if context.before and not context.blueprint then
	coyotejump_card_array = {}
	coyotejump_ranks = {}
	end

	if context.individual and context.poker_hands ~= nil and not context.blueprint then
       		if context.cardarea == G.hand then
			coyotejump_card_array[#coyotejump_card_array + 1] = context.other_card
			if not coyotejump_ranks[context.other_card:get_id()] then
				coyotejump_ranks[context.other_card:get_id()] = 1
			else
				coyotejump_ranks[context.other_card:get_id()] = coyotejump_ranks[context.other_card:get_id()] + 1
			end
		end
	end
	
	if context.joker_main and context.poker_hands ~= nil then
		local pair_found = false
		for i = 2, 14 do
			if coyotejump_ranks[i] then 
				if coyotejump_ranks[i] > 1 then
					pair_found = true
				end
			end
		end		
		local parts = {
			_flush = get_flush(coyotejump_card_array),
			_straight = get_straight(coyotejump_card_array)
		}
		if next(parts._straight) then
			G.E_MANAGER:add_event(Event({trigger = 'before', delay = immediate, func = function()
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Straight", colour = G.C.RED})
			return true end }))
		elseif next(parts._flush) then
			G.E_MANAGER:add_event(Event({trigger = 'before', delay = immediate, func = function()
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Flush", colour = G.C.RED})
			return true end }))
		elseif pair_found == true then
			G.E_MANAGER:add_event(Event({trigger = 'before', delay = immediate, func = function()
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Pair", colour = G.C.RED})
			return true end }))
		else
			G.E_MANAGER:add_event(Event({trigger = 'before', delay = immediate, func = function()
				ease_discard(1, nil, true)
				card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "+1 Discard", colour = G.C.RED})
			return true end }))
		end
	end
end

-- endregion Coyote Jump

-- region Climbing Gear

local climbinggear = SMODS.Joker({
	name = "Climbing Gear",
	key = "climbinggear",
    config = {d_size = 4},
	pos = {x = 6, y = 1},
	loc_txt = {
        name = 'Climbing Gear',
        text = {
	"{C:red}+4{} discards",
	"Discarded cards are",
	"reshuffled into deck"
        }
    },
	rarity = 2,
	cost = 5,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "goose!"
	}
})

-- literally NO code needs to be here, it's all done in lovely patches

-- endregion Climbing Gear

-- all 3 spinners have basically the same code lol

-- region Blue Spinner

local bluespinner = SMODS.Joker({
	name = "Blue Spinner",
	key = "bluespinner",
    config = {},
	pos = {x = 0, y = 4},
	loc_txt = {
        name = 'Blue Spinner',
        text = {
	"When a card with a {C:planet}Blue Seal{}",
	"is scored, {C:green}#1# in 3{} chance",
	"to add a {C:planet}Blue Seal{} to each",
	"{C:attention}adjacent{} card in scored hand",
	"{C:inactive,s:0.87}(Unaffected by retriggers){}"
        }
    },
	rarity = 2,
	cost = 6,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "N/A",
		code = "toneblock",
		concept = "sunsetquasar"
	}
})

bluespinner.calculate = function(self, card, context)

	if context.before and not context.blueprint then
		if next(find_joker('Rainbow Spinner')) then
			rainbow_spinner_seal_override = true
		else
			rainbow_spinner_seal_override = false
		end
		bluespinner_seal_candidates = {}
		for k = 1, #context.scoring_hand do
			if k == 1 then
				if k ~= #context.scoring_hand then
					if context.scoring_hand[k + 1].seal == 'Blue' or (rainbow_spinner_seal_override == true and context.scoring_hand[k + 1].seal == 'Gold') then
						if pseudorandom('bloo1') < G.GAME.probabilities.normal/3 then
							bluespinner_seal_candidates[#bluespinner_seal_candidates + 1] = context.scoring_hand[k]
						end
					end
				end
			elseif k == #context.scoring_hand then
				if k ~= 1 then
					if context.scoring_hand[k - 1].seal == 'Blue' or (rainbow_spinner_seal_override == true and context.scoring_hand[k - 1].seal == 'Gold') then
						if pseudorandom('bloo2') < G.GAME.probabilities.normal/3 then
							bluespinner_seal_candidates[#bluespinner_seal_candidates + 1] = context.scoring_hand[k]
						end
					end
				end
			else
				if context.scoring_hand[k + 1].seal == 'Blue' or (rainbow_spinner_seal_override == true and context.scoring_hand[k + 1].seal == 'Gold') then
					if pseudorandom('bloo3') < G.GAME.probabilities.normal/3 then
						bluespinner_seal_candidates[#bluespinner_seal_candidates + 1] = context.scoring_hand[k]
					end
				elseif context.scoring_hand[k - 1].seal == 'Blue' or (rainbow_spinner_seal_override == true and context.scoring_hand[k - 1].seal == 'Gold') then
					if pseudorandom('bloo4') < G.GAME.probabilities.normal/3 then
						bluespinner_seal_candidates[#bluespinner_seal_candidates + 1] = context.scoring_hand[k]
					end
				end
			end
		end
		if #bluespinner_seal_candidates > 0 then
			for k = 1, #bluespinner_seal_candidates do
				if (rainbow_spinner_seal_override == true and bluespinner_seal_candidates[k].seal ~= 'Blue' and bluespinner_seal_candidates[k].seal ~= 'Gold') or (rainbow_spinner_seal_override == false and bluespinner_seal_candidates[k].seal ~= 'Blue') then
					G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.0, func = function()
           					bluespinner_seal_candidates[k]:set_seal('Blue', true, false)
						bluespinner_seal_candidates[k]:juice_up()
						play_sound('gold_seal', 1.2, 0.4)
						card:juice_up()
            				return true end }))
					delay(0.5)
				end
			end
		end
	end
end

function bluespinner.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'blue_seal', set = 'Other'}
	return {vars = {''..(G.GAME and G.GAME.probabilities.normal or 1)}}
end

-- endregion Blue Spinner

-- region Purple Spinner

local purplespinner = SMODS.Joker({
	name = "Purple Spinner",
	key = "purplespinner",
    config = {},
	pos = {x = 1, y = 4},
	loc_txt = {
        name = 'Purple Spinner',
        text = {
	"When a card with a {C:tarot}Purple Seal{}",
	"is {C:attention}held{} in hand at end of round,",
	"{C:green}#1# in 3{} chance to add a {C:tarot}Purple Seal{}",
	"to each {C:attention}adjacent{} card in hand",
	"{C:inactive,s:0.87}(Unaffected by retriggers){}"
        }
    },
	rarity = 2,
	cost = 6,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "N/A",
		code = "toneblock",
		concept = "sunsetquasar"
	}
})

purplespinner.calculate = function(self, card, context)

	if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
		if next(find_joker('Rainbow Spinner')) then
			rainbow_spinner_seal_override = true
		else
			rainbow_spinner_seal_override = false
		end
		purplespinner_seal_candidates = {}
		for k = 1, #G.hand.cards do
			if k == 1 then
				if k ~= #G.hand.cards then
					if G.hand.cards[k + 1].seal == 'Purple' or (rainbow_spinner_seal_override == true and G.hand.cards[k + 1].seal == 'Gold') then
						if pseudorandom('purple1') < G.GAME.probabilities.normal/3 then
							purplespinner_seal_candidates[#purplespinner_seal_candidates + 1] = G.hand.cards[k]
						end
					end
				end
			elseif k == #G.hand.cards then
				if k ~= 1 then
					if G.hand.cards[k - 1].seal == 'Purple' or (rainbow_spinner_seal_override == true and G.hand.cards[k - 1].seal == 'Gold') then
						if pseudorandom('is2') < G.GAME.probabilities.normal/3 then
							purplespinner_seal_candidates[#purplespinner_seal_candidates + 1] = G.hand.cards[k]
						end
					end
				end
			else
				if G.hand.cards[k + 1].seal == 'Purple' or (rainbow_spinner_seal_override == true and G.hand.cards[k + 1].seal == 'Gold') then
					if pseudorandom('best3') < G.GAME.probabilities.normal/3 then
						purplespinner_seal_candidates[#purplespinner_seal_candidates + 1] = G.hand.cards[k]
					end
				elseif G.hand.cards[k - 1].seal == 'Purple' or (rainbow_spinner_seal_override == true and G.hand.cards[k - 1].seal == 'Gold') then
					if pseudorandom('colour4') < G.GAME.probabilities.normal/3 then
						purplespinner_seal_candidates[#purplespinner_seal_candidates + 1] = G.hand.cards[k]
					end
				end
			end
		end
		if #purplespinner_seal_candidates > 0 then
			for k = 1, #purplespinner_seal_candidates do
				if (rainbow_spinner_seal_override == true and purplespinner_seal_candidates[k].seal ~= 'Purple' and purplespinner_seal_candidates[k].seal ~= 'Gold') or (rainbow_spinner_seal_override == false and purplespinner_seal_candidates[k].seal ~= 'Purple') then
					G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.0, func = function()
           					purplespinner_seal_candidates[k]:set_seal('Purple', true, false)
						purplespinner_seal_candidates[k]:juice_up()
						play_sound('gold_seal', 1.2, 0.4)
						card:juice_up()
            				return true end }))
					delay(0.5)
				end
			end
		end
	end
end

function purplespinner.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'purple_seal', set = 'Other'}
	return {vars = {''..(G.GAME and G.GAME.probabilities.normal or 1)}}
end


-- region Red Spinner

local redspinner = SMODS.Joker({
	name = "Red Spinner",
	key = "redspinner",
    config = {},
	pos = {x = 2, y = 4},
	loc_txt = {
        name = 'Red Spinner',
        text = {
	"When a card with a {C:red}Red Seal{}",
	"is {C:attention}discarded{}, {C:green}#1# in 3{} chance",
	"to add a {C:red}Red Seal{} to each",
	"{C:attention}adjacent{} card in discarded hand",
	"{C:inactive,s:0.87}(Unaffected by retriggers){}"
        }
    },
	rarity = 2,
	cost = 6,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "N/A",
		code = "toneblock",
		concept = "sunsetquasar"
	}
})

redspinner.calculate = function(self, card, context)

	if context.pre_discard and not context.blueprint then
		if next(find_joker('Rainbow Spinner')) then
			rainbow_spinner_seal_override = true
		else
			rainbow_spinner_seal_override = false
		end
		redspinner_seal_candidates = {}
		for k = 1, #G.hand.highlighted do
			if k == 1 then
				if k ~= #G.hand.highlighted then
					if G.hand.highlighted[k + 1].seal == 'Red' or (rainbow_spinner_seal_override == true and G.hand.highlighted[k + 1].seal == 'Gold') then
						if pseudorandom('RED1') < G.GAME.probabilities.normal/3 then
							redspinner_seal_candidates[#redspinner_seal_candidates + 1] = G.hand.highlighted[k]
						end
					end
				end
			elseif k == #G.hand.highlighted then
				if k ~= 1 then
					if G.hand.highlighted[k - 1].seal == 'Red' or (rainbow_spinner_seal_override == true and G.hand.highlighted[k - 1].seal == 'Gold') then
						if pseudorandom('redge2') < G.GAME.probabilities.normal/3 then
							redspinner_seal_candidates[#redspinner_seal_candidates + 1] = G.hand.highlighted[k]
						end
					end
				end
			else
				if G.hand.highlighted[k + 1].seal == 'Red' or (rainbow_spinner_seal_override == true and G.hand.highlighted[k + 1].seal == 'Gold') then
					if pseudorandom('reeeeeeeed3') < G.GAME.probabilities.normal/3 then
						redspinner_seal_candidates[#redspinner_seal_candidates + 1] = G.hand.highlighted[k]
					end
				elseif G.hand.highlighted[k - 1].seal == 'Red' or (rainbow_spinner_seal_override == true and G.hand.highlighted[k - 1].seal == 'Gold') then
					if pseudorandom('dontknowhattoputhere4') < G.GAME.probabilities.normal/3 then
						redspinner_seal_candidates[#redspinner_seal_candidates + 1] = G.hand.highlighted[k]
					end
				end
			end
		end
		if #redspinner_seal_candidates > 0 then
			for k = 1, #redspinner_seal_candidates do
				if (rainbow_spinner_seal_override == true and redspinner_seal_candidates[k].seal ~= 'Red' and redspinner_seal_candidates[k].seal ~= 'Gold') or (rainbow_spinner_seal_override == false and redspinner_seal_candidates[k].seal ~= 'Red') then
					G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.0, func = function()
           					redspinner_seal_candidates[k]:set_seal('Red', true, false)
						redspinner_seal_candidates[k]:juice_up()
						play_sound('gold_seal', 1.2, 0.4)
						card:juice_up()
            				return true end }))
					delay(0.5)
				end
			end
		end
	end
end

function redspinner.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'red_seal', set = 'Other'}
	return {vars = {''..(G.GAME and G.GAME.probabilities.normal or 1)}}
end

-- endregion Red Spinner

-- region Rainbow Spinner

local rainbowspinner = SMODS.Joker({
	name = "Rainbow Spinner",
	key = "rainbowspinner",
    config = {},
	pos = {x = 3, y = 4},
	loc_txt = {
        name = 'Rainbow Spinner',
        text = {
	"{C:money}Gold Seals{} act as",
	"{C:red,s:1.2,E:1}ev{C:tarot,s:1.2,E:1}e{C:planet,s:1.2,E:1}ry{} seal"
        }
    },
	rarity = 3,
	cost = 11,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "N/A",
		code = "toneblock",
		concept = "sunsetquasar"
	}
})

function rainbowspinner.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'gold_seal', set = 'Other'}
end

-- i think i'm just gonna hardcode this using lovely? hate to do it but... whatever, no mod compat sucks though, and at least it looks clean on the user end

-- endregion Rainbow Spinner

-- region Letting Go

local lettinggo = SMODS.Joker({
	name = "Letting Go",
	key = "lettinggo",
    config = {extra = {mult = 0}},
	pos = {x = 2, y = 2},
	loc_txt = {
        name = 'Letting Go',
        text = {
	"When a card is destroyed,",
	"{C:green}#1# in 2{} chance to create",
	"a {C:tarot}Death{}",
	"Gains {C:mult}+4{} Mult for each",
	"{C:tarot}Death{} used",
	"{C:inactive}(Must have room)",
	"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
        }
    },
	rarity = 3,
	cost = 8,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "j_ccc_jokers",
	credit = {
		art = "bein",
		code = "toneblock",
		concept = "Gappie"
	}
})

lettinggo.calculate = function(self, card, context)

	if context.cards_destroyed then
                local death_chances = 0
		for k, v in ipairs(context.glass_shattered) do
                    death_chances = death_chances + 1
                end
		for i = 1, death_chances do
			if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
				if pseudorandom('lettinggo') < G.GAME.probabilities.normal/2 then
					G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
					G.E_MANAGER:add_event(Event({
                    			func = (function()
                        			G.E_MANAGER:add_event(Event({
                            			func = function() 
                                			local card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_death', 'lgo')
                               				card:add_to_deck()
                                			G.consumeables:emplace(card)
                                			G.GAME.consumeable_buffer = 0
                                			return true
                            			end}))   
                            			card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})                       
                        		return true
                    			end)}))
				end
			end
		end
	end

	if context.remove_playing_cards then -- it's just the same thing as before, folks
		local death_chances = 0
		for k, val in ipairs(context.removed) do
                    death_chances = death_chances + 1
                end
		for i = 1, death_chances do
			if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
				if pseudorandom('lettinggo') < G.GAME.probabilities.normal/2 then
					G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
					G.E_MANAGER:add_event(Event({
                    			func = (function()
                        			G.E_MANAGER:add_event(Event({
                            			func = function() 
                                			local card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_death', 'lgo')
                               				card:add_to_deck()
                                			G.consumeables:emplace(card)
                                			G.GAME.consumeable_buffer = 0
                                			return true
                            			end}))   
                            			card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})                       
                        		return true
                    			end)}))
				end
			end
		end
	end

	if context.using_consumeable then
		if context.consumeable.ability.name == 'Death' then
			if not context.blueprint then
				card.ability.extra.mult = card.ability.extra.mult + 4
				card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}})
			end
		end
	end

	if context.joker_main then
		if card.ability.extra.mult ~= 0 then
                	return {
                   	message = localize {
                  		type = 'variable',
                   		key = 'a_mult',
                  		vars = { card.ability.extra.mult }
                		},
                	mult_mod = card.ability.extra.mult
                	}
		end
	end
end

function lettinggo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = G.P_CENTERS.c_death
	return {vars = {''..(G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.mult}}
end

-- endregion Letting Go

-- region Green Bubble

local greenbooster = SMODS.Joker({
	name = "Green Booster",
	key = "greenbooster",
    config = {},
	pos = {x = 3, y = 2},
	loc_txt = {
        name = 'Green Booster',
        text = {
	"Adds an {C:attention}extra{} card",
	"to all {C:attention}Booster Packs{}"
        }
    },
	rarity = 2,
	cost = 6,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "bein",
		code = "toneblock",
		concept = "sunsetquasar"
	}
})

-- lovely abuse

greenbooster.calculate = function(self, card, context)
	if context.open_booster then
		ccc_grubble_bonus_choices = (ccc_grubble_bonus_choices or 0) + 1
		card:juice_up()
	end
end

-- endregion Green Booster

-- region Red Booster

local redbooster = SMODS.Joker({
	name = "Red Booster",
	key = "redbooster",
    config = {},
	pos = {x = 3, y = 3},
	loc_txt = {
        name = 'Red Booster',
        text = {
	"Allows you to {C:attention}choose{}",
	"{C:attention}1{} extra card",
	"from all {C:attention}Booster Packs{}"
        }
    },
	rarity = 3,
	cost = 8,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "N/A",
		code = "toneblock",
		concept = "sunsetquasar"
	}
})

-- more lovely abuse

redbooster.calculate = function(self, card, context)
	if context.open_booster then
		ccc_rrubble_bonus_choices = (ccc_rrubble_bonus_choices or 0) + 1
		card:juice_up()
	end
end

-- endregion Red Booster

-- region Cassette Block

local cassetteblock = SMODS.Joker({
	name = "Cassette Block",
	key = "cassetteblock",
    config = {extra = {chips = 0, mult = 0, pink = false, pos_override = {x = 6, y = 2}}},
	pos = {x = 6, y = 2},
	loc_txt = {
        name = ('Cassette Block'),
        text = {
	"Gains {C:chips}+7{} Chips for each",
	"{C:attention}unused{} {C:chips}hand{} at end of round",
	"{C:mult}Swaps{} at start of round",
	"{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips){}",
        }
    },
	rarity = 3,
	cost = 8,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "j_ccc_jokers",
	credit = {
		art = "N/A",
		code = "toneblock",
		concept = "Gappie"
	},
	process_loc_text = function(self)
		SMODS.process_loc_text(G.localization.descriptions[self.set], self.key, self.loc_txt)
		SMODS.process_loc_text(G.localization.descriptions[self.set], "Cassette Block", {
				name = ('Cassette Block'),
				text = {
					"Gains {C:mult}+2{} Mult for each",
					"{C:attention}unused{} {C:mult}discard{} at end of round",
					"{C:chips}Swaps{} at start of round",
					"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult){}",
				}
		})
	end,
	afterload = function(self, card, card_table, other_card)
		card.children.center:set_sprite_pos(card_table.ability.extra.pos_override)
	end
})

cassetteblock.calculate = function(self, card, context)

	if context.setting_blind and not context.blueprint then

		if card.ability.extra.pink == false then
			return {
			G.E_MANAGER:add_event(Event({func = function()
			
			G.E_MANAGER:add_event(Event({func = function()
			
			card.ability.extra.pink = true
			card.ability.extra.pos_override.x = 7
			card.children.center:set_sprite_pos(card.ability.extra.pos_override)
			
			return true end }))
			card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Swap", colour = G.C.RED})
			return true end }))
			}
		else
			return {
			G.E_MANAGER:add_event(Event({func = function()
			
			G.E_MANAGER:add_event(Event({func = function()
			
			card.ability.extra.pink = false
			card.ability.extra.pos_override.x = 6
			card.children.center:set_sprite_pos(card.ability.extra.pos_override)
			
			return true end }))
			card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Swap", colour = G.C.BLUE})
			return true end }))
			}
		end
	end

	if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then

		if card.ability.extra.pink == false then
			if G.GAME.current_round.hands_left > 0 then
				card.ability.extra.chips = card.ability.extra.chips + 7*G.GAME.current_round.hands_left

				G.E_MANAGER:add_event(Event({func = function()
				card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Upgrade!", colour = G.C.FILTER})
				return true end }))
			end
		else
			if G.GAME.current_round.discards_left > 0 then
				card.ability.extra.mult = card.ability.extra.mult + 2*G.GAME.current_round.discards_left

				G.E_MANAGER:add_event(Event({func = function()
				card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Upgrade!", colour = G.C.FILTER})
				return true end }))
			end
		end
	end

	if context.joker_main then
		if card.ability.extra.pink == false then
			if card.ability.extra.chips ~= 0 then
                		return {
                  	 	message = localize {
                  			type = 'variable',
                   			key = 'a_chips',
                  			vars = { card.ability.extra.chips }
                			},
                		chip_mod = card.ability.extra.chips
                		}
			end
		else
			if card.ability.extra.mult ~= 0 then
                		return {
                  	 	message = localize {
                  			type = 'variable',
                   			key = 'a_mult',
                  			vars = { card.ability.extra.mult }
                			},
                		mult_mod = card.ability.extra.mult
                		}
			end
		end
	end
end

function cassetteblock.loc_vars(self, info_queue, card)
	return {key = (card.ability.extra.pink and "Cassette Block" or card.config.center.key), vars = {card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.pink}}
end

-- region Bumper

local bumper = SMODS.Joker({
	name = "Bumper",
	key = "bumper",
    config = {},
	pos = {x = 7, y = 1},
	loc_txt = {
        name = 'Bumper',
        text = {
	"If {C:mult}discards{} {C:attention}>{} {C:chips}hands{}, {C:mult}+16{} Mult",
	"If {C:chips}hands{} {C:attention}>{} {C:mult}discards{}, {C:chips}+60{} Chips",
	"If both are {C:attention}equal{}, does {C:inactive}nothing{}"
        }
    },
	rarity = 1,
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "N/A",
		code = "toneblock",
		concept = "Aurora Aquir"
	}
})

bumper.calculate = function(self, card, context)
	
	if context.joker_main then

		if G.GAME.current_round.hands_left > G.GAME.current_round.discards_left then
                	return {
                  	 message = localize {
                  		type = 'variable',
                   		key = 'a_chips',
                  		vars = { 60 }
                		},
                	chip_mod = 60
                	}
		elseif G.GAME.current_round.discards_left > G.GAME.current_round.hands_left then
                	return {
                  	 message = localize {
                  		type = 'variable',
                   		key = 'a_mult',
                  		vars = { 16 }
                		},
                	mult_mod = 16
                	}
		else
			if not context.blueprint then
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Equal", colour = G.C.RED})
			end
		end
	end
end

-- endregion Bumper

-- region Waterfall

local waterfall = SMODS.Joker({
	name = "Waterfall",
	key = "waterfall",
    config = {},
	pos = {x = 5, y = 2},
	loc_txt = {
        name = 'Waterfall',
        text = {
	"If played hand contains a",
	"{C:attention}Flush{}, convert a random",
	"card {C:attention}held{} in hand to",
	"the same {C:attention}suit{}"
        }
    },
	rarity = 1,
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "N/A",
		code = "toneblock",
		concept = "Bred"
	}
})

waterfall.calculate = function(self, card, context)
	if context.before and context.poker_hands ~= nil and next(context.poker_hands['Flush']) and not context.blueprint then

		local suits = {}
		local used_suits = {}
		for i = 1, #context.scoring_hand do
			if context.scoring_hand[i].ability.name ~= 'Wild Card' then
				if not suits[context.scoring_hand[i].base.suit] then
					suits[context.scoring_hand[i].base.suit] = 1
					used_suits[#used_suits + 1] = context.scoring_hand[i].base.suit
				else
					suits[context.scoring_hand[i].base.suit] = suits[context.scoring_hand[i].base.suit] + 1
				end
			end
		end
		local value = 0
		if #used_suits ~= 0 then
			for i = 1, #used_suits do
				if suits[used_suits[i]] > value then
					ccc_waterfall_flush_suit = used_suits[i]
					value = suits[used_suits[i]]
				end
			end
		else
			ccc_waterfall_flush_suit = 'Wild'
		end

		local waterfall_card_candidates = {}
		if ccc_waterfall_flush_suit ~= 'Wild' then
			for i = 1, #G.hand.cards do
				if not G.hand.cards[i]:is_suit(ccc_waterfall_flush_suit, true) then
					waterfall_card_candidates[#waterfall_card_candidates + 1] = G.hand.cards[i]
				end
			end
		else
			for i = 1, #G.hand.cards do
				if G.hand.cards[i].ability.name ~= 'Wild Card' or G.hand.cards[i].ability.name ~= 'Steel Card' or G.hand.cards[i].ability.name ~= 'Gold Card' then
					waterfall_card_candidates[#waterfall_card_candidates + 1] = G.hand.cards[i]
				end
			end
		end
		if #waterfall_card_candidates > 0 then  -- copying more bunco code... firch ily
			local waterfall_card = pseudorandom_element(waterfall_card_candidates, pseudoseed('waterfall'))
			if ccc_waterfall_flush_suit ~= 'Wild' then
					waterfall_card:change_suit(ccc_waterfall_flush_suit)
			else
					waterfall_card:set_ability(G.P_CENTERS.m_wild)
			end
			waterfall_card:juice_up()
			card:juice_up()
			play_sound('tarot1', 0.8, 0.4)
		end
	end
end
				
-- endregion Waterfall

-- region Collapsing Bridge

local collapsingbridge = SMODS.Joker({
	name = "Collapsing Bridge",
	key = "collapsingbridge",
    config = {extra = {xmult = 5}},
	pos = {x = 8, y = 1},
	loc_txt = {
        name = 'Collapsing Bridge',
        text = {
	"{X:mult,C:white} X#2# {} Mult when played hand",
	"contains a {C:attention}Straight{}",
	"All played cards have a {C:green}#1# in 5{}",
	"chance of being {C:red}destroyed{}"
        }
    },
	rarity = 3,
	cost = 8,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "N/A",
		code = "toneblock",
		concept = "Gappie"
	}
})

collapsingbridge.calculate = function(self, card, context)
	
	if context.joker_main then

		if not context.blueprint then
			local cards_destroyed = {}
			for k, v in ipairs(context.full_hand) do
				if pseudorandom('bridge') < G.GAME.probabilities.normal/5 then
					cards_destroyed[#cards_destroyed+1] = v
					if v.ability.name == 'Glass Card' then 
						v.shattered = true
					else 
						v.destroyed = true
					end 
				end
			end
			
			for j=1, #G.jokers.cards do
				eval_card(G.jokers.cards[j], {cardarea = G.jokers, remove_playing_cards = true, removed = cards_destroyed})
			end
			for i=1, #cards_destroyed do
				highlight_card(cards_destroyed[i],(1-0.999)/(#context.full_hand-0.998),'down')
				G.E_MANAGER:add_event(Event({
					func = function()
						if cards_destroyed[i].ability.name == 'Glass Card' then 
							cards_destroyed[i]:shatter()
						else
							cards_destroyed[i]:start_dissolve()
						end
					return true
					end
				}))
			end
		end

		if next(context.poker_hands['Straight']) then
                	return {
			message = localize {
				type = 'variable',
				key = 'a_xmult',
				vars = { card.ability.extra.xmult }
                		},
                	Xmult_mod = card.ability.extra.xmult
                	}
		end
	end
end

function collapsingbridge.loc_vars(self, info_queue, card)
	return {vars = {''..(G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.xmult}}
end

-- endregion Collapsing Bridge

-- region Switch Gate

local switchgate = SMODS.Joker({
	name = "Switch Gate",
	key = "switchgate",
	config = {extra = {chips = 0, cards = {[1] = {rank = 'Ace', suit = 'Spades', id = 14}, [2] = {rank = 'Ace', suit = 'Hearts', id = 14}, [3] = {rank = 'Ace', suit = 'Clubs', id = 14}}}},
	pos = {x = 4, y = 3},
	loc_txt = {
	name = 'Switch Gate',
	text = {
	"Gains {C:chips}+10{} Chips if {C:attention}any{} of the",
	"following cards are scored:",
	"{C:attention}#2#{} of {V:1}#3#{}",
	"{C:attention}#4#{} of {V:2}#5#{}",
	"{C:attention}#6#{} of {V:3}#7#{}",
	"{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips){}",
	"{s:0.8}Cards change every round"
	}
    },
	rarity = 1,
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "j_ccc_jokers",
	credit = {
		art = "N/A",
		code = "toneblock",
		concept = "Gappie"
	}
})

switchgate.set_ability = function(self, card, initial, delay_sprites)	-- shamelessly copied from idol
	local valid_gate_cards = {}
	if G.playing_cards ~= nil then
		for k, v in ipairs(G.playing_cards) do
			if v.ability.effect ~= 'Stone Card' then
				valid_gate_cards[#valid_gate_cards+1] = v
			end
		end
		if valid_gate_cards[1] then
			for i = 1, 3 do
				local gate_card = pseudorandom_element(valid_gate_cards, pseudoseed('switchgate'..G.GAME.round_resets.ante))
				card.ability.extra.cards[i].rank = gate_card.base.value
				card.ability.extra.cards[i].suit = gate_card.base.suit
				card.ability.extra.cards[i].id = gate_card.base.id
			end
		end
	end
end

-- this may work. but it may also break. i hope it doesn't but i won't be surprised if it does

switchgate.calculate = function(self, card, context)

	if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
		local valid_gate_cards = {}
		for k, v in ipairs(G.playing_cards) do
			if v.ability.effect ~= 'Stone Card' then
				valid_gate_cards[#valid_gate_cards+1] = v
			end
		end
		if valid_gate_cards[1] then
			for i = 1, 3 do
				local gate_card = pseudorandom_element(valid_gate_cards, pseudoseed('switchgate'..G.GAME.round_resets.ante))
				card.ability.extra.cards[i].rank = gate_card.base.value
				card.ability.extra.cards[i].suit = gate_card.base.suit
				card.ability.extra.cards[i].id = gate_card.base.id
			end
		end
	end

	if context.individual and not context.blueprint then
		if context.cardarea == G.play then
			for i = 1, 3 do
				if context.other_card:get_id() == card.ability.extra.cards[i].id and context.other_card:is_suit(card.ability.extra.cards[i].suit) then
					card.ability.extra.chips = card.ability.extra.chips + 10
					card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Upgrade!", colour = G.C.FILTER})
				end
			end
		end
	end

	if context.joker_main then
		if card.ability.extra.chips ~= 0 then
                	return {
                    	message = localize {
                        	type = 'variable',
                        	key = 'a_chips',
                        	vars = { card.ability.extra.chips }
                    	},
			chip_mod = card.ability.extra.chips
                	}
		end
	end
end

function switchgate.loc_vars(self, info_queue, card)	-- what a mess
	return {vars = {
		card.ability.extra.chips, 
		localize(card.ability.extra.cards[1].rank, 'ranks'), 
		localize(card.ability.extra.cards[1].suit, 'suits_plural'), 
		localize(card.ability.extra.cards[2].rank, 'ranks'), 
		localize(card.ability.extra.cards[2].suit, 'suits_plural'), 
		localize(card.ability.extra.cards[3].rank, 'ranks'), 
		localize(card.ability.extra.cards[3].suit, 'suits_plural'),
		colours = {
			G.C.SUITS[card.ability.extra.cards[1].suit], 
			G.C.SUITS[card.ability.extra.cards[2].suit], 
			G.C.SUITS[card.ability.extra.cards[3].suit]
		}
	}
}
end

-- endregion Switch Gate	

-- region Checkpoint

local checkpoint = SMODS.Joker({
	name = "Checkpoint",
	key = "checkpoint",
    config = {extra = {xmult = 1, did_you_discard = false, after_boss = false}},
	pos = {x = 8, y = 2},
	loc_txt = {
        name = 'Checkpoint',
        text = {
	"Gains {X:mult,C:white} X1#{} Mult if",
	"{C:attention}Boss Blind{} is defeated",
	"without {C:red}discarding{}",
	"{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult)"
        }
    },
	rarity = 3,
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Gappie"
	}
})


checkpoint.calculate = function(self, card, context)

	if context.setting_blind and not context.blueprint then
		card.ability.extra.did_you_discard = false
		if context.blind.boss then
			card.ability.extra.after_boss = true
		else
			card.ability.extra.after_boss = false
		end
	end

	if context.discard and not context.blueprint then
		if card.ability.extra.after_boss == true and card.ability.extra.did_you_discard == false then
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Discarded", colour = G.C.RED})
			card.ability.extra.did_you_discard = true
		end
	end
	
	if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
		if card.ability.extra.after_boss == true and card.ability.extra.did_you_discard == false then
			card.ability.extra.xmult = card.ability.extra.xmult + 1
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.xmult}}})
		end
	end
		
	if context.joker_main then
            	if card.ability.extra.xmult ~= 1 then
                	return {
                    	message = localize {
                        	type = 'variable',
                        	key = 'a_xmult',
                        	vars = { card.ability.extra.xmult }
                    	},
			Xmult_mod = card.ability.extra.xmult
                	}
		end
	end
end

function checkpoint.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.xmult}}
end

-- endregion Checkpoint

-- region Theo Crystal

local theocrystal = SMODS.Joker({
	name = "Theo Crystal",
	key = "theocrystal",
	config = {extra = {base_probs = 0, base_scale = 1, scale = 1, probs = 0}},
	pos = {x = 9, y = 2},
	loc_txt = {
	name = 'Theo Crystal',
	text = {
	"Forces 1 card to",
	"{C:attention}always{} be selected",
	"Adds {C:green}+#1#{} to all {C:attention}listed{}",
	"{C:green,E:1}probabilities{} at round end",
	"{C:inactive}(ex: {C:green}2 in 7{C:inactive} -> {C:green}3 in 7{C:inactive})",
	"{C:inactive}(Currently {C:green}+#2#{C:inactive})"
	}
    },
	rarity = 3,
	cost = 9,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "N/A",
		code = "toneblock",
		concept = "toneblock"
	}
})

-- lovely injections to deal with the probability system (what a pain)

-- scale and probs are only for display purposes and are not actually used

-- also using lovely to hijack Blind:drawn_to_hand? this is so scuffed

theocrystal.calculate = function(self, card, context)

	if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
		card.ability.extra.base_probs = card.ability.extra.base_probs + card.ability.extra.base_scale
		local oops_factor = 1
		for i = 1, #G.jokers.cards do
			if G.jokers.cards[i].ability.set == 'Joker' then
				if G.jokers.cards[i].ability.name == 'Oops! All 6s' then
					oops_factor = oops_factor*2
				end
			end
		end
		for k, v in pairs(G.GAME.probabilities) do 
			G.GAME.probabilities[k] = v + card.ability.extra.base_scale*oops_factor		-- this is fragile but should work in normal circumstances
		end
		card_eval_status_text(card, 'extra', nil, nil, nil, {message = "+"..(oops_factor), colour = G.C.GREEN})
	end
end

function theocrystal.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.scale, card.ability.extra.probs}}
end

-- endregion Theo Crystal

-- region Pointless Machines

local pointlessmachines = SMODS.Joker({
	name = "Pointless Machines",
	key = "pointlessmachines",
    config = {extra = {incorrect = false, reset = false, suits = {[1] = 'Hearts', [2] = 'Spades', [3] = 'Diamonds', [4] = 'Clubs', [5] = 'Hearts'}}},
	pos = {x = 9, y = 1},
	loc_txt = {
        name = 'Pointless Machines',
        text = {
	""
        }
    },
	rarity = 1,
	cost = 5,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "goose!",
		code = "toneblock",
		concept = "Fytos"
	}
})

pointlessmachines.set_ability = function(self, card, initial, delay_sprites)
        for i = 1, 5 do
		card.ability.extra.suits[i] = pseudorandom_element({'Hearts', 'Spades', 'Diamonds', 'Clubs'}, pseudoseed('initialize'))
	end
end

pointlessmachines.calculate = function(self, card, context)
	if context.before and not context.blueprint then
		card.ability.extra.incorrect = false
		if #context.full_hand == 5 then
			for i = 1, 5 do
				if not context.full_hand[i]:is_suit(card.ability.extra.suits[i], true) then
					card.ability.extra.incorrect = true
				end
			end
		else
			card.ability.extra.incorrect = true
		end
		if card.ability.extra.incorrect == false then
			card.ability.extra.reset = true
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Correct", colour = G.C.GREEN})
			local temp_dollars = pseudorandom('littlemoney', 4, 7)
				ease_dollars(temp_dollars)
				G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + temp_dollars
				G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
				return {
					message = localize('$')..temp_dollars,
					dollars = temp_dollars,
				colour = G.C.MONEY
				}
		else
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Incorrect", colour = G.C.RED})
		end
	end
	
	if context.joker_main and card.ability.extra.incorrect == false and not context.blueprint then	-- 1/3 chance for mult, 2/3 chance for chips
		if pseudorandom('chipsormult', 0, 2) > 1 then 
			local temp_Mult = pseudorandom('misprintcopylmao', 18, 45)
                            return {
                                message = localize{type='variable',key='a_mult',vars={temp_Mult}},
                                mult_mod = temp_Mult
                            }
		else
			local temp_chips = pseudorandom('misprintbutchips', 80, 145)
                            return {
                                message = localize{type='variable',key='a_chips',vars={temp_chips}},
                                chip_mod = temp_chips
                            }
		end
	end

	if context.after and card.ability.extra.reset == true and not context.blueprint then
		for i = 1, 5 do
			card.ability.extra.suits[i] = pseudorandom_element({'Hearts', 'Spades', 'Diamonds', 'Clubs'}, pseudoseed('reinitialize'))
		end
		card.ability.extra.reset = false
	end
end				

-- endregion Pointless Machines	

-- region Lapidary

local lapidary = SMODS.Joker({
	name = "Lapidary",
	key = "lapidary",
    config = {extra = 1.5},
	pos = {x = 6, y = 3},
	loc_txt = {
        name = 'Lapidary',
        text = {
	"Jokers with a unique rarity",
	"each give {X:mult,C:white}X#1#{} mult",
        }
    },
	rarity = 2,
	cost = 8,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "N/A",
		code = "Aurora Aquir",
		concept = "Aurora Aquir"
	}
})


function lapidary.loc_vars(self, info_queue, card)
	return {vars = {
		card.ability.extra,
	}
}
end

lapidary.calculate = function(self, card, context)
	if context.other_joker then
		local uniqueRarity = true 
		for i = 1, #G.jokers.cards do
			if G.jokers.cards[i] ~= context.other_joker and G.jokers.cards[i].config.center.rarity == context.other_joker.config.center.rarity then
				uniqueRarity = false
				break
			end
		end

		if uniqueRarity then
			G.E_MANAGER:add_event(Event({
				func = function()
					context.other_joker:juice_up(0.5, 0.5)
					return true
				end
			})) 
			return {
				message = localize{type='variable',key='a_xmult',vars={card.ability.extra}},
				Xmult_mod = card.ability.extra
			}
		end
	end
end

function lapidary.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra}}
end

-- endregion lapidary

-- region hardlist

local hardlist = SMODS.Joker({
	name = "hardlist",
	key = "hardlist",
    config = {extra = {mult = 25, sub = 5}}, -- mult should be a multiple of sub for this card
	pos = {x = 5, y = 3},
	loc_txt = {
        name = '5-Star Hardlist',
        text = {
			"{C:mult}+#1#{} Mult",
			"{C:mult}-#2#{} Mult for every",
			"{C:attention}Joker{} purchased"
        }
    },
	rarity = 1,
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Aurora Aquir",
		code = "Aurora Aquir",
		concept = "Aurora Aquir"
	}
})



hardlist.calculate = function(self, card, context)
	if context.buying_card and context.card.config.center.set == "Joker" then
		if not context.blueprint then
			card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.sub
			if card.ability.extra.mult <= 0 then
				G.E_MANAGER:add_event(Event({
				func = function()
					card_eval_status_text(card, 'extra', nil, nil, nil, {
						message = "Standard!",
						colour = G.C.RED
					});
					G.E_MANAGER:add_event(Event({trigger = 'after',
						func = function()
							play_sound('tarot1')
							card.T.r = -0.2
							card:juice_up(0.3, 0.4)
							card.states.drag.is = true
							card.children.center.pinch.x = true
							G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
								func = function()
										G.jokers:remove_card(card)
										card:remove()
										card = nil
									return true; end})) 
							return true
						end
					})) 
					return true
				end}))
			else
				G.E_MANAGER:add_event(Event({
					func = function() card_eval_status_text(card, 'extra', nil, nil, nil, {
						message = string.format("%d-Star!", card.ability.extra.mult/card.ability.extra.sub),
						colour = G.C.RED
					}); return true
					end}))
			end
		end
	elseif context.joker_main then
		return {
			message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
			mult_mod = card.ability.extra.mult
		}
	end
end


function hardlist.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.mult, card.ability.extra.sub}}
end
-- endregion hardlist

-- region cloud

local cloud = SMODS.Joker({
	name = "cloud",
	key = "cloud",
    config = {extra = {chips = 0, add = 30}},
	pos = {x = 4, y = 4},
	loc_txt = {
        name = 'Cloud',
        text = {
			"{C:chips}+#1#{} Chips for each",
			"{C:blue}Hand{} played this round",
			"{C:inactive}(Currently {C:blue}+#2#{C:inactive})"
        }
    },
	rarity = 1,
	cost = 4,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "N/A",
		code = "Aurora Aquir",
		concept = "Aurora Aquir"
	}
})



cloud.calculate = function(self, card, context)

	if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
		card.ability.extra.chips = 0
	elseif context.cardarea == G.jokers and context.after and not context.blueprint then
		card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.add
	elseif context.joker_main and card.ability.extra.chips > 0 then
		return {
			message = localize {
				type = 'variable',
				key = 'a_chips',
				vars = { card.ability.extra.chips }
			},
			chip_mod = card.ability.extra.chips
		}
	end
end


function cloud.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.add, card.ability.extra.chips}}
end
-- endregion cloud

-- region brittle cloud

local brittlecloud = SMODS.Joker({
	name = "brittlecloud",
	key = "brittlecloud",
    config = {extra = {chips = 150}},
	pos = {x = 5, y = 4},
	loc_txt = {
        name = 'Brittle Cloud',
        text = {
			"{C:chips}+#1#{} Chips on the",
			"first {C:blue}Hand{} played this round",
        }
    },
	rarity = 1,
	cost = 4,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "N/A",
		code = "Aurora Aquir",
		concept = "Aurora Aquir"
	}
})


brittlecloud.calculate = function(self, card, context)

	if context.joker_main and G.GAME.current_round.hands_played == 0 then
		return {
			message = localize {
				type = 'variable',
				key = 'a_chips',
				vars = { card.ability.extra.chips }
			},
			chip_mod = card.ability.extra.chips
		}
	end
end


function brittlecloud.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.chips}}
end
-- endregion brittle cloud

-- region seeker

local seeker = SMODS.Joker({
	name = "Seeker",
	key = "seeker",
    config = {extra = {suit = "Hearts", rank = "Ace"}},
	pos = {x = 6, y = 4},
	loc_txt = {
        name = 'Seeker',
        text = {
			"If card drawn is not",
			"most owned Suit ({C:attention}#1#{})",
			"or most owned Rank ({V:1}#2#{})",
			"place it back in deck and",
			"draw one more card",
        }
    },
	rarity = 3,
	cost = 10,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "N/A",
		code = "Aurora Aquir",
		concept = "Aurora Aquir"
	},
	load = function (self, card, card_table, other_card)
		G.GAME.pool_flags.seeker_table = {
			rank = card_table.ability.extra.rank,
			suit = card_table.ability.extra.suit,
			ref = card
		}
	end,
	remove_from_deck = function (self, card, from_debuff)
		G.GAME.pool_flags.seeker_table = nil
		for _, v in ipairs(G.jokers.cards) do
			if v ~= card and v.ability.name == "Seeker" and not v.debuff then
				G.GAME.pool_flags.seeker_table = {
					rank = v.ability.extra.rank,
					suit = v.ability.extra.suit,
					ref = v
				}
			end
		end
	end
})

seeker.get_common_suit_and_ranks = function (card)
	local ranks = {}
	local suits = {}
	if G.playing_cards ~= nil then
		for index, card in ipairs(G.playing_cards) do
			ranks[card.base.value] = (ranks[card.base.value] or 0) + 1
			suits[card.base.suit] = (ranks[card.base.suit] or 0) + 1
		end
	end
	local most_common_suit = {
		key = "Hearts",
		value = -1
	}
	local most_common_rank= {
		key = "Ace",
		value = -1
	}
	for key, value in pairs(ranks) do
		if value > most_common_rank.value then
			most_common_rank.key = key
			most_common_rank.value = value
		end
	end
	for key, value in pairs(suits) do
		if value > most_common_suit.value then
			most_common_suit.key = key
			most_common_suit.value = value
		end
	end
	card.ability.extra.rank = most_common_rank.key
	card.ability.extra.suit = most_common_suit.key

	G.GAME.pool_flags.seeker_table = {
		rank = card.ability.extra.rank,
		suit = card.ability.extra.suit,
		ref = card
	}
end

seeker.set_ability = function(self, card, initial, delay_sprites)
	seeker.get_common_suit_and_ranks(card)
end

seeker.calculate = function(self, card, context)
	seeker.get_common_suit_and_ranks(card)
end

function seeker.loc_vars(self, info_queue, card)
	return {vars = {
		localize(card.ability.extra.rank, 'ranks'), 
		localize(card.ability.extra.suit, 'suits_plural'),
		colours = {
			G.C.SUITS[card.ability.extra.suit], }}}
end
-- endregion seeker

-- region Badeline

local badeline = SMODS.Joker({
	name = "Badeline",
	key = "badeline",
    config = {extra = {}},
	pos = {x = 7, y = 3},
	loc_txt = {
        name = 'Badeline',
        text = {
	"Retrigger all {C:attention}Glass{} cards",
	"and all {C:dark_edition}Mirrored{} cards",
	"{C:attention}Sustains{} {C:dark_edition}Mirrored{} cards"
        }
    },
	rarity = 4,
	cost = 20,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "j_ccc_jokers",
	credit = {
		art = "N/A",
		code = "toneblock",
		concept = "Gappie"
	}
})

badeline.yes_pool_flag = 'preventsoulspawn'

-- huge jank on calculate but i don't even know tbh... card = card????????? it shouldn't need that...

badeline.calculate = function(self, card, context)
	if context.repetition then
		if context.cardarea == G.play then
			if (context.other_card.edition and context.other_card.edition.mirrored) or context.other_card.ability.effect == 'Glass Card' then
				return {
					message = localize('k_again_ex'),
					repetitions = 1,
					card = card
				}
			end
		elseif context.cardarea == G.hand then
			if (context.other_card.edition and context.other_card.edition.mirrored) or context.other_card.ability.effect == 'Glass Card' and (next(context.card_effects[1]) or #context.card_effects > 1) then
				return {
					message = localize('k_again_ex'),
					repetitions = 1,
					card = card
				}
			end
		end
	end
end

function badeline.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'e_mirrored', set = 'Other'}
	info_queue[#info_queue+1] = G.P_CENTERS.m_glass
	return {vars = {}}
end

-- endregion Checkpoint


-- region Madeline

-- USES GLOBAL VARIABLE
local madeline = SMODS.Joker({
	name = "Madeline",
	key = "madeline",
    config = {},
	pos = {x = 8, y = 3},
	loc_txt = {
        name = 'Madeline',
        text = {
			"Prevents reduction of",
			"{C:attention}Joker{} values through",
			"their own abilities"
        }
    },
	rarity = 4,
	cost = 20,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "N/A",
		code = "Aurora Aquir",
		concept = "Aurora Aquir"
	},
	add_to_deck = function (self, card, from_debuff)
		G.GAME.pool_flags.madeline_in_hand = card
	end,
	remove_from_deck = function (self, card, from_debuff)
		G.GAME.pool_flags.madeline_in_hand = nil
		for _, v in ipairs(G.jokers.cards) do
			if v ~= card and v.ability.name == "Madeline" and not v.debuff then
				G.GAME.pool_flags.madeline_in_hand = v
			end
		end
	end,
	load = function (self, card, card_table, other_card)
		G.GAME.pool_flags.madeline_in_hand = card
	end
})

local calculate_joker_ref = Card.calculate_joker
function Card.calculate_joker(self, context)
	local prevent = G.GAME.pool_flags.madeline_in_hand or false
	local orig_values = {}
	if self.ability and self.ability.set == "Joker" then
		if prevent then
			for index, value in pairs(self.ability) do
				if type(value) == "number" then
					orig_values[index] = value
				end
			end

			if type(self.ability.extra) == "table" then
				orig_values["extra"] = {}
				for index, value in pairs(self.ability.extra) do
					if type(value) == "number" then
						orig_values.extra[index] = value
					end
				end
			end

		end
	end
	local ret = calculate_joker_ref(self, context)
	if prevent then
		for index, value in pairs(orig_values) do
			if type(value) == "number" and self.ability[index] < orig_values[index]  then
				self.ability[index] = orig_values[index] 
				card_eval_status_text(prevent, 'extra', nil, nil, nil, {
					message = "Prevent!",
					colour = G.C.RED
				});
			end
		end

		if type(self.ability.extra) == "table" then
			for index, value in pairs(orig_values.extra) do
				if type(value) == "number" and self.ability.extra[index] < orig_values.extra[index]  then
					self.ability.extra[index] = orig_values.extra[index] 
					card_eval_status_text(prevent, 'extra', nil, nil, nil, {
						message = "Prevent!",
						colour = G.C.RED
					})
					-- Give back hand size from turtle bean that would be taken (if bean will not be destroyed)
					if self.ability.name == 'Turtle Bean' and not context.blueprint and index == "h_size" and self.ability.extra.h_size > 1 then
						G.hand:change_size(self.ability.extra.h_mod)
					end
				end
			end
			
		end
	end

	return ret
end

-- endregion Madeline



sendDebugMessage("[CCC] Jokers loaded")