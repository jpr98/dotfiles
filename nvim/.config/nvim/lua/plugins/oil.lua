return {
	"stevearc/oil.nvim",
	opts = {},
	-- Optional dependencies
	dependencies = {
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	config = function()
		local oil = require("oil")
		oil.setup({
			delete_to_trash = true,
			view_options = {
				show_hidden = true,
				is_always_hidden = function(name, _)
					return name == ".." or name == ".git"
				end,
			},
			float = {
				padding = 5,
			},
			keymaps = {
				["<C-s>"] = false,
				["<C-v>"] = {
					"actions.select",
					opts = { vertical = true },
					desc = "Open the entry in a vertical split",
				},
				["<C-y>"] = {
					"actions.yank_entry",
				},
				["<Esc>"] = {
					"actions.close",
				},
			},
		})
		vim.keymap.set("n", "-", function()
			local util = require("oil.util")
			oil.open_float()
			util.run_after_load(0, function()
				oil.open_preview()
			end)
		end, { desc = "Open oil with preview" })
	end,
}

-- vim: ts=4 sts=4 sw=4 et
