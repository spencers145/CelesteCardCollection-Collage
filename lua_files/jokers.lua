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
	atlas = "j_ccc_jokers"
})

templeeyes.calculate = function(self, context)
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
                            card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})                       
                        return true
                    end)}))}
		end
        end
end

function templeeyes.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = G.P_CENTERS.c_hanged_man
end

-- endregion Temple Eyes

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
	atlas = "j_ccc_jokers"
})

feather.calculate = function(self, context)
        if SMODS.end_calculate_context(context) then
                            return {
                                message = localize{type='variable',key='a_xmult',vars={1+(0.05*(#G.playing_cards - #G.deck.cards))}},
                                Xmult_mod = 1+(0.05*(#G.playing_cards - #G.deck.cards)), 
                                colour = G.C.MULT
                            }
        end
end

function feather.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra, 1+(0.05*((G.playing_cards and G.deck.cards) and #G.playing_cards - #G.deck.cards or 0))}}
end

--endregion Feather

--region Bird

local bird = SMODS.Joker({
	name = "Bird",
	key = "bird",
    config = {},
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
	atlas = "j_ccc_jokers"
})

bird.calculate = function(self, context)
    if context.using_consumeable then
        if context.consumeable.ability.set == 'Planet' then
            if G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or (G.GAME.blind:get_type() == "Small") or (G.GAME.blind:get_type() == "Big") or (G.GAME.blind:get_type() == "Boss") then
                return {
                        G.E_MANAGER:add_event(Event({
                                            func = function() 
                                card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = "+4 Cards", colour = G.C.FILTER})
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
	atlas = "j_ccc_jokers"
})

partofyou.calculate = function(self, context)
	if SMODS.end_calculate_context(context) then
	if not context.blueprint then
     	  if G.GAME.current_round.hands_played == 0 then
            if #context.full_hand == 2 then
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() context.full_hand[1]:flip();play_sound('card1', 1);context.full_hand[1]:juice_up(0.3, 0.3);return true end }))
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() context.full_hand[2]:flip();play_sound('card1', 1);context.full_hand[2]:juice_up(0.3, 0.3);return true end }))
 		G.E_MANAGER:add_event(Event({trigger = 'before',
                            func = function() 
				card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = "Mirrored!", colour = G.C.FILTER})   
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
	info_queue[#info_queue+1] = {key = 'ccc_credits_concept_Fytos', set = 'Other'}
	info_queue[#info_queue+1] = {key = 'partofyou_complements', set = 'Other'}
end

-- endregion Part Of You

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
	atlas = "j_ccc_jokers"
})

zipper.set_ability = function(self, context)
        if self.ability.name == 'Zipper' then
            self.ability.extra.chips = G.GAME.skips*30
	end
end

zipper.calculate = function(self, context)
        if self.ability.name == 'Zipper' then
            self.ability.extra.chips = G.GAME.skips*30
	end
        if context.skip_blind then
            if not context.blueprint then
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        card_eval_status_text(self, 'extra', nil, nil, nil, {
                            message = localize{type = 'variable', key = 'a_chips', vars = {self.ability.extra.chips}},
                                colour = G.C.CHIPS,
                            card = self
                        }) 
                        return true
                    end}))
            end
	end
	if SMODS.end_calculate_context(context) then
		if self.ability.extra.chips ~= 0 then
                return {
                    message = localize {
                        type = 'variable',
                        key = 'a_chips',
                        vars = { self.ability.extra.chips }
                    },
                    chip_mod = self.ability.extra.chips,
                    card = self
                }
end
end
end

function zipper.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.chips}}
end

-- endregion Zipper

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
	atlas = "j_ccc_jokers"
})

miniheart.calculate = function(self, context)
            if context.cardarea == G.jokers then
       		 if SMODS.end_calculate_context(context) then
                    if not context.blueprint then
			local miniheartsuccess = false
                        local crystal = {}
                        for k, v in ipairs(context.scoring_hand) do
                         crystal[#crystal+1] = v
			if pseudorandom('crystal') < G.GAME.probabilities.normal/20 then
       			 G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
         		   local over = false
			   local miniheartsuccess = true
           		   v:set_edition({foil = true}, true)
                           self:juice_up()
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
	"{C:attention}Flush{}, gains {C:chips}+6{} Chips for",
	"each card held in hand that",
	"shares the same {C:attention}suit{}",
	"{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"
        }
    },
	rarity = 2,
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	atlas = "j_ccc_jokers"
})

towels.calculate = function(self, context)
	if context.before and context.poker_hands ~= nil and next(context.poker_hands['Flush']) and not context.blueprint then

                            local suits = {
                                ['Hearts'] = 0,
                                ['Diamonds'] = 0,
                                ['Spades'] = 0,
                                ['Clubs'] = 0
                            }
			    towels_flush_suit = 'None'
                            for i = 1, #context.scoring_hand do
                                if context.scoring_hand[i].ability.name ~= 'Wild Card' then
                                    if context.scoring_hand[i]:is_suit('Hearts', true) then suits["Hearts"] = suits["Hearts"] + 1
                                    elseif context.scoring_hand[i]:is_suit('Diamonds', true) then suits["Diamonds"] = suits["Diamonds"] + 1
                                    elseif context.scoring_hand[i]:is_suit('Spades', true) then suits["Spades"] = suits["Spades"] + 1
                                    elseif context.scoring_hand[i]:is_suit('Clubs', true) then suits["Clubs"] = suits["Clubs"] + 1 end
                            end
			    end
                            if suits["Hearts"] > suits["Diamonds"] and suits["Hearts"] > suits["Spades"] and suits["Hearts"] > suits["Clubs"] then
			    towels_flush_suit = 'Hearts'
				card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = "Hearts!", colour = G.C.FILTER})   
                            elseif suits["Diamonds"] > suits["Hearts"] and suits["Diamonds"] > suits["Spades"] and suits["Diamonds"] > suits["Clubs"] then
			    towels_flush_suit = 'Diamonds'
				card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = "Diamonds!", colour = G.C.FILTER})   
                            elseif suits["Spades"] > suits["Hearts"] and suits["Spades"] > suits["Diamonds"] and suits["Spades"] > suits["Clubs"] then
			    towels_flush_suit = 'Spades'
				card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = "Spades!", colour = G.C.FILTER})   
                            elseif suits["Clubs"] > suits["Hearts"] and suits["Clubs"] > suits["Diamonds"] and suits["Clubs"] > suits["Spades"] then  
			    towels_flush_suit = 'Clubs'
				card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = "Clubs!", colour = G.C.FILTER}) 
			    else bredcard_flush_suit = 'Wild'
				card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = "Wild!", colour = G.C.FILTER})   
			    end
	end

	if context.individual and context.poker_hands ~= nil and next(context.poker_hands['Flush']) and not context.blueprint then
        	if context.cardarea == G.hand then
	         	if context.other_card:is_suit(towels_flush_suit, true) or towels_flush_suit == 'Wild' then
                        self.ability.extra.chips = self.ability.extra.chips + 6
                        	    return {
                            message = localize('k_upgrade_ex'),
                            colour = G.C.CHIPS,
                            card = self
                        }
        		end
	        end
	end
	if SMODS.end_calculate_context(context) then
            if self.ability.extra.chips ~= 0 then
                return {
                    message = localize {
                        type = 'variable',
                        key = 'a_chips',
                        vars = { self.ability.extra.chips }
                    },
                    chip_mod = self.ability.extra.chips,
                    card = self
                }
	end
end
end

function towels.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'ccc_credits_concept_Bred', set = 'Other'}
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
	"{C:mult}+2{} Mult for each possible",
	"{C:attention}Pair{} held in hand",
	"{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
        }
    },
	rarity = 2,
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	atlas = "j_ccc_jokers"
})

chests.calculate = function(self, context)

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

	if SMODS.end_calculate_context(context) and not context.blueprint then
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
			self.ability.extra.mult = self.ability.extra.mult + (boxes_pair_amounts)*2
			card_eval_status_text(self, 'extra', nil, nil, nil, {message = "Upgrade!", colour = G.C.MULT}) 
		end
	end
	if SMODS.end_calculate_context(context) then
		if self.ability.extra.mult ~= 0 then
                	return {
                   	message = localize {
                  		type = 'variable',
                   		key = 'a_mult',
                  		vars = { self.ability.extra.mult }
                		},
                	mult_mod = self.ability.extra.mult,
                	card = self
                	}
		end
	end
end

function chests.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'ccc_credits_concept_Bred', set = 'Other'}
	return {vars = {card.ability.extra.mult}}
end

-- endregion Huge Mess: Chests

-- region Huge Mess: Books

local books = SMODS.Joker({
	name = "Huge Mess: Books",
	key = "books",
    config = {extra = {xmult = 1}},
	pos = {x = 0, y = 0},
	loc_txt = {
        name = 'Huge Mess: Books',
        text = {
	"When played hand contains a",
	"{C:attention}Straight{}, gains {X:mult,C:white} X0.11 {} Mult",
	"for each additional card in",
	"the {C:attention}sequence{} held in hand",
	"{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult){}"
        }
    },
	rarity = 2,
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	atlas = "j_ccc_jokers"
})

books.calculate = function(self, context)

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

	if SMODS.end_calculate_context(context) and context.poker_hands ~= nil and (next(context.poker_hands['Straight'])) and not context.blueprint then
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
			self.ability.extra.xmult = self.ability.extra.xmult + (0.11*(books_additional_sequence_cards))
			card_eval_status_text(self, 'extra', nil, nil, nil, {message = "Upgrade!", colour = G.C.MULT}) 
		end
	end
	if SMODS.end_calculate_context(context) then
		if self.ability.extra.xmult ~= 1 then
                	return {
                   	message = localize {
                  		type = 'variable',
                   		key = 'a_xmult',
                  		vars = { self.ability.extra.xmult }
                		},
                	mult_mod = self.ability.extra.xmult,
                	card = self
                	}
		end
	end
end

function books.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'ccc_credits_concept_Bred', set = 'Other'}
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
	"{C:green}#1# in 6{} chance to copy a",
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
	blueprint_compat = false,
	atlas = "j_ccc_jokers"
})



ominousmirror.set_ability = function(self, context)
	self.children.center:set_sprite_pos(self.ability.extra.pos_override)
end


ominousmirror.calculate = function(self, context)
	self.children.center:set_sprite_pos(self.ability.extra.pos_override)
	if context.before and self.ability.extra.broken == false then
		if not context.blueprint and not context.repetition and not context.individual and self.ability.extra.broken == false then
			for k, v in ipairs(context.scoring_hand) do
				if pseudorandom('ominous') < G.GAME.probabilities.normal/6 then
					G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, func = function()
						self:juice_up()
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
	if context.end_of_round and not context.blueprint and not context.repetition and not context.individual and self.ability.extra.broken == false then
		if pseudorandom('oopsidroppedit') < G.GAME.probabilities.normal/6 then 
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, 
				func = function()
				play_sound('glass'..math.random(1, 6), math.random()*0.2 + 0.9,0.5)

-- messy particle code copied from glass shatter function


   local childParts = Particles(0, 0, 0,0, {
        timer_type = 'TOTAL',
        timer = 0.007*1,
        scale = 0.3,
        speed = 4,
        lifespan = 0.5*1,
        attach = self,
        colours = {G.C.MULT},
        fill = true
    })
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        blockable = false,
        delay =  0.5*1,
        func = (function() childParts:fade(0.30*1) return true end)
    }))

-- i cannot be bothered to re-indent this

				self.T.r = -0.2
				self:juice_up(0.3, 0.4)
				self.ability.extra.broken = true
				self.ability.extra.pos_override.x = 1
				self.ability.extra.pos_override.y = 2
				return true
				end
			}))
			card_eval_status_text(self, 'extra', nil, nil, nil, {message = "Broken", colour = G.C.MULT})
		else
			card_eval_status_text(self, 'extra', nil, nil, nil, {message = "Safe..?", colour = G.C.FILTER})
		end
	end
end

function ominousmirror.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'ccc_credits_art_Gappie_concept_Gappie', set = 'Other'}
	info_queue[#info_queue+1] = {key = 'e_mirrored', set = 'Other'}
	return {vars = {''..(G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.broken, card.ability.extra.name}}
end

-- endregion Ominous Mirror (WIP, NOT FUNCTIONAL)

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
	atlas = "j_ccc_jokers"
})

-- for some goddamn reason there's no easy way to add the dollar bonus at calculation... so i injected it via lovely. should work though

strawberry.calculate = function(self, context)
	if context.ending_shop and not context.blueprint then
		if self.ability.extra.money > 1 then
			self.ability.extra.money = self.ability.extra.money - 1
			card_eval_status_text(self, 'extra', nil, nil, nil, {message = "-$1", colour = G.C.MONEY})
		else
			G.E_MANAGER:add_event(Event({
				func = function()
				card_eval_status_text(self, 'extra', nil, nil, nil, {message = "Eaten!", colour = G.C.FILTER})
				play_sound('tarot1')
				self.T.r = -0.2
				self:juice_up(0.3, 0.4)
				self.states.drag.is = true
				self.children.center.pinch.x = true
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
					func = function()
						G.jokers:remove_card(self)
						self:remove()
						self = nil
					return true; end})) 
				return true
			end
                       	}))
		end 
	end
end

function strawberry.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'ccc_credits_art_Gappie_concept_Gappie', set = 'Other'}
	return {vars = {card.ability.extra.money}}
end


-- endregion Strawberry

-- region Winged Strawberry

local wingedstrawberry = SMODS.Joker({
	name = "Winged Strawberry",
	key = "wingedstrawberry",
    config = {extra = {winged_poker_hand = 'Pair'}},  -- initialize all winged berries to pair. i don't like this but idfk how to change it and pair is fine
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
	atlas = "j_ccc_jokers"
})

wingedstrawberry.calculate = function(self, context)
	if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
		if not context.blueprint then
                    local _poker_hands = {}
                    for k, v in pairs(G.GAME.hands) do
                        if v.visible and k ~= self.ability.extra.winged_poker_hand then 
				_poker_hands[#_poker_hands+1] = k 
			end
                    end
                    self.ability.extra.winged_poker_hand = pseudorandom_element(_poker_hands, pseudoseed('winged'))
		end
		card_eval_status_text(self, 'extra', nil, nil, nil, {message = "Reset", colour = G.C.FILTER})
	end
        if context.cardarea == G.jokers then
		if context.before and not context.end_of_round then
			if not next(context.poker_hands[self.ability.extra.winged_poker_hand]) then
				ease_dollars(2)
				G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + 2
				G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
				return {
					message = localize('$')..2,
					dollars = 2,
					colour = G.C.MONEY
					}
			end
		end
	end
end
		
	

function wingedstrawberry.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'ccc_credits_art_Gappie_concept_Gappie', set = 'Other'}
	return {vars = {(card.ability.extra.winged_poker_hand)}}
end

-- endregion Winged Strawberry

-- region Golden Strawberry

local goldenstrawberry = SMODS.Joker({
	name = "Golden Strawberry",
	key = "goldenstrawberry",
    config = {},
	pos = {x = 3, y = 1},
	loc_txt = {
        name = 'Golden Strawberry',
        text = {
	"Earn {C:money}$18{} at end of",
	"{C:attention}Boss Blind{}"
        }
    },
	rarity = 2,
	cost = 8,
	discovered = true,
	blueprint_compat = false,
	atlas = "j_ccc_jokers"
})

-- literally the simplest code in the entire mod lmao

goldenstrawberry.calculate = function(self, context)
	if context.setting_blind then
		if context.blind.boss then
			golden_strawberry_after_boss_blind = true
		else
			golden_strawberry_after_boss_blind = false
		end
	end
end

function goldenstrawberry.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'ccc_credits_art_Gappie_concept_Gappie', set = 'Other'}
end

-- endregion Golden Strawberry

-- region Winged Golden Strawberry

local wingedgoldenstrawberry = SMODS.Joker({
	name = "Winged Golden Strawberry",
	key = "wingedgoldenstrawberry",
    config = {extra = {winged_poker_hand = 'Pair'}},
	pos = {x = 4, y = 1},
	loc_txt = {
        name = 'Winged Golden Strawberry',
        text = {
	"Earn {C:money}$24{} at end of {C:attention}Boss Blind{} if",
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
	atlas = "j_ccc_jokers"
})

wingedgoldenstrawberry.calculate = function(self, context)
	if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
		if not context.blueprint then
                    local _poker_hands = {}
                    for k, v in pairs(G.GAME.hands) do
                        if v.visible and k ~= self.ability.extra.winged_poker_hand then 
				_poker_hands[#_poker_hands+1] = k 
			end
                    end
                    self.ability.extra.winged_poker_hand = pseudorandom_element(_poker_hands, pseudoseed('wingedgolden'))
		end
		card_eval_status_text(self, 'extra', nil, nil, nil, {message = "Reset", colour = G.C.FILTER})
	end
        if context.cardarea == G.jokers then
		if context.before and not context.end_of_round then
			if next(context.poker_hands[self.ability.extra.winged_poker_hand]) then
				winged_golden_strawberry_condition_satisfied = false
			end
		end
	end
	if context.setting_blind then
		winged_golden_strawberry_condition_satisfied = true
		if context.blind.boss then
			golden_strawberry_after_boss_blind = true	-- redundant variable switching if you have both... idc
		else
			golden_strawberry_after_boss_blind = false
		end
	end
end

function wingedgoldenstrawberry.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'ccc_credits_art_Gappie_concept_Gappie', set = 'Other'}
	return {vars = {card.ability.extra.winged_poker_hand}}
end

-- endregion Winged Golden Strawberry

-- region Moon Berry

local moonberry = SMODS.Joker({
	name = "Moon Berry",
	key = "moonberry",
    config = {extra = {winged_poker_hand = 'Pair'}},
	pos = {x = 5, y = 1},
	loc_txt = {
        name = 'Moon Berry',
        text = {
	"If round ends without playing",
	"hand that contains a {C:attention}#1#{},",
	"create its {C:planet}Planet{} card with",
	"with added {C:dark_edition}Negative{} edition,",
	"poker hand changes",
	"at end of round"
        }
    },
	rarity = 2,
	cost = 8,
	discovered = true,
	blueprint_compat = false,
	atlas = "j_ccc_jokers"
})

moonberry.calculate = function(self, context)
	if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
		if not context.blueprint then
			if space_berry_condition_satisfied == true then
				local card_type = 'Planet'
				G.E_MANAGER:add_event(Event({
				trigger = 'before',
				delay = 0.0,
				func = (function()
					if self.ability.extra.winged_poker_hand then
						local _planet = 0
						for k, v in pairs(G.P_CENTER_POOLS.Planet) do
						if v.config.hand_type == old_moon_berry_poker_hand_variable_stupid_race_condition_thing_idfk then
							_planet = v.key
                        			end
                   			end
                    			local card = create_card(card_type,G.consumeables, nil, nil, nil, nil, _planet, 'blusl')
					card:set_edition({negative = true}, true)
                    			card:add_to_deck()
                    			G.consumeables:emplace(card)
                			end
                			return true
            				end)}))
        			card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize('k_plus_planet'), colour = G.C.PLANET})
    			end
                    local _poker_hands = {}
                    for k, v in pairs(G.GAME.hands) do
                        if v.visible and k ~= self.ability.extra.winged_poker_hand then 
				_poker_hands[#_poker_hands+1] = k 
			end
                    end
		    old_moon_berry_poker_hand_variable_stupid_race_condition_thing_idfk = self.ability.extra.winged_poker_hand
                    self.ability.extra.winged_poker_hand = pseudorandom_element(_poker_hands, pseudoseed('SPAAAAAAAACE'))
		end
		card_eval_status_text(self, 'extra', nil, nil, nil, {message = "Reset", colour = G.C.FILTER})
		the_SPACE_berry_end_of_round_fucking_finished = true
	end
        if context.cardarea == G.jokers then
		if context.before and not context.end_of_round then
			the_SPACE_berry_end_of_round_fucking_finished = false
			if next(context.poker_hands[self.ability.extra.winged_poker_hand]) then
				space_berry_condition_satisfied = false
			end
		end
	end
	if context.setting_blind then
		space_berry_condition_satisfied = true
	end
end

function moonberry.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'ccc_credits_art_Gappie_concept_Gappie', set = 'Other'}
	info_queue[#info_queue+1] = {key = 'e_negative_consumable', set = 'Edition', config = {extra = 1}}
	return {vars = {card.ability.extra.winged_poker_hand}}
end

-- endregion Moon Berry

-- endregion ALL BERRIES

-- region To The Summit

local tothesummit = SMODS.Joker({
	name = "To The Summit",
	key = "tothesummit",
    config = {extra = {xmult = 1}},
	pos = {x = 0, y = 1},
	loc_txt = {
        name = 'To The Summit',
        text = {
	"Gains {X:mult,C:white} X0.25 {} Mult for each",
	"{C:attention}consecutive Blind{} selected",
	"with more {C:money}money{} than",
	"the {C:attention}previous Blind{}",
	"{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult)"
        }
    },
	rarity = 2,
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	atlas = "j_ccc_jokers"
})

tothesummit.calculate = function(self, context)
	if context.setting_blind and not context.blueprint then
		if ccc_tothesummit_min_money == nil then
			ccc_tothesummit_min_money = math.max(0,(G.GAME.dollars + (G.GAME.dollar_buffer or 0)))
			self.ability.extra.xmult = self.ability.extra.xmult + 0.25
			card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {self.ability.extra.xmult}}})
		elseif ccc_tothesummit_min_money >= math.max(0,(G.GAME.dollars + (G.GAME.dollar_buffer or 0))) then
			local last_xmult = self.ability.extra.xmult
			self.ability.extra.xmult = 1
			if last_xmult > 1 then
				card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = "Reset", colour = G.C.FILTER})
			end
			ccc_tothesummit_min_money = math.max(0,(G.GAME.dollars + (G.GAME.dollar_buffer or 0)))
		elseif ccc_tothesummit_min_money < math.max(0,(G.GAME.dollars + (G.GAME.dollar_buffer or 0))) then
			self.ability.extra.xmult = self.ability.extra.xmult + 0.25
			card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {self.ability.extra.xmult}}})
			ccc_tothesummit_min_money = math.max(0,(G.GAME.dollars + (G.GAME.dollar_buffer or 0)))
		end
	end		
	if SMODS.end_calculate_context(context) then
            	if self.ability.extra.xmult ~= 1 then
                	return {
                    	message = localize {
                        	type = 'variable',
                        	key = 'a_xmult',
                        	vars = { self.ability.extra.xmult }
                    	},
			Xmult_mod = self.ability.extra.xmult,
               	    	card = self
                	}
		end
	end
end

function tothesummit.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'ccc_credits_art_Gappie_concept_Aurora', set = 'Other'}
	return {vars = {card.ability.extra.xmult}}
end

-- endregion To The Summit

-- region Core Switch

local coreswitch = SMODS.Joker({
	name = "Core Switch",
	key = "coreswitch",
    config = {},
	pos = {x = 0, y = 0},
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
	atlas = "j_ccc_jokers"
})

coreswitch.calculate = function(self, context)
	if context.first_hand_drawn and not self.getting_sliced and not context.blueprint and not context.individual then
		G.E_MANAGER:add_event(Event({trigger = 'before', delay = immediate, func = function()
			coreswitch_hand_juggle = G.GAME.current_round.discards_left
			ease_discard(1 + (G.GAME.current_round.hands_left - G.GAME.current_round.discards_left), nil, true)
			ease_hands_played(coreswitch_hand_juggle - G.GAME.current_round.hands_left, nil, true)
			card_eval_status_text(self, 'extra', nil, nil, nil, {message = "Swapped", colour = G.C.FILTER})
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

function coreswitch.loc_vars(self, info_queue, card)	
	info_queue[#info_queue+1] = {key = 'ccc_credits_concept_Aurora', set = 'Other'}
end

-- endregion Core Switch

-- region Temple Rock

local templerock = SMODS.Joker({
	name = "Temple Rock",
	key = "templerock",
    config = {},
	pos = {x = 0, y = 0},
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
	atlas = "j_ccc_jokers"
})

templerock.calculate = function(self, context)
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
					chip_mod = 50,
                    			card = self
				}
			end
        	end
	end
end

function templerock.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'ccc_credits_concept_sunsetquasar', set = 'Other'}
	info_queue[#info_queue+1] = G.P_CENTERS.m_stone
end

-- endregion Temple Rock

-- region Strong Winds

local strongwinds = SMODS.Joker({
	name = "Strong Winds",
	key = "strongwinds",
    config = {},
	pos = {x = 0, y = 0},
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
	atlas = "j_ccc_jokers"
})

strongwinds.calculate = function(self, context)
	if context.cardarea == G.jokers then
		if SMODS.end_calculate_context(context) then
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
            			local cards_destroyed = {}
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
				Xmult_mod = 2.22,
				card = self
			}
		end
	end
end

function strongwinds.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'ccc_credits_concept_goose', set = 'Other'}
end
			
-- endregion Strong Winds

-- region Coyote Jump

local coyotejump = SMODS.Joker({
	name = "Coyote Jump",
	key = "coyotejump",
    config = {},
	pos = {x = 0, y = 0},
	loc_txt = {
        name = 'Coyote Jump',
        text = {
	"If cards held in hand",
	"do not form a {C:attention}Pair{},",
	"{C:attention}Straight{}, or {C:attention}Flush{},",
	"gain {C:red}+1{} discard"
        }
    },
	rarity = 2,
	cost = 8,
	discovered = true,
	blueprint_compat = true,
	atlas = "j_ccc_jokers"
})

coyotejump.calculate = function(self, context) -- thank you bred?????

	if context.before and not context.blueprint then
	coyotejump_card_array = {}
	end

	if context.individual and context.poker_hands ~= nil and not context.blueprint then
       		if context.cardarea == G.hand then
			coyotejump_card_array[#coyotejump_card_array + 1] = context.other_card
		end
	end
	
	if SMODS.end_calculate_context(context) and context.poker_hands ~= nil then
		  local parts = {
			_2 = get_X_same(2, coyotejump_card_array),
			_flush = get_flush(coyotejump_card_array),
			_straight = get_straight(coyotejump_card_array)
		}
		if next(parts._straight) then
			card_eval_status_text(self, 'debuff', nil, nil, nil, {message = "Straight", colour = G.C.RED})
		elseif next(parts._flush) then
			card_eval_status_text(self, 'debuff', nil, nil, nil, {message = "Flush", colour = G.C.RED})
		elseif next(parts._2) then
			card_eval_status_text(self, 'debuff', nil, nil, nil, {message = "Pair", colour = G.C.RED})
		else
			G.E_MANAGER:add_event(Event({trigger = 'before', delay = immediate, func = function()
				ease_discard(1, nil, true)
				card_eval_status_text(self, 'extra', nil, nil, nil, {message = "+1 Discard", colour = G.C.RED})
			return true end }))
		end
	end
end

function coyotejump.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'ccc_credits_concept_Bred', set = 'Other'}
end

-- endregion Coyote Jump

-- region Climbing Gear

local climbinggear = SMODS.Joker({
	name = "Climbing Gear",
	key = "climbinggear",
    config = {d_size = 2},
	pos = {x = 0, y = 0},
	loc_txt = {
        name = 'Climbing Gear',
        text = {
	"{C:red}+2{} discards",
	"Discarded cards are",
	"reshuffled into deck"
        }
    },
	rarity = 2,
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	atlas = "j_ccc_jokers"
})

function climbinggear.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'ccc_credits_concept_goose', set = 'Other'}
end

-- this may be the easiest joker so far... literally NO code needs to be here, it's all done in lovely patches

-- endregion Climbing Gear

-- all 3 spinners have basically the same code lol

-- region Blue Spinner

local bluespinner = SMODS.Joker({
	name = "Blue Spinner",
	key = "bluespinner",
    config = {},
	pos = {x = 0, y = 0},
	loc_txt = {
        name = 'Blue Spinner',
        text = {
	"When a card with a {C:planet}Blue Seal{}",
	"is scored, {C:green}#1# in 6{} chance",
	"to add a {C:planet}Blue Seal{} to each",
	"{C:attention}adjacent{} card in scored hand",
	"{C:inactive,s:0.87}(Unaffected by retriggers){}"
        }
    },
	rarity = 2,
	cost = 6,
	discovered = true,
	blueprint_compat = true,
	atlas = "j_ccc_jokers"
})

bluespinner.calculate = function(self, context)

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
						if pseudorandom('bloo1') < G.GAME.probabilities.normal/6 then
							bluespinner_seal_candidates[#bluespinner_seal_candidates + 1] = context.scoring_hand[k]
						end
					end
				end
			elseif k == #context.scoring_hand then
				if k ~= 1 then
					if context.scoring_hand[k - 1].seal == 'Blue' or (rainbow_spinner_seal_override == true and context.scoring_hand[k - 1].seal == 'Gold') then
						if pseudorandom('bloo2') < G.GAME.probabilities.normal/6 then
							bluespinner_seal_candidates[#bluespinner_seal_candidates + 1] = context.scoring_hand[k]
						end
					end
				end
			else
				if context.scoring_hand[k + 1].seal == 'Blue' or (rainbow_spinner_seal_override == true and context.scoring_hand[k + 1].seal == 'Gold') then
					if pseudorandom('bloo3') < G.GAME.probabilities.normal/6 then
						bluespinner_seal_candidates[#bluespinner_seal_candidates + 1] = context.scoring_hand[k]
					end
				elseif context.scoring_hand[k - 1].seal == 'Blue' or (rainbow_spinner_seal_override == true and context.scoring_hand[k - 1].seal == 'Gold') then
					if pseudorandom('bloo4') < G.GAME.probabilities.normal/6 then
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
						self:juice_up()
            				return true end }))
					delay(0.5)
				end
			end
		end
	end
end

function bluespinner.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'ccc_credits_concept_sunsetquasar', set = 'Other'}
	info_queue[#info_queue+1] = {key = 'blue_seal', set = 'Other'}
	return {vars = {''..(G.GAME and G.GAME.probabilities.normal or 1)}}
end

-- endregion Blue Spinner

-- region Purple Spinner

local purplespinner = SMODS.Joker({
	name = "Purple Spinner",
	key = "purplespinner",
    config = {},
	pos = {x = 0, y = 0},
	loc_txt = {
        name = 'Purple Spinner',
        text = {
	"When a card with a {C:tarot}Purple Seal{}",
	"is {C:attention}held{} in hand at end of round,",
	"{C:green}#1# in 6{} chance to add a {C:tarot}Purple Seal{}",
	"to each {C:attention}adjacent{} card in hand",
	"{C:inactive,s:0.87}(Unaffected by retriggers){}"
        }
    },
	rarity = 2,
	cost = 6,
	discovered = true,
	blueprint_compat = false,
	atlas = "j_ccc_jokers"
})

purplespinner.calculate = function(self, context)

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
						if pseudorandom('purple1') < G.GAME.probabilities.normal/6 then
							purplespinner_seal_candidates[#purplespinner_seal_candidates + 1] = G.hand.cards[k]
						end
					end
				end
			elseif k == #G.hand.cards then
				if k ~= 1 then
					if G.hand.cards[k - 1].seal == 'Purple' or (rainbow_spinner_seal_override == true and G.hand.cards[k - 1].seal == 'Gold') then
						if pseudorandom('is2') < G.GAME.probabilities.normal/6 then
							purplespinner_seal_candidates[#purplespinner_seal_candidates + 1] = G.hand.cards[k]
						end
					end
				end
			else
				if G.hand.cards[k + 1].seal == 'Purple' or (rainbow_spinner_seal_override == true and G.hand.cards[k + 1].seal == 'Gold') then
					if pseudorandom('best3') < G.GAME.probabilities.normal/6 then
						purplespinner_seal_candidates[#purplespinner_seal_candidates + 1] = G.hand.cards[k]
					end
				elseif G.hand.cards[k - 1].seal == 'Purple' or (rainbow_spinner_seal_override == true and G.hand.cards[k - 1].seal == 'Gold') then
					if pseudorandom('colour4') < G.GAME.probabilities.normal/6 then
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
						self:juice_up()
            				return true end }))
					delay(0.5)
				end
			end
		end
	end
end

function purplespinner.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'ccc_credits_concept_sunsetquasar', set = 'Other'}
	info_queue[#info_queue+1] = {key = 'purple_seal', set = 'Other'}
	return {vars = {''..(G.GAME and G.GAME.probabilities.normal or 1)}}
end


-- region Red Spinner

local redspinner = SMODS.Joker({
	name = "Red Spinner",
	key = "redspinner",
    config = {},
	pos = {x = 0, y = 0},
	loc_txt = {
        name = 'Red Spinner',
        text = {
	"When a card with a {C:red}Red Seal{}",
	"is {C:attention}discarded{}, {C:green}#1# in 5{} chance",
	"to add a {C:red}Red Seal{} to each",
	"{C:attention}adjacent{} card in discarded hand",
	"{C:inactive,s:0.87}(Unaffected by retriggers){}"
        }
    },
	rarity = 2,
	cost = 6,
	discovered = true,
	blueprint_compat = false,
	atlas = "j_ccc_jokers"
})

redspinner.calculate = function(self, context)

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
						if pseudorandom('RED1') < G.GAME.probabilities.normal/5 then
							redspinner_seal_candidates[#redspinner_seal_candidates + 1] = G.hand.highlighted[k]
						end
					end
				end
			elseif k == #G.hand.highlighted then
				if k ~= 1 then
					if G.hand.highlighted[k - 1].seal == 'Red' or (rainbow_spinner_seal_override == true and G.hand.highlighted[k - 1].seal == 'Gold') then
						if pseudorandom('redge2') < G.GAME.probabilities.normal/5 then
							redspinner_seal_candidates[#redspinner_seal_candidates + 1] = G.hand.highlighted[k]
						end
					end
				end
			else
				if G.hand.highlighted[k + 1].seal == 'Red' or (rainbow_spinner_seal_override == true and G.hand.highlighted[k + 1].seal == 'Gold') then
					if pseudorandom('reeeeeeeed3') < G.GAME.probabilities.normal/5 then
						redspinner_seal_candidates[#redspinner_seal_candidates + 1] = G.hand.highlighted[k]
					end
				elseif G.hand.highlighted[k - 1].seal == 'Red' or (rainbow_spinner_seal_override == true and G.hand.highlighted[k - 1].seal == 'Gold') then
					if pseudorandom('dontknowhattoputhere4') < G.GAME.probabilities.normal/5 then
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
						self:juice_up()
            				return true end }))
					delay(0.5)
				end
			end
		end
	end
end

function redspinner.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'ccc_credits_concept_sunsetquasar', set = 'Other'}
	info_queue[#info_queue+1] = {key = 'red_seal', set = 'Other'}
	return {vars = {''..(G.GAME and G.GAME.probabilities.normal or 1)}}
end

-- endregion Red Spinner

-- region Rainbow Spinner

local rainbowspinner = SMODS.Joker({
	name = "Rainbow Spinner",
	key = "rainbowspinner",
    config = {},
	pos = {x = 0, y = 0},
	loc_txt = {
        name = 'Rainbow Spinner',
        text = {
	"{C:money}Gold Seals{} act as",
	"{C:red,s:1.2}ev{C:tarot,s:1.2}e{C:planet,s:1.2}ry{} seal"
        }
    },
	rarity = 3,
	cost = 11,
	discovered = true,
	blueprint_compat = false,
	atlas = "j_ccc_jokers"
})

function rainbowspinner.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'ccc_credits_concept_sunsetquasar', set = 'Other'}
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
	"{C:green}#1# in 3{} chance to create",
	"a {C:tarot}Death{}",
	"Gain {C:mult}+2{} Mult for each",
	"{C:tarot}Death{} used",
	"{C:inactive}(Must have room)",
	"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
        }
    },
	rarity = 2,
	cost = 7,
	discovered = true,
	blueprint_compat = true,
	atlas = "j_ccc_jokers"
})

lettinggo.calculate = function(self, context)

	if context.cards_destroyed then
                ccc_lettinggo_death_chances = 0
		for k, v in ipairs(context.glass_shattered) do
                    ccc_lettinggo_death_chances = ccc_lettinggo_death_chances + 1
                end
		for i = 1, ccc_lettinggo_death_chances do
			if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
				if pseudorandom('lettinggo') < G.GAME.probabilities.normal/3 then
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
                            			card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})                       
                        		return true
                    			end)}))
				end
			end
		end
	end

	if context.remove_playing_cards then -- it's just the same thing as before, folks
		ccc_lettinggo_death_chances = 0
		for k, val in ipairs(context.removed) do
                    ccc_lettinggo_death_chances = ccc_lettinggo_death_chances + 1
                end
		for i = 1, ccc_lettinggo_death_chances do
			if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
				if pseudorandom('lettinggo') < G.GAME.probabilities.normal/3 then
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
                            			card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})                       
                        		return true
                    			end)}))
				end
			end
		end
	end

	if context.using_consumeable then
		if context.consumeable.ability.name == 'Death' then
			if not context.blueprint then
				self.ability.extra.mult = self.ability.extra.mult + 2
				card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_mult', vars = {self.ability.extra.mult}}})
			end
		end
	end

	if SMODS.end_calculate_context(context) then
		if self.ability.extra.mult ~= 0 then
                	return {
                   	message = localize {
                  		type = 'variable',
                   		key = 'a_mult',
                  		vars = { self.ability.extra.mult }
                		},
                	mult_mod = self.ability.extra.mult,
                	card = self
                	}
		end
	end
end

function lettinggo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = 'ccc_credits_art_bein_concept_Gappie', set = 'Other'}
	info_queue[#info_queue+1] = G.P_CENTERS.c_death
	return {vars = {''..(G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.mult}}
end
