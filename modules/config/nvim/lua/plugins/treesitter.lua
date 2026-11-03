return {
	{ "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },

	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = function()
			local TS = require("nvim-treesitter")
			if not TS.get_installed then
				return
			end
			TS.update(nil, { summary = true })
		end,
		event = { "LazyFile", "VeryLazy" },
		cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
		opts = {
			ensure_installed = {
				"astro",
				"cmake",
				"cpp",
				"css",
				"fish",
				"gitignore",
				"go",
				"graphql",
				"http",
				"java",
				"php",
				"rust",
				"scss",
				"sql",
				"svelte",
			},

			-- matchup = {
			-- 	enable = true,
			-- },

			-- https://github.com/nvim-treesitter/playground#query-linter
			query_linter = {
				enable = true,
				use_virtual_text = true,
				lint_events = { "BufWrite", "CursorHold" },
			},

			playground = {
				enable = true,
				disable = {},
				updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
				persist_queries = true, -- Whether the query persists across vim sessions
				keybindings = {
					toggle_query_editor = "o",
					toggle_hl_groups = "i",
					toggle_injected_languages = "t",
					toggle_anonymous_nodes = "a",
					toggle_language_display = "I",
					focus_language = "f",
					unfocus_language = "F",
					update = "R",
					goto_node = "<cr>",
					show_help = "?",
				},
			},
		},
		config = function(_, opts)
			local TS = require("nvim-treesitter")

			-- some quick sanity checks
			if not TS.get_installed then
				return
			elseif type(opts.ensure_installed) ~= "table" then
				return
			end

			-- setup treesitter
			TS.setup(opts)

			-- install missing parsers
			local installed = TS.get_installed() or {}
			local install = vim.tbl_filter(function(lang)
				return not vim.tbl_contains(installed, lang)
			end, opts.ensure_installed or {})
			if #install > 0 then
				TS.install(install, { summary = true })
			end

			-- MDX
			vim.filetype.add({
				extension = {
					mdx = "mdx",
				},
			})
			vim.treesitter.language.register("markdown", "mdx")
		end,
	},
}