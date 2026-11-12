return {
	-- ========== AUTOCOMPLETION ==========
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter", -- Load saat mulai insert
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			require("config.nvimcmp")
		end,
	},

	-- ========== SNIPPETS ==========
	{
		"L3MON4D3/LuaSnip",
		dependencies = { "rafamadriz/friendly-snippets" },
		event = "InsertEnter",
	},

	-- ========== DIAGNOSTICS UI ==========
	{
		"folke/trouble.nvim",
		cmd = { "TroubleToggle", "Trouble" },
		keys = {
			{ "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>" },
		},
		opts = {
			use_diagnostic_signs = true,
		},
	},

	{
		"nvimtools/none-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	-- ========== LSP MANAGER ==========
	{
		"williamboman/mason.nvim",
		event = { "BufReadPre", "BufNewFile" },
		cmd = { "Mason", "MasonInstall", "MasonUpdate" },
		build = ":MasonUpdate",
		opts = {
			ui = {
				border = "rounded",
			},
		},
	},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		event = { "BufReadPre", "BufNewFile" }, -- Load sebelum buffer
	},

	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require("config.lsp")
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("config.treesitter")
		end,
	},

	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local conform = require("conform")

			vim.g.autoformat = true

			conform.setup({
				formatters_by_ft = {
					lua = { "stylua" },
					rust = { "rustfmt" }, -- Format untuk Rust
					javascript = { "prettier" },
					typescript = { "prettier" },
					html = { "prettier" },
					css = { "prettier" },
					vue = { "prettier" },
					json = { "prettier" },
					bash = { "shfmt" },
				},

				-- Hubungkan variabel global vim.g.disable_autoformat di sini
				format_on_save = function(bufnr)
					-- Jika vim.g.disable_autoformat bernilai true, batalkan autoformat
					if vim.g.disable_autoformat then
						return
					end

					return {
						timeout_ms = 5000,
						lsp_fallback = true,
					}
				end,
			})
		end,
	},
}
