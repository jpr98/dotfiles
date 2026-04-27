return {
	{
		"ficcdaf/ashen.nvim",
		name = "ashen",
		config = function()
			-- vim.cmd([[colorscheme ashen]])
		end,
	},
	{
		"cdmill/neomodern.nvim",
		priority = 1000,
		config = function()
			-- require("neomodern").setup({
			-- 	theme = "roseprime",
			-- })
			-- require("neomodern").load()
		end,
	},
	{
		"shaunsingh/nord.nvim",
		config = function()
			-- vim.g.nord_contrast = true
			-- vim.cmd.colorscheme("nord")
			-- require("nord").set()
		end,
	},
	{
		"rebelot/kanagawa.nvim",
	},
	{
		"vague2k/vague.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("vague").setup({
				-- optional configuration here
			})
			vim.cmd("colorscheme vague")
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		opts = {
			flavour = "macchiato",
			integrations = {
				blink_cmp = true,
				diffview = true,
				harpoon = true,
				native_lsp = {
					enabled = true,
					virtual_text = {
						errors = { "italic" },
						hints = { "italic" },
						warnings = { "italic" },
						information = { "italic" },
						ok = { "italic" },
					},
					underlines = {
						errors = { "underline" },
						hints = { "underline" },
						warnings = { "underline" },
						information = { "underline" },
						ok = { "underline" },
					},
					inlay_hints = {
						background = true,
					},
				},
				which_key = true,
			},
		},
	},
}

-- vim: ts=4 sts=4 sw=4 et
