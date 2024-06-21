-- region Mirrored

local mirrored_shader = SMODS.Shader({key = 'mirrored', path = SMODS.current_mod.path.."assets/", file_name = 'mirrored.fs'})
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
    shader = 'mirrored',
    config = {},
    in_shop = false
})

-- endregion Mirrored