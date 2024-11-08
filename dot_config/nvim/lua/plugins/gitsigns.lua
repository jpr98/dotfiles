return {
	"lewis6991/gitsigns.nvim",
	opts = {
		on_attach = function()
			local gitsigns = require("gitsigns")
			vim.keymap.set("n", "<leader>gb", gitsigns.blame, { desc = "[G]it [B]lame" })
			vim.keymap.set("n", "<leader>gl", gitsigns.toggle_current_line_blame, { desc = "[G]it [L]ine blame" })
			vim.keymap.set("n", "<leader>gp", gitsigns.preview_hunk, { desc = "[G]it [P]review hunk" })
			vim.keymap.set("n", "]g", gitsigns.next_hunk, { desc = "[G]it next hunk" })
			vim.keymap.set("n", "[g", gitsigns.prev_hunk, { desc = "[G]it prev hunk" })
			vim.keymap.set("n", "<leader>gs", gitsigns.stage_hunk, { desc = "[G]it [s]tage hunk" })
			vim.keymap.set("n", "<leader>gr", gitsigns.reset_hunk, { desc = "[G]it [r]eset hunk" })
			vim.keymap.set("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "[G]it [u]ndo stage hunk" })
		end,
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
	},
}
-- vim: ts=4 sts=4 sw=4 et
