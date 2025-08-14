return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()
		vim.keymap.set("n", "<leader>hw", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Open harpoon window" })

		vim.keymap.set("n", "<leader>hh", function()
			harpoon:list():add()
		end, { desc = "[H]arpoon [A]dd entry" })

		vim.keymap.set("n", "<C-,>", function()
			harpoon:list():prev({ ui_nav_wrap = true })
		end)
		vim.keymap.set("n", "<C-.>", function()
			harpoon:list():next({ ui_nav_wrap = true })
		end)

		harpoon:extend({
			UI_CREATE = function(cx)
				vim.keymap.set("n", "<C-v>", function()
					harpoon.ui:select_menu_item({ vsplit = true })
				end, { buffer = cx.bufnr })
			end,
		})

		local harpoon_extensions = require("harpoon.extensions")
		harpoon:extend(harpoon_extensions.builtins.highlight_current_file())
	end,
}

-- vim: ts=4 sts=4 sw=4 et
