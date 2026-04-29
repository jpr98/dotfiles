return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	lazy = false,
	config = function()
		local parsers = {
			"bash",
			"c",
			"diff",
			"go",
			"http",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"vim",
			"vimdoc",
			"vue",
			"python",
		}

		require("nvim-treesitter").install(parsers)

		local filetypes = {}
		for _, lang in ipairs(parsers) do
			local ft = vim.treesitter.language.get_filetypes(lang)
			vim.list_extend(filetypes, ft)
		end

		vim.api.nvim_create_autocmd("FileType", {
			pattern = filetypes,
			callback = function(ev)
				local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
				if lang and pcall(vim.treesitter.start, ev.buf, lang) then
					vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})
	end,
}
-- vim: ts=4 sts=4 sw=4 et
