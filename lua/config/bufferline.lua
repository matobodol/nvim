local ok, bufferline = pcall(require, "bufferline")
if not ok then
	return
end

bufferline.setup({
	options = {
		mode = "buffers",
		offsets = {
			{
				filetype = "NvimTree",
				text = "NvimTree",
				text_align = "center", --"left", | "center" | "right"
				separator = true,
			},
		},
		numbers = "none",
		indicator = {
			icon = "▎", --'▎', -- this should be omitted if indicator style is not 'icon'
			style = "icon", -- 'icon' | 'underline' | 'none',
		},
		diagnostics = "none", --"nvim_lsp",
		diagnostics_indicator = function(count, level)
			local icon = level:match("error") and " " or " "
			return " " .. icon .. count
		end,
		separator_style = "thin", --"slant" | "slope" | "thick" | "thin" | { 'any', 'any' },
		show_tab_indicators = true,
		show_buffer_close_icons = false,
		show_close_icon = false,
		sort_by = "insert_at_end",
		pick = {
			alphabet = "abcdefghijklmopqrstuvwxyzabcdefghijklmopqrstuvwxyz1234567890",
		},
	},
})

-- Pemetaan tombol untuk bufferline.nvim
local map = vim.keymap.set
-- local opts = { noremap = true, silent = true }

-- Navigasi tab/buffer (Kiri & Kanan)
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Buffer sebelumnya", noremap = true, silent = true })
map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Buffer berikutnya", noremap = true, silent = true })

-- Pindah urutan tab/buffer
map("n", "<A-h>", "<cmd>BufferLineMovePrev<cr>", { desc = "Geser buffer ke kiri", noremap = true, silent = true })
map("n", "<A-l>", "<cmd>BufferLineMoveNext<cr>", { desc = "Geser buffer ke kanan", noremap = true, silent = true })

-- Tutup/close tab/buffer
map("n", "<leader>bc", function()
	local current = vim.api.nvim_get_current_buf()
	vim.cmd("BufferLineCyclePrev")
	vim.cmd("bdelete! " .. current)
end, { desc = "Tutup buffer aktif", noremap = true, silent = true })

map(
	"n",
	"<leader>bp",
	"<cmd>BufferLinePickClose<cr>",
	{ desc = "Pilih buffer untuk ditutup", noremap = true, silent = true }
)
map(
	"n",
	"<leader>bo",
	"<cmd>BufferLineCloseOthers<cr>",
	{ desc = "Tutup buffer lainnya", noremap = true, silent = true }
)
