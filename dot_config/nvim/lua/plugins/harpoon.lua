return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()
		-- basic telescope configuration
		local conf = require("telescope.config").values
		local function toggle_telescope(harpoon_files)
			local file_paths = {}
			for _, item in pairs(harpoon_files.items) do
				table.insert(file_paths, item.value)
			end

			local function remove_harpoon_entry(prompt_bufnr)
				local actions = require("telescope.actions")
				local action_state = require("telescope.actions.state")
				-- Get the current selection
				local selection = action_state.get_selected_entry()
				-- Close the Telescope prompt before executing the action
				actions.close(prompt_bufnr)
				-- Remove harpoon entry
				if selection then
					harpoon:list():remove_at(selection.index)
				end
			end

			require("telescope.pickers")
				.new({}, {
					prompt_title = "Harpoon",
					finder = require("telescope.finders").new_table({
						results = file_paths,
					}),
					previewer = conf.file_previewer({}),
					sorter = conf.generic_sorter({}),
					attach_mappings = function(_, map)
						map("i", "<C-e>", remove_harpoon_entry)
						map("n", "x", remove_harpoon_entry)
						return true
					end,
				})
				:find()
		end

		vim.keymap.set("n", "<leader><leader>", function()
			toggle_telescope(harpoon:list())
		end, { desc = "Open harpoon window" })

		vim.keymap.set("n", "<leader>ha", function()
			harpoon:list():add()
		end, { desc = "[H]arpoon [A]dd entry" })

		vim.keymap.set("n", "<C-,>", function()
			harpoon:list():prev({ ui_nav_wrap = true })
		end)
		vim.keymap.set("n", "<C-.>", function()
			harpoon:list():next({ ui_nav_wrap = true })
		end)
	end,
}

-- vim: ts=4 sts=4 sw=4 et