return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		dashboard = {
			sections = {
				{ section = "header" },
				{ section = "keys", gap = 1 },
				{
					icon = " ",
					title = "Recent Files",
					section = "recent_files",
					cwd = true,
					indent = 2,
					padding = { 2, 2 },
				},
				{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
				{ section = "startup" },
			},
		},
		picker = {},
	},
	keys = {
		{
			"<leader>sf",
			function()
				---@diagnostic disable-next-line: missing-fields
				Snacks.picker.files({
					matcher = {
						cwd_bonus = true,
						frecency = true,
					},
					filter = { cwd = true },
					hidden = true,
					args = { "--no-ignore-vcs" },
				})
			end,
			desc = "[S]earch [F]iles",
		},
		{
			"<leader>sb",
			function()
				---@diagnostic disable-next-line: missing-fields
				Snacks.picker.buffers({
					current = false,
					hidden = true,
					on_show = function()
						vim.cmd.stopinsert()
					end,
				})
			end,
			desc = "[S]earch open [B]uffers",
		},
		{
			"<leader>sg",
			function()
				---@diagnostic disable-next-line: missing-fields
				Snacks.picker.grep({ hidden = true, matcher = { frecency = true } })
			end,
			desc = "[S]earch live [G]rep",
		},
		{
			"<leader>s.",
			function()
				Snacks.picker.resume()
			end,
			desc = "[S]earch [.] repeat",
		},
		{
			"<leader>sd",
			function()
				Snacks.picker.diagnostics({
					on_show = function()
						vim.cmd.stopinsert()
					end,
				})
			end,
			desc = "[S]earch [D]iagnostics",
		},
		{
			"<leader>sw",
			function()
				Snacks.picker.grep_word()
			end,
			desc = "[S]earch current [W]ord",
		},
		{
			"<leader>sl",
			function()
				Snacks.picker.lines()
			end,
			desc = "[S]earch [L]ines",
		},
		{
			"<leader>sp",
			function()
				Snacks.picker.pickers()
			end,
			desc = "[S]earch [P]ickers",
		},
		{
			"<leader>sr",
			function()
				Snacks.picker.recent()
			end,
			desc = "[S]earch [R]ecent",
		},
		{
			"<leader>ss",
			function()
				Snacks.picker.smart()
			end,
			desc = "[S]earch [S]mart",
		},
		{
			"<leader>su",
			function()
				Snacks.picker.undo({
					on_show = function()
						vim.cmd.stopinsert()
					end,
				})
			end,
			desc = "[S]earch [U]ndo",
		},
		{
			"<leader>sC",
			function()
				Snacks.picker.colorschemes()
			end,
			desc = "[S]earch [C]colorschemes",
		},
		-- Git-related pickers
		{
			"<leader>scb",
			function()
				Snacks.picker.git_branches({
					on_show = function()
						vim.cmd.stopinsert()
					end,
				})
			end,
			desc = "[S]earch [G]it [B]ranches",
		},
		{
			"<leader>scd",
			function()
				Snacks.picker.git_diff({
					on_show = function()
						vim.cmd.stopinsert()
					end,
				})
			end,
			desc = "[S]earch [G]it [D]iff",
		},
		{
			"<leader>scl",
			function()
				Snacks.picker.git_log({
					on_show = function()
						vim.cmd.stopinsert()
					end,
				})
			end,
			desc = "[S]earch [G]it [L]og",
		},
		{
			"<leader>scc",
			function()
				Snacks.picker.git_log_file()
			end,
			desc = "[S]earch [G]it [C]commits (file)",
		},
		-- LSP-related pickers
		{
			"gd",
			function()
				Snacks.picker.lsp_definitions({
					on_show = function()
						vim.cmd.stopinsert()
					end,
				})
			end,
			desc = "[G]oto [D]efinition",
		},
		{
			"gr",
			function()
				Snacks.picker.lsp_references({
					on_show = function()
						vim.cmd.stopinsert()
					end,
				})
			end,
			desc = "[G]oto [R]references",
		},
		{
			"gI",
			function()
				Snacks.picker.lsp_implementations({
					on_show = function()
						vim.cmd.stopinsert()
					end,
				})
			end,
			desc = "[G]oto [I]mplementations",
		},
		{
			"<leader>D",
			function()
				Snacks.picker.lsp_type_definitions({
					on_show = function()
						vim.cmd.stopinsert()
					end,
				})
			end,
			desc = "Type [D]efinitions",
		},
		{
			"<leader>ds",
			function()
				Snacks.picker.lsp_symbols()
			end,
			desc = "[D]ocument [S]ymbols",
		},
		{
			"<leader>ws",
			function()
				Snacks.picker.lsp_workspace_symbols({
					on_show = function()
						vim.cmd.stopinsert()
					end,
				})
			end,
			desc = "[W]workspace [S]ymbols",
		},
	},
}
-- vim: ts=4 sts=4 sw=4 et
