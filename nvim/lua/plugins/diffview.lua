return {
	"sindrets/diffview.nvim",
	dependencies = { "akinsho/git-conflict.nvim", version = "*", config = true },
	keys = {
		{ "<leader>gdf", "<cmd>DiffviewFileHistory --follow %<CR>", desc = "[G]it [D]iff [F]ile" },
		{ "<leader>gdh", "<cmd>DiffviewFileHistory<CR>", desc = "[G]it [D]iff [H]istory" },
		{ "<leader>gdm", "<cmd>DiffviewOpen master<CR>", desc = "[G]it [D]iff [M]aster" },
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
}

-- vim: ts=4 sts=4 sw=4 et
