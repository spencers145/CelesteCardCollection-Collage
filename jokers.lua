--- STEAMODDED HEADER
--- SECONDARY MOD FILE

----------------------------------------------
------------MOD CODE -------------------------

--- Descriptions ---
    local loc_templeeyes = {
        ["name"] = "Temple Eyes",
        ["text"] = {
            [1] = "If {C:attention}Blind{} is selected with",
            [2] = "{C:money}$4{} or less, create a",
            [3] = "{C:tarot}Hanged Man{}"
        }
    }
    local loc_feather = {
        ["name"] = "Feather",
        ["text"] = {
            [1] = "Gains {X:mult,C:white} X0.05 {} Mult for",
            [2] = "each card {C:attention}drawn{}",
            [3] = "during the round",
            [4] = "{C:inactive}(Currently {X:mult,C:white} X#2# {} Mult){}"
        }
    }
    local loc_bird = {
        ["name"] = "Bird",
        ["text"] = {
            [1] = "Whenever a {C:planet}Planet{} card",
            [2] = "is used, draw {C:attention}3{} cards",
        }
    }
    local loc_partofyou = {
        ["name"] = "Part Of You",
        ["text"] = {
            [1] = "If {C:attention}first hand{} of round contains exactly",
            [2] = "{C:attention}2{} cards, convert both of their {C:attention}ranks{}",
            [3] = "into their {C:attention}complements{}",
	    [4] = "{C:inactive}(e.g. King <-> Ace, Jack <-> 3, 6 <-> 8){}",
        }
    }
    local loc_zipper = {
        ['name'] = 'Zipper',
        ['text'] = {
            [1] = 'Gains {C:chips}+30{} Chips for each',
            [2] = '{C:attention}Blind{} skipped this run',
            [3] = '{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)'
        }
    }
    local loc_miniheart = {
        ['name'] = 'Mini Heart',
        ['text'] = {
            [1] = '{C:green}#1# in 20{} chance to add {C:dark_edition}Foil{}',
            [2] = 'edition to scored cards',
            [3] = '{C:inactive}(Unaffected by retriggers){}'
        }
    }
    local loc_towels = {
        ['name'] = 'Huge Mess: Towels',
        ['text'] = {
            [1] = 'When played hand contains a',
            [2] = '{C:attention}Flush{}, gains {C:chips}+5{} Chips for',
            [3] = 'each card held in hand that',
            [4] = 'shares the same {C:attention}suit{}',
            [5] = '{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)'
        }
    }
    local loc_boxes = {
        ['name'] = 'Huge Mess: Boxes',
        ['text'] = {
            [1] = 'When played hand contains',
            [2] = '{C:attention}Three of a Kind{}, gains',
            [3] = '{C:mult}+1{} Mult for each possible',
            [4] = '{C:attention}Pair{} held in hand',
            [5] = '{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)'
        }
    }
    local loc_books = {
        ['name'] = 'Huge Mess: Books',
        ['text'] = {
            [1] = 'When played hand contains a',
            [2] = '{C:attention}Straight{}, gains {X:mult,C:white} X0.07 {} Mult',
            [3] = 'for each additional card in',
            [4] = 'the {C:attention}sequence{} held in hand',
            [5] = '{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult){}',
        }
    }
-- region Temple Eyes

    -- SMODS.Joker:new(name, slug, config, spritePos, loc_txt, rarity, cost, unlocked, discovered, blueprint_compat, eternal_compat)
    local joker_templeeyes = SMODS.Joker:new("Temple Eyes", "templeeyes", {} , {
        x = 1,
        y = 0
    }, loc_templeeyes, 2, 7, true, true, true, true, "", "b_cccjokers")
    
    joker_templeeyes:register()


SMODS.Jokers.j_templeeyes.tooltip = function(self, info_queue)
  info_queue[#info_queue+1] = G.P_CENTERS.c_hanged_man
end

SMODS.Jokers.j_templeeyes.calculate = function(self, context)
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

-- endregion Temple Eyes
-- region Feather

    local joker_feather = SMODS.Joker:new("Feather", "feather", { atlas="b_cccjokers" }, {
        x = 0,
        y = 0
    }, loc_feather, 2, 6, true, true, true, true, "", "b_cccjokers")

    joker_feather:register()


SMODS.Jokers.j_feather.calculate = function(self, context)
        if SMODS.end_calculate_context(context) then
                            return {
                                message = localize{type='variable',key='a_xmult',vars={1+(0.05*(#G.playing_cards - #G.deck.cards))}},
                                Xmult_mod = 1+(0.05*(#G.playing_cards - #G.deck.cards)), 
                                colour = G.C.MULT
                            }
        end
end

-- endregion Feather
-- region Limitless (debug instant win joker)

-- local joker_limitless = SMODS.Joker:new("Limitless", "limitless", {} , {
--     x = 0,
--     y = 1
-- }, loc_limitless, 3, 9999, false, false, false, true, "", "b_cccjokers")

-- joker_limitless:register()
-- function SMODS.Jokers.j_limitless.loc_def(card)
--     return {card.ability.chips}
-- end

-- function SMODS.Jokers.j_limitless.set_ability(card, initial, delay_sprites)
--     card.ability.chips = 0
--     card.ability.extra = 1
-- end

-- function SMODS.Jokers.j_limitless.calculate(self, context)
--     if context.setting_blind and not self.getting_sliced then
--         G.E_MANAGER:add_event(Event({func = function()
--             self.ability.extra = self.ability.extra*2

--             --G.GAME.blind.chips = G.GAME.blind.chips*self.ability.extra
--             --G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)

--             card_eval_status_text(self, 'extra', nil, nil, nil, {message = "Blind Increased!"})
--         return true end }))
--     elseif context.end_of_round then 
--         self.ability.chips = 10000000 -- G.GAME.chips
--     elseif context.cardarea == G.jokers and not context.before and not context.after then
--         return {
--             message = localize{type='variable',key='a_chips',vars={self.ability.chips or 0}},
--             chip_mod = self.ability.chips or 10000000
--         }
--     end
-- end

-- function SMODS.Jokers.j_limitless.set_badges(card, badges)
--     badges[#badges+1] = create_badge('Good luck', HEX('000000'), HEX('FFFFFF'), 1.2)
-- end
-- endregion Limitless  
-- region Bird

local joker_bird = SMODS.Joker:new("Bird", "bird", { atlas="b_cccjokers" }, {
    x = 2,
    y = 0
}, loc_bird, 3, 8, true, true, true, true, "", "b_cccjokers")

joker_bird:register()



SMODS.Jokers.j_bird.calculate = function(self, context)
    if context.using_consumeable then
        if context.consumeable.ability.set == 'Planet'  then
            if G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or (G.GAME.blind:get_type() == "Small") or (G.GAME.blind:get_type() == "Big") or (G.GAME.blind:get_type() == "Boss") then
                return {
                        G.E_MANAGER:add_event(Event({
                                            func = function() 
                                card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = "+3 Cards", colour = G.C.FILTER})
                                G.FUNCS.draw_from_deck_to_hand(3)          
                                                return true
                                end}))
                        }
            end
        end
    end
end


-- endregion Bird
-- region Part Of You

    local joker_partofyou = SMODS.Joker:new("Part Of You", "partofyou", { atlas="b_cccjokers" }, {
        x = 3,
        y = 0
    }, loc_partofyou, 3, 7, true, true, false, true, "", "b_cccjokers")

    joker_partofyou:register()

    SMODS.Jokers.j_partofyou.set_ability = function(self, context)
        sendDebugMessage("Hello !", 'MyLogger')
    end

SMODS.Jokers.j_partofyou.calculate = function(self, context)
	if SMODS.end_calculate_context(context) then
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
-- endregion Part Of You
-- region Zipper

    -- SMODS.Joker:new(name, slug, config, spritePos, loc_txt, rarity, cost, unlocked, discovered, blueprint_compat, eternal_compat)
    local joker_zipper = SMODS.Joker:new("Zipper", "zipper", {} , {
        x = 4,
        y = 0
    }, loc_zipper, 1, 5, true, true, true, true, "", "b_cccjokers")

    joker_zipper:register()

SMODS.Jokers.j_zipper.set_ability = function(self, center, initial, delay_sprites)
        if self.ability.name == 'Zipper' then
            self.ability.chips = G.GAME.skips*30
end
end

    SMODS.Jokers.j_zipper.calculate = function(self, context)
        if self.ability.name == 'Zipper' then
            self.ability.chips = G.GAME.skips*30
	end
        if context.skip_blind then
            if not context.blueprint then
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        card_eval_status_text(self, 'extra', nil, nil, nil, {
                            message = localize{type = 'variable', key = 'a_chips', vars = {self.ability.chips}},
                                colour = G.C.CHIPS,
                            card = self
                        }) 
                        return true
                    end}))
            end
	if SMODS.end_calculate_context(context) then
            if self.ability.chips ~= 0 then
                return {
                    message = localize {
                        type = 'variable',
                        key = 'a_chips',
                        vars = { self.ability.chips }
                    },
                    chip_mod = self.ability.chips,
                    card = self
                }
end
end
end
end

-- endregion Zipper
-- region Mini Heart

    local joker_miniheart = SMODS.Joker:new("Mini Heart", "miniheart", { atlas="b_cccjokers" }, {
        x = 5,
        y = 0		
    }, loc_miniheart, 1, 4, true, true, false, true, "", "b_cccjokers")

    joker_miniheart:register()

-- tooltip overrides edition, e.g. if you have a holographic/polychrome miniheart, it will override it and only say "Foil: +50 chips", unsure how to make it stack (like wheel of fortune) so tooltip removed for now

-- SMODS.Jokers.j_miniheart.tooltip = function(self, info_queue)
--  info_queue[#info_queue+1] = G.P_CENTERS.e_foil
-- end

SMODS.Jokers.j_miniheart.calculate = function(self, context)
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
-- endregion Mini Heart
-- region Towels
    local joker_towels = SMODS.Joker:new("Huge Mess: Towels", "towels", {extra = {chips = 0}, atlas="b_cccjokers" }, {
        x = 0,
        y = 0
    }, loc_towels, 2, 7, true, true, true, true, "", "b_cccjokers")

    joker_towels:register()

SMODS.Jokers.j_towels.set_ability = function(self, center, initial, delay_sprites)
  self.ability.extra.chips = 0
end

SMODS.Jokers.j_towels.calculate = function(self, context)
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
                 	       if context.other_card.debuff then
                           	 return {
                          	      message = localize('k_debuffed'),
                          	      colour = G.C.RED,
                          	      card = self,
                         	   }
                     	   else
                        self.ability.extra.chips = self.ability.extra.chips + 5
                        	    return {
                            message = localize('k_upgrade_ex'),
                            colour = G.C.CHIPS,
                            card = self
                        }
                        	end
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

-- endregion Towels
-- region Boxes

    local joker_boxes = SMODS.Joker:new("Huge Mess: Boxes", "boxes", {extra = {chips = 0}, atlas="b_cccjokers" }, {
        x = 0,
        y = 0
    }, loc_boxes, 2, 7, true, true, true, true, "", "b_cccjokers")

    joker_boxes:register()

SMODS.Jokers.j_boxes.set_ability = function(self, center, initial, delay_sprites)
  self.ability.extra.mult = 0
end

SMODS.Jokers.j_boxes.calculate = function(self, context)

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
			self.ability.extra.mult = self.ability.extra.mult + (boxes_pair_amounts)
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


-- endregion Boxes
-- region Books

    local joker_books = SMODS.Joker:new("Huge Mess: Books", "books", {extra = {chips = 0}, atlas="b_cccjokers" }, {
        x = 0,
        y = 0
    }, loc_books, 2, 7, true, true, true, true, "", "b_cccjokers")

    joker_books:register()

SMODS.Jokers.j_books.set_ability = function(self, center, initial, delay_sprites)
  self.ability.extra.xmult = 1
end

SMODS.Jokers.j_books.calculate = function(self, context)

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
	debugging_score_sequence = "n"
	debugging_hand_sequence = "n"
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
			self.ability.extra.xmult = self.ability.extra.xmult + (0.07*(books_additional_sequence_cards))
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

-- region uiBox (KEEP AT END)
-- uibox code copied from betmma which was copied from lushmod idfk we kinda just need this shit for some stuff
-- could maybe put this in a separate lua?

local generate_UIBox_ability_tableref = Card.generate_UIBox_ability_table
function Card.generate_UIBox_ability_table(self)
    local card_type, hide_desc = self.ability.set or "None", nil
    local loc_vars = nil
    local main_start, main_end = nil, nil
    local no_badge = nil

    if self.config.center.unlocked == false and not self.bypass_lock then -- For everyting that is locked
    elseif card_type == 'Undiscovered' and not self.bypass_discovery_ui then -- Any Joker or tarot/planet/voucher that is not yet discovered
    elseif self.debuff then
    elseif card_type == 'Default' or card_type == 'Enhanced' then
    elseif self.ability.set == 'Joker' then
        local customJoker = true

        if self.ability.name == 'Feather' then loc_vars = {self.ability.extra, 1+(0.05*((G.playing_cards and G.deck.cards) and #G.playing_cards - #G.deck.cards or 0))}
        elseif self.ability.name == 'Seeker' then
        elseif self.ability.name == 'Limitless' then
        elseif self.ability.name == 'Bird' then
        elseif self.ability.name == 'Part Of You' then
        elseif self.ability.name == 'Zipper' then loc_vars = {self.ability.chips}
        elseif self.ability.name == 'Mini Heart' then loc_vars = {''..(G.GAME and G.GAME.probabilities.normal or 1), self.ability.extra}
	elseif self.ability.name == 'Huge Mess: Towels' then loc_vars = {self.ability.extra.chips}
	elseif self.ability.name == 'Huge Mess: Boxes' then loc_vars = {self.ability.extra.mult}
	elseif self.ability.name == 'Huge Mess: Books' then loc_vars = {self.ability.extra.xmult}

        else
            customJoker = false
        end

        if customJoker then
            local badges = {}
            if (card_type ~= 'Locked' and card_type ~= 'Undiscovered' and card_type ~= 'Default') or self.debuff then
                badges.card_type = card_type
            end
            if self.ability.set == 'Joker' and self.bypass_discovery_ui and (not no_badge) then
                badges.force_rarity = true
            end
            if self.edition then
                if self.edition.type == 'negative' and self.ability.consumeable then
                    badges[#badges + 1] = 'negative_consumable'
                else
                    badges[#badges + 1] = (self.edition.type == 'holo' and 'holographic' or self.edition.type)
                end
            end
            if self.seal then
                badges[#badges + 1] = string.lower(self.seal) .. '_seal'
            end
            if self.ability.eternal then
                badges[#badges + 1] = 'eternal'
            end
            if self.pinned then
                badges[#badges + 1] = 'pinned_left'
            end

            if self.sticker then
                loc_vars = loc_vars or {};
                loc_vars.sticker = self.sticker
            end

            return generate_card_ui(self.config.center, nil, loc_vars, card_type, badges, hide_desc, main_start,
                main_end)
        end
    end

    return generate_UIBox_ability_tableref(self)
end

sendDebugMessage("[CCC] Jokers loaded")
----------------------------------------------
------------MOD CODE END----------------------
