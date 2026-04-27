return {
	"folke/which-key.nvim",
	event = "VimEnter",
	opts = {
		icons = {
			-- set icon mappings to true if you have a Nerd Font
			mappings = vim.g.have_nerd_font,
			-- If you are using a Nerd Font: set icons.keys to an empty table which will use the
			-- default whick-key.nvim defined Nerd Font icons, otherwise define a string table
			keys = {},
		},
		-- Document existing key chains
		spec = {
			{ "<leader>c", group = "[C]ode", mode = { "n", "x" } },
			{ "<leader>d", group = "[D]ocument" },
			{ "<leader>r", group = "[R]ename" },
			{ "<leader>s", group = "[S]earch" },
			{ "<leader>w", group = "[W]orkspace" },
			{ "<leader>t", group = "[T]oggle" },
			{ "<leader>g", group = "[G]it" },
			{ "<leader>h", group = "[H]arpoon", mode = { "n", "v" } },
		},
	},
}
-- vim: ts=4 sts=4 sw=4 et

