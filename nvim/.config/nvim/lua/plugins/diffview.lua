return {
	"sindrets/diffview.nvim",
	dependencies = { "akinsho/git-conflict.nvim", version = "*", config = true },
	keys = {
		{ "<leader>gdf", "<cmd>DiffviewFileHistory --follow %<CR>", desc = "[G]it [D]iff [F]ile" },
		{ "<leader>gdh", "<cmd>DiffviewFileHistory<CR>", desc = "[G]it [D]iff [H]istory" },
		{
			"<leader>gdm",
			"<cmd>lua require('custom.diffview_filter').open_main_master_diffview()<CR>",
			desc = "[G]it [D]iff [M]aster",
		},
		{
			"<leader>gdd",
			"<cmd>lua require('custom.diffview_filter').open_filtered_diffview()<CR>",
			desc = "[G]it [D]iff against HEAD",
		},
		{ "<leader>gdc", "<cmd>DiffviewClose<CR>", desc = "[G]it [D]iff [C]lose" },
	},
	opts = {
		view = {
			merge_tool = {
				layout = "diff1_plain",
			},
		},
	},
	config = function()
		vim.keymap.set("n", "<leader>gdi", function()
			local input = vim.fn.input("DiffviewOpen: ")
			-- Run a command using the input
			if input ~= "" then
				vim.cmd("DiffviewOpen " .. input)
			else
				print("No input provided")
			end
		end, { noremap = true, silent = true, desc = "[G]it [D]iff [I]nput" })
	end,
}

-- vim: ts=4 sts=4 sw=4 et
