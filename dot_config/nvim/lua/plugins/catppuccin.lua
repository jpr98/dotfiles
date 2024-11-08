return {
	"catppuccin/nvim",
	lazy = false,
	name = "catppuccin",
	priority = 1000,
	config = function()
		vim.cmd.colorscheme("catppuccin-macchiato")
		vim.cmd.hi("Comment gui=none")
	end,
}

-- vim: ts=4 sts=4 sw=4 et

