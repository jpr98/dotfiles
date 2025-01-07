-- return {
-- 	"shaunsingh/nord.nvim",
-- 	lazy = false,
-- 	priority = 1000,
-- 	config = function()
-- 		vim.cmd.colorscheme("nord")
-- 		require("nord").set()
-- 	end,
-- }

return {
	"ficcdaf/ashen.nvim",
	name = "ashen",
	lazy = false,
	priority = 1000,
	config = function()
		vim.cmd([[colorscheme ashen]])
	end,
}

-- vim: ts=4 sts=4 sw=4 et
