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
            [1] = "{X:mult,C:white} X2 {} Mult when",
            [2] = "{C:attention}0{} discards",
            [3] = "remaining"
        }
    }
    local loc_limitless = {
        ["name"] = "Limitless",
        ["text"] = {
            [1] = "The Limit has been {C:red}broken{}",
            [2] = "{s:0.6} (This joker is for a free debug win)"
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
		if G.GAME.current_round.discards_left == 0 then
            return {
		message = localize{type='variable',key='a_xmult',vars={2}},
		Xmult_mod = 2
			}
		end
        end
end

-- endregion Feather
-- region Limitless (debug instant win joker)

local joker_limitless = SMODS.Joker:new("Limitless", "limitless", {} , {
    x = 0,
    y = 1
}, loc_limitless, 3, 9999, false, false, false, true, "", "b_cccjokers")

joker_limitless:register()
function SMODS.Jokers.j_limitless.loc_def(card)
    return {card.ability.chips}
end

function SMODS.Jokers.j_limitless.set_ability(card, initial, delay_sprites)
    card.ability.chips = 0
    card.ability.extra = 1
end

function SMODS.Jokers.j_limitless.calculate(self, context)
    if context.setting_blind and not self.getting_sliced then
        G.E_MANAGER:add_event(Event({func = function()
            self.ability.extra = self.ability.extra*2

            --G.GAME.blind.chips = G.GAME.blind.chips*self.ability.extra
            --G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)

            card_eval_status_text(self, 'extra', nil, nil, nil, {message = "Blind Increased!"})
        return true end }))
    elseif context.end_of_round then 
        self.ability.chips = 10000000 -- G.GAME.chips
    elseif context.cardarea == G.jokers and not context.before and not context.after then
        return {
            message = localize{type='variable',key='a_chips',vars={self.ability.chips or 0}},
            chip_mod = self.ability.chips or 10000000
        }
    end
end

function SMODS.Jokers.j_limitless.set_badges(card, badges)
    badges[#badges+1] = create_badge('Good luck', HEX('000000'), HEX('FFFFFF'), 1.2)
end
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

        if self.ability.name == 'Feather' then
        elseif self.ability.name == 'Seeker' then
        elseif self.ability.name == 'Limitless' then
        elseif self.ability.name == 'Bird' then
        elseif self.ability.name == 'Part Of You' then
        elseif self.ability.name == 'Zipper' then loc_vars = {self.ability.chips}
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
