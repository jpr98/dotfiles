return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "ficcdaf/ashen.nvim" },
	opts = function()
		-- local ashen = require("ashen.plugins.lualine").lualine_opts
		-- ashen.extensions = { "lazy", "fzf" }
		-- return ashen
	end,
	config = function()
		local diffview = require("custom.lualine_diffview")

		local mode_width = 0
		local branch_width = 0
		local diff_width = 0
		local filetype_width = 0
		local filename_width = 0

		local custom_sections = {
			lualine_a = {
				{
					"mode",
					fmt = function(str)
						if str == "" then
							mode_width = 0
							return ""
						end
						mode_width = #str + 2 -- 2 is the length of padding
						return str
					end,
					separator = { left = "" },
					right_padding = 2,
				},
			},
			lualine_b = {
				{
					"branch",
					cond = function()
						local should_show = vim.opt.columns:get() > 60
						if not should_show then
							branch_width = 0
						end
						return should_show
					end,
					fmt = function(str)
						if str == "" then
							branch_width = 0
							return ""
						end
						branch_width = #str + 2 + 2 -- 4 is the length of icon (unicode), 2 is the length of padding
						return str
					end,
				},
			},
			lualine_c = {
				{
					"diff",
					cond = function()
						local should_show = vim.opt.columns:get() > 60
						if not should_show then
							diff_width = 0
						end
						return should_show
					end,
					fmt = function(str)
						if str == "" then
							diff_width = 0
							return ""
						end
						local evaled_str = vim.api.nvim_eval_statusline(str, {}).str
						diff_width = #evaled_str + 2 -- 2 is the length of padding
						return str
					end,
				},
				{
					-- fill space to center the filetype + filename
					function()
						local used_space = mode_width + branch_width + diff_width
						local win_width = vim.opt.columns:get()
						local fill_space =
							string.rep(" ", math.floor((win_width - filename_width - filetype_width) / 2) - used_space)
						return fill_space
					end,
					padding = { left = 0, right = 0 },
					cond = function()
						return not diffview.is_diffview_active() and vim.opt.columns:get() > 60
					end,
				},
				{
					"filename",
					fmt = function(filename)
						if filename == "" then
							filename_width = 0
							return ""
						end

						local used_space = mode_width + branch_width + diff_width
						local win_width = vim.opt.columns:get()
						local free_space = (math.floor(win_width / 2) - used_space) * 2

						-- if the filename is longer than the free space, use the filename
						if free_space < #filename + filetype_width + 10 then
							filename = vim.fn.expand("%:t")
						end

						-- if the filename is still longer than the free space, cut the filename
						if free_space < #filename + filetype_width + 10 then
							local end_idx = free_space - filetype_width - 13
							if end_idx < 0 then
								return ""
							end
							filename = string.sub(filename, 1, end_idx) .. "..."
						end

						filename_width = #filename + 2 -- 2 is the length of padding

						return filename
					end,
					file_status = true, -- Displays file status (readonly status, modified status)
					path = (diffview.is_diffview_active and 3 or 0),
					-- 0: Just the filename
					-- 1: Relative path
					-- 2: Absolute path
					-- 3: Absolute path, with tilde as the home directory
					-- 4: Filename and parent dir, with tilde as the home directory
				},
			},
			lualine_x = {
				{
					"filetype",
					fmt = function(str)
						if str == "" then
							filetype_width = 0
							return ""
						end
						filetype_width = 1 + 2 -- 4 is the length of icon (unicode), 2 is the length of padding
						return str
					end,
					-- icon_only = true,
				},
				{ "diagnostics" },
				{
					diffview.diffview_status,
					cond = diffview.is_diffview_active,
				},
			},
			lualine_y = {
				"progress",
			},
			lualine_z = {
				{
					"location",
					padding = { left = 1, right = 0 },
					separator = { right = "" },
				},
			},
		}

		local config = {
			sections = custom_sections,
			extensions = { "oil" },
			options = {
				theme = vim.g.colors_name,
				component_separators = "",
				section_separators = { left = "", right = "" },
			},
		}
		require("lualine").setup(config)
	end,
}

-- vim: ts=4 sts=4 sw=4 et
