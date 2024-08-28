-- region Mirrored

SMODS.Shader({key = 'mirrored', path = "mirrored.fs"})

local mirrored = SMODS.Edition({
    key = "mirrored",
    loc_txt = {
        name = "Mirrored",
        label = "Mirrored",
        text = {
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
    in_shop = false
})
-- endregion Mirrored