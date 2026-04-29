return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
		},
		config = function()
			vim.g.gopls_code_action_order = vim.g.gopls_code_action_order
				or {
					"fill",
					-- { kind = "source.organizeImports" },
				}

			local function matches_rule(action, rule)
				if not rule then
					return false
				end

				local title = (action.title or ""):lower()
				local kind = (action.kind or ""):lower()
				local command = ""
				if action.command and action.command.command then
					command = action.command.command:lower()
				end

				if type(rule) == "string" then
					rule = rule:lower()
					return title:find(rule, 1, true) or kind:find(rule, 1, true) or command:find(rule, 1, true)
				end

				if type(rule) == "table" then
					if type(rule.title) == "string" and not title:find(rule.title:lower(), 1, true) then
						return false
					end
					if type(rule.kind) == "string" and not kind:find(rule.kind:lower(), 1, true) then
						return false
					end
					if type(rule.command) == "string" and not command:find(rule.command:lower(), 1, true) then
						return false
					end
					return true
				end

				return false
			end

			local function gopls_code_action_priority(action, rules)
				for idx, rule in ipairs(rules) do
					if matches_rule(action, rule) then
						return idx
					end
				end

				return math.huge
			end

			if not vim.g.__gopls_code_action_wrapped then
				vim.g.__gopls_code_action_wrapped = true
				local original_code_action = vim.lsp.buf.code_action
				vim.lsp.buf.code_action = function(opts)
					opts = opts or {}
					local original_select = vim.ui.select
					local select_called = false

					vim.ui.select = function(items, select_opts, on_choice)
						if not select_called then
							select_called = true
							vim.ui.select = original_select
						end

						local rules = vim.g.gopls_code_action_order
						if
							select_opts
							and select_opts.kind == "codeaction"
							and vim.tbl_islist(items)
							and vim.tbl_islist(rules)
							and not vim.tbl_isempty(items)
							and not vim.tbl_isempty(rules)
						then
							local decorated = {}
							for idx, entry in ipairs(items) do
								decorated[idx] = { entry = entry, original_index = idx }
							end

							table.sort(decorated, function(a, b)
								local function sort_key(wrapper)
									local action = wrapper.entry and wrapper.entry.action or nil
									local ctx = wrapper.entry and wrapper.entry.ctx or nil
									if not action or not ctx or not ctx.client_id then
										return 1, math.huge, wrapper.original_index, action and action.title or ""
									end

									local client = vim.lsp.get_client_by_id(ctx.client_id)
									if not client or client.name ~= "gopls" then
										return 1, math.huge, wrapper.original_index, action.title or ""
									end

									local priority = gopls_code_action_priority(action, rules)

									if priority ~= math.huge then
										return 0, priority, wrapper.original_index, action.title or ""
									end

									return 2, math.huge, wrapper.original_index, action.title or ""
								end

								local a_cat, a_prio, a_idx, a_title = sort_key(a)
								local b_cat, b_prio, b_idx, b_title = sort_key(b)

								if a_cat ~= b_cat then
									return a_cat < b_cat
								end

								if a_prio ~= b_prio then
									return a_prio < b_prio
								end

								if a_idx ~= b_idx then
									return a_idx < b_idx
								end

								return a_title < b_title
							end)

							for idx, wrapper in ipairs(decorated) do
								items[idx] = wrapper.entry
							end
						end

						return original_select(items, select_opts, on_choice)
					end

					local ok, result = pcall(original_code_action, opts)
					if not select_called then
						vim.ui.select = original_select
					end
					if not ok then
						error(result)
					end
					return result
				end
			end

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- Jump to the definition of the word under your cursor.
					--  This is where a variable was first declared, or where a function is defined, etc.
					--  To jump back, press <C-t>.
					-- map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

					-- Find references for the word under your cursor.
					-- map("gr", require("elescope.builtin").lsp_references, "[G]oto [R]eferences")

					-- Jump to the implementation of the word under your cursor.
					--  Useful when your language has ways of declaring types without an actual implementation.
					-- map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

					-- Jump to the type of the word under your cursor.
					--  Useful when you're not sure what type a variable is and you want to see
					--  the definition of its *type*, not where it was *defined*.
					-- map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

					-- Fuzzy find all the symbols in your current document.
					--  Symbols are things like variables, functions, types, etc.
					-- map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

					-- Fuzzy find all the symbols in your current workspace.
					--  Similar to document symbols, except searches over your entire project.
					-- map(
					-- 	"<leader>ws",
					-- 	require("telescope.builtin").lsp_dynamic_workspace_symbols,
					-- 	"[W]orkspace [S]ymbols"
					-- )

					-- Rename the variable under your cursor.
					--  Most Language Servers support renaming across files, etc.
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

					-- Execute a code action, usually your cursor needs to be on top of an error
					-- or a suggestion from your LSP for this to activate.
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

					-- WARN: This is not Goto Definition, this is Goto Declaration.
					--  For example, in C this would take you to the header.
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					-- Hover
					map("K", vim.lsp.buf.hover, "Toggle Hover")

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					-- The following code creates a keymap to toggle inlay hints in your
					-- code, if the language server you are using supports them
					--
					-- This may be unwanted, since they displace some of your code
					if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
			if vim.g.colors_name == "nord" then
				vim.api.nvim_set_hl(0, "BlinkCmpGhostText", { ctermfg = 102, fg = "#888888" })
			end

			-- Enable the following language servers
			local servers = {
				clangd = {},
				gopls = {
					settings = {
						gopls = {
							completeUnimported = true,
							usePlaceholders = true,
							completeFunctionCalls = true,
							analyses = {
								shadow = true,
								unusedparams = true,
								unusedwrite = true,
								unusedvariable = true,
								unusedresult = true,
							},
							staticcheck = true,
							gofumpt = true,
							-- hints = {
							-- 	assignVariableTypes = true,
							-- 	compositeLiteralFields = true,
							-- 	compositeLiteralTypes = true,
							-- 	constantValues = true,
							-- 	functionTypeParameters = true,
							-- 	parameterNames = true,
							-- 	rangeVariableTypes = true,
							-- },
						},
					},
				},
				pyright = {},
				bashls = {},
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
				-- volar = { "vue" },
			}

			-- Ensure the servers and tools above are installed
			require("mason").setup()

			-- You can add other tools here that you want Mason to install
			-- for you, so that they are available from within Neovim.
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
				"prettier",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			---@diagnostic disable [missing-fields]
			require("mason-lspconfig").setup({
				automatic_enable = {
					exclude = { "ts_ls" },
				},
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
					["ts_ls"] = function()
						-- do nothing, managed by typescript-tools
					end,
				},
			})
		end,
	},
	{
		-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis
		"folke/lazydev.nvim",
		dependencies = {
			"justinsgithub/wezterm-types",
		},
		ft = "lua",
		opts = {
			library = {
				"lazy.nvim",
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
				{ path = "wezterm-types", mods = { "wezterm" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true },
	{
		"saghen/blink.cmp",
		lazy = false, -- lazy loading handled internally
		-- optional: provides snippets for the snippet source
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					-- Build Step is needed for regex support in snippets.
					-- This step is not supported in many windows environments.
					-- Remove the below condition to re-enable on windows.
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					-- `friendly-snippets` contains a variety of premade snippets.
					--    See the README about individual language/framework/plugin snippets:
					--    https://github.com/rafamadriz/friendly-snippets
					{
						"rafamadriz/friendly-snippets",
						config = function()
							require("luasnip.loaders.from_vscode").lazy_load()
						end,
					},
				},
			},
		},

		-- use a release tag to download pre-built binaries
		version = "v0.*",

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				preset = "default",
			},
			sources = {
				default = function(ctx)
					local success, node = pcall(vim.treesitter.get_node)
					if
						success
						and node
						and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type())
					then
						return { "buffer" }
					else
						return { "lsp", "path", "buffer" }
					end
				end,
				per_filetype = {
					sql = { "dadbod", "buffer", "snippets" },
				},
				providers = {
					dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
				},
			},
			signature = { enabled = true },
			completion = {
				ghost_text = { enabled = true },
				documentation = { auto_show = true, auto_show_delay_ms = 500 },
				menu = { draw = { treesitter = { "lsp" } } },
			},
		},
	},
}

-- vim: ts=4 sts=4 sw=4 et
