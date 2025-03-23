-- region Refund Policy

local refundpolicy = {
	name = "ccc_Refund Policy",
	key = "refundpolicy",
	config = { },
	pos = { x = 4, y = 8 },
	loc_txt = {
		name = 'Refund Policy',
		text = {
			"On skipping a {C:attention}Booster Pack{},",
			"gain a {C:money}50% {C:attention}refund",
			"{C:inactive,s:0.8}(Rounded down){}",
		}
	},
	rarity = 1,
	cost = 3,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "MiiK",
		code = "toneblock",
		concept = "Bred"
	},
    description = "On skipping a Booster Pack, gain a 50% refund"
}

refundpolicy.calculate = function(self, card, context)
	if context.skipping_booster then
		if context.booster.cost > 0 then
			return {dollars = math.max(1, math.floor(context.booster.cost/2))}
		end
	end
end

return refundpolicy
-- endregion Refund Policy