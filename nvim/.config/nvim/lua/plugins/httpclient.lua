return {
	"rest-nvim/rest.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		-- The global config must run before using :Rest
		vim.g.rest_nvim = {
			client = {
				preferred = "curl",
				curl = {
					extra_args = { "--cookie", "", "--cookie-jar", "/dev/null" },
					-- by_host = { ["ondigitalocean%.app"] = { extra_args = { "--cookie", "", "--cookie-jar", "/dev/null" } } },
				},
			},
			hooks = {
				response = [[
                    const keys = Object.keys(response.headers || {});
                    for (const k of keys) {
                        if (k.toLowerCase() === "set-cookie") {
                            delete response.headers[k];
                        }
                    }
                    if (Array.isArray(response.cookies)) {
                        response.cookies = [];
                    }
                ]],
			},
		}

		-- Format JSON responses with jq (used by rest.nvim's gq-based formatter)
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "json",
			callback = function()
				vim.bo.formatprg = "jq"
			end,
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "http",
			callback = function()
				-- buffer-local normal-mode mapping: <leader>r -> :w<CR>:!python %<CR>
				vim.keymap.set("n", "<leader>dr", "<cmd>Rest run<CR>", { noremap = true, silent = true, buffer = true })
				vim.keymap.set(
					"n",
					"<leader>de",
					"<cmd>Rest env select<CR>",
					{ noremap = true, silent = true, buffer = true }
				)
			end,
		})
	end,
}

-- vim: ts=4 sts=4 sw=4 et
