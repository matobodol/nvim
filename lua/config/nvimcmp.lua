-- Plugin untuk autocompletion

local ok, cmp = pcall(require, "cmp")
if not ok then
	return
end

local icons = require("var.icons")


-- Tambahkan ini sebelum atau sesudah cmp.setup
vim.api.nvim_set_hl(0, "CmpNormal", { bg = "NONE" })      -- Background jendela
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#56B6C2" }) -- Warna border (contoh: Cyan)
vim.api.nvim_set_hl(0, "CmpDocNormal", { bg = "NONE" })


local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body) -- Untuk `LuaSnip` users.
		end,
	},
	window = {
		completion = cmp.config.window.bordered({
			border = "rounded"
		}),
		documentation = cmp.config.window.bordered({

			border = "rounded"
		}),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),

		-- Konfirmasi item yang dipilih
		["<CR>"] = cmp.mapping.confirm({ select = true }),

		-- Navigasi item autocomplete (Atas/Bawah)
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-p>"] = cmp.mapping.select_prev_item(),

		-- Navigasi menggunakan <Tab> dan <S-Tab> (support LuaSnip)
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),

	sources = cmp.config.sources({
		{ name = "nvim_lsp" }, -- Sumber LSP
		{ name = "luasnip" },
		{ name = "path" }, -- Penyelesaian path
		{ name = "buffer" }, -- Penyelesaian buffer
		-- { name = "cmdline" }, -- Penyelesaian command
	}),

	-- Ikon berdasarkan source
	formatting = {
		fields = { "menu", "abbr", "kind" },
		format = function(entry, vim_item)
			local menu_icon = icons.menu_icon

			-- size menu char
			local ELLIPSIS_CHAR = '~'
			local MAX_LABEL_WIDTH = 16
			local MIN_LABEL_WIDTH = 5

			local label = vim_item.abbr
			local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
			if truncated_label ~= label then
				vim_item.abbr = truncated_label .. ELLIPSIS_CHAR
			elseif string.len(label) < MIN_LABEL_WIDTH then
				local padding = string.rep(' ', MIN_LABEL_WIDTH - string.len(label))
				vim_item.abbr = label .. padding
			end

			vim_item.menu = menu_icon[entry.source.name]
			return vim_item
		end,
	},
})

-- Pengaturan khusus untuk cmdline
-- cmp.setup.cmdline(":", {
-- 	mapping = cmp.mapping.preset.cmdline(),
-- 	sources = cmp.config.sources({
-- 		{ name = "path" },
-- 	}, {
-- 		{ name = "cmdline" },
-- 	}),
-- })

-- Pengaturan untuk pencarian (/ atau ?)
-- cmp.setup.cmdline({ "/", "?" }, {
-- 	mapping = cmp.mapping.preset.cmdline(),
-- 	sources = {
-- 		{ name = "buffer" },
-- 	},
-- })
