return {
	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope", -- Load saat command dipanggil
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<cr>" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<cr>" },
			{ "<leader>fn", "<cmd>Telescope notify<cr>" },
			{ "<leader>fk", "<cmd>Telescope keymaps<cr>" },
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-fzf-native.nvim",
		},
		config = function()
			require("config.telescope")
		end,
	},

	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make", -- Compile saat install
		cond = vim.fn.executable("make") == 1, -- Conditional install
	},

	{
		"NvChad/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({
				"*",
			}, {
				mode = "background",
				names = false,
			})
		end,
	},

	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			local toggleterm = require("toggleterm")

			toggleterm.setup({
				size = function(term)
					if term.direction == "horizontal" then
						return 15
					elseif term.direction == "vertical" then
						return math.floor(vim.o.columns * 0.40)
					end
				end,
				open_mapping = [[<M-i>]],
				hide_numbers = true,
				shade_terminals = true,
				shading_factor = 2,
				start_in_insert = true,
				insert_mappings = true,
				terminal_mappings = true,
				persist_size = true,
				persist_mode = true,
				persist_session = true,
				direction = "float",
				float_opts = {
					border = "rounded",
					width = math.floor(vim.o.columns * 0.85),
					height = math.floor(vim.o.lines * 0.65),
					winblend = 0,
				},
			})

			local tt = require("config.toggleterm")
			local map = vim.keymap.set
			local opts = { noremap = true, silent = true }

			-- Keymap Terminal Utama (M-i)
			map({ "n", "t" }, "<M-i>", tt.toggle, opts)

			-- Keymap Ubah Direction Terminal Utama
			map({ "n", "t" }, "<M-1>", tt.horizontal, { desc = "Terminal Horizontal" })
			map({ "n", "t" }, "<M-2>", tt.vertical, { desc = "Terminal Vertical" })
			map({ "n", "t" }, "<M-3>", tt.float, { desc = "Terminal Float" })

			-- Keymap Terminal Sekunder (M-0)
			map(
				{ "n", "t" },
				"<M-0>",
				tt.toggle_secondary,
				{ desc = "Toggle Terminal Sekunder", noremap = true, silent = true }
			)

			-- Keymap internal Terminal Mode (Memudahkan navigasi keluar dari terminal)
			-- function _G.set_terminal_keymaps()
			-- 	local t_opts = { buffer = 0 }
			-- 	vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], t_opts)
			-- 	vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], t_opts)
			-- 	vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], t_opts)
			-- 	vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], t_opts)
			-- 	vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], t_opts)
			-- end

			-- vim.api.nvim_create_autocmd("TermOpen", {
			-- 	pattern = "term://*",
			-- 	callback = function()
			-- 		set_terminal_keymaps()
			-- 	end,
			-- })
		end,
	},
}
