return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {},
	keys = {
		{
			"<leader>st",
			function()
				Snacks.picker.todo_comments({
					on_show = function()
						vim.cmd.stopinsert()
					end,
				})
			end,
			desc = "Todo",
		},
	},
}

-- vim: ts=4 sts=4 sw=4 et
