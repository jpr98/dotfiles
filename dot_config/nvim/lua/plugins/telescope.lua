return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		"nvim-telescope/telescope-ui-select.nvim",
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		"fdschmidt93/telescope-egrepify.nvim",
	},
	config = function()
		-- this function removes the oil prefix from the path so telescope cwd
		-- search works as expected
		local function fix_oil_directory(cwd)
			local fixed_cwd = cwd:gsub("oil://", "")
			return fixed_cwd
		end

		local focus_preview = function(prompt_bufnr)
			local action_state = require("telescope.actions.state")
			local picker = action_state.get_current_picker(prompt_bufnr)
			local prompt_win = picker.prompt_win
			local previewer = picker.previewer
			local winid = previewer.state.winid
			local bufnr = previewer.state.bufnr
			vim.keymap.set("n", "<Tab>", function()
				vim.cmd(string.format("noautocmd lua vim.api.nvim_set_current_win(%s)", prompt_win))
			end, { buffer = bufnr })
			vim.cmd(string.format("noautocmd lua vim.api.nvim_set_current_win(%s)", winid))
			-- api.nvim_set_current_win(winid)
		end

		-- [[ Configure Telescope ]]
		-- See `:help telescope` and `:help telescope.setup()`
		require("telescope").setup({
			-- You can put your default mappings / updates / etc. in here
			--  All the info you're looking for is in `:help telescope.setup()`
			--
			defaults = {
				mappings = {
					i = { ["<c-enter>"] = "to_fuzzy_refine" },
					n = { ["<Tab>"] = focus_preview },
				},
				file_ignore_patterns = { ".git/", "%.png" },
				path_display = { "smart" },
			},
			pickers = {
				live_grep = {
					cwd = fix_oil_directory(require("telescope.utils").buffer_dir()),
				},
				find_files = {
					hidden = true,
					cwd = fix_oil_directory(require("telescope.utils").buffer_dir()),
				},
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
				egrepify = {
					title = true,
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--hidden",
					},
					cwd = fix_oil_directory(require("telescope.utils").buffer_dir()),
				},
			},
		})

		-- Enable Telescope extensions if they are installed
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")
		pcall(require("telescope").load_extension("egrepify"))

		-- See `:help telescope.builtin`
		local builtin = require("telescope.builtin")

		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
		vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
		vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
		vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
		vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
		vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "[B] Find existing buffers" })
		vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
		vim.keymap.set("n", "<leader>s.", function()
			builtin.oldfiles({
				only_cwd = true,
			})
		end, { desc = '[S]earch Recent Files ("." for repeat)' })
		vim.keymap.set("n", "<leader>sg", function()
			require("telescope").extensions.egrepify.egrepify({})
		end, { desc = "[S]earch by [G]rep with Prefixes" })

		-- Slightly advanced example of overriding default behavior and theme
		vim.keymap.set("n", "<leader>/", function()
			-- You can pass additional configuration to Telescope to change the theme, layout, etc.
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, { desc = "[/] Fuzzily search in current buffer" })

		-- It's also possible to pass additional configuration options.
		--  See `:help telescope.builtin.live_grep()` for information about particular keys
		vim.keymap.set("n", "<leader>s/", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, { desc = "[S]earch [/] in Open Files" })

		-- Shortcut for searching your Neovim configuration files
		vim.keymap.set("n", "<leader>sn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "[S]earch [N]eovim files" })
	end
}
-- vim: ts=4 sts=4 sw=4 et