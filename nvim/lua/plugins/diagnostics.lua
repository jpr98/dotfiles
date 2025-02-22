return {
	"rachartier/tiny-inline-diagnostic.nvim",
	event = "LspAttach",
	priority = 1000, -- needs to be loaded in first
	config = function()
		require("tiny-inline-diagnostic").setup({
			preset = "modern",
			options = {
				show_source = true,
				show_all_diags_on_cursorline = false,
				multilines = {
					enabled = true,
					always_show = false,
				},
			},
		})
		vim.diagnostic.config({ virtual_text = false })
	end,
}

-- vim: ts=4 sts=4 sw=4 et
