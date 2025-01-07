return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "ficcdaf/ashen.nvim" },
	opts = function()
		local ashen = require("ashen.plugins.lualine").lualine_opts
		ashen.extensions = { "lazy", "fzf" }
		return ashen
	end,
	config = function()
		require("lualine").setup({
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { { "filename", path = 3 } },
				lualine_x = { "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			extensions = { "oil" },
			options = {
				theme = "nord",
			},
		})
	end,
}

-- vim: ts=4 sts=4 sw=4 et
