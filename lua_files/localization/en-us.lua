function SMODS.current_mod.process_loc_text()

G.localization.descriptions.Other.partofyou_complements = {
	name = "Complements",
	text = {
		"{s:0.83}Ace <> King{C:white,s:0.83}ii{s:0.83} ", -- suuuuuper scuffed text centering
		"{s:0.83}  2 <> Queen",
		"{s:0.83}  3 <> Jack ",
		"{s:0.83}  4 <> 10   ",
		"{s:0.83}  5 <> 9    ",
		"{s:0.83}  6 <> 8    ",
		"{s:0.83}  7 <> 7    "
	}
}

-- ok this isn't really how a localisation file works...
-- i need to fix this at some point

G.localization.descriptions.Other.e_mirrored = {
	name = "Mirrored",
	text = {
		"If a {C:attention}Mirror{} is present,",
		"{C:attention}retrigger{} this card,",
		"otherwise it {C:red}self-destructs{}",
		"at end of round",
	}
}
G.localization.descriptions.Other.ccc_acts_as_mirror = {
	name = "n2",
	text = {
		"{C:inactive,s:0.9}(Acts as a {C:attention,s:0.9}Mirror{C:inactive,s:0.9})"
	}
}
G.localization.descriptions.Other.ccc_focused = {
	name = "n3",
	text = {
		"{C:inactive,s:0.9}(Focused by {C:attention,s:0.9}#1#{C:inactive,s:0.9})"
	}
}

G.localization.misc.labels.k_ccc_strawberry_badge = "Strawberry"

-- here so they can change for squared effects
if CardSleeves then
	G.localization.descriptions.Sleeve.sleeve_ccc_bside = {
		name = "B-Side Sleeve",
		text = {
			"Every blind is a {C:red}boss blind{}",
			"Start from {C:attention}Ante 0{}",
			"Skipping costs {C:red}$8{} multiplied",
			"by ({C:attention}Current Ante{} + {C:attention}1{})",
		}
	}
	G.localization.descriptions.Sleeve.sleeve_ccc_bside_alt = {
		name = "B-Side Sleeve",
		text = {
			"Every blind is {C:red}partnered{}",
			"{C:blue}+#1#{} hand, {C:red}+#2#{} discard, and {C:attention}+#3#{} Joker Slot",
		}
	}
	G.localization.descriptions.Sleeve.sleeve_ccc_virus = {
		name = "Virus Sleeve",
		text = {
			"Each played card is retriggered",
			"then {C:red}debuffed{}",
			"until the end of the ante"
		}
	}
	G.localization.descriptions.Sleeve.sleeve_ccc_virus_alt = {
		name = "Virus Sleeve",
		text = {
			"Each played card is retriggered",
			"then {C:red}debuffed{}",
			"until the end of the ante",
--			"Each played card is retriggered twice",
--			"All drawn cards are {C:red}debuffed{}",
--			"until the end of the ante"
		}
	}
	G.localization.descriptions.Sleeve.sleeve_ccc_summit = {
		name = "Summit Sleeve",
		text = {
			"{C:attention}-4{} Joker slots",
			"{C:attention}+1{} Joker slot each Ante",
			"without a {C:red}final boss{}",
			"{s:0.75}(if Ante has not been reached before){}"
		}
	}
	G.localization.descriptions.Sleeve.sleeve_ccc_summit_alt = {
		name = "Summit Sleeve",
		text = {
			"You win only upon defeating Ante 16"
		}
	}
end

end
