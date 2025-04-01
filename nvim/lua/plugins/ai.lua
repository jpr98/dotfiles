return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	version = false,
	opts = {
		-- add any opts here
		provider = "copilot",
		auto_suggestions_provider = "copilot",
		behaviour = {
			auto_apply_diff_after_generation = true,
			enable_token_counting = false,
		},
		suggestion = {
			debounce = 1000,
		},
		file_selector = {
			provider = "snacks",
		},
		windows = {
			position = "left",
		},
	},
	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	build = "make",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"folke/snacks.nvim",
		--- The below dependencies are optional,
		"nvim-tree/nvim-web-devicons",
		"zbirenbaum/copilot.lua", -- for providers='copilot'
		{
			-- Make sure to set this up properly if you have lazy=true
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
}

-- vim: ts=4 sts=4 sw=4 et
