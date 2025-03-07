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
end
