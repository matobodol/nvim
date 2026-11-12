local group = vim.api.nvim_create_augroup("custom_autocmds", { clear = true })

-- Highlight saat menyalin teks (yank)
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight on yank",
	group = group,
	callback = function()
		vim.hl.on_yank({ higroup = "Visual", timeout = 300 })
	end,
})

-- Tombol 'q' untuk keluar dari dokumentasi help & man
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "help", "man" },
	group = group,
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true, desc = "Quit buffer" })
	end,
})

-- Konfigurasi tampilan Terminal Neovim
vim.api.nvim_create_autocmd("TermOpen", {
	group = group,
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.cmd("startinsert")
	end,
})

-- Switch relativenumber otomatis saat masuk/keluar Insert Mode
-- (Hanya berjalan jika opsi 'number' sedang aktif, mencegah bug toggle manual)
vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
	group = group,
	callback = function(ev)
		if vim.o.number then
			vim.opt_local.relativenumber = (ev.event == "InsertLeave")
		end
	end,
})

-- indent 4 spppasi untuk file tertentu
-- defaullt 2 spasi
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"rust",
	},
	callback = function()
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.softtabstop = 4
		vim.opt_local.expandtab = true
	end,
})

--  auto close buffer nonane
vim.api.nvim_create_autocmd("BufReadPost", {
	desc = "Hapus buffer [No Name] otomatis jika file nyata dibuka",
	callback = function()
		local buffers = vim.api.nvim_list_bufs()
		for _, bufnr in ipairs(buffers) do
			-- Cek jika buffer valid, terload, namanya kosong, dan belum dimodifikasi
			if
				vim.api.nvim_buf_is_valid(bufnr)
				and vim.api.nvim_buf_is_loaded(bufnr)
				and vim.api.nvim_buf_get_name(bufnr) == ""
				and not vim.bo[bufnr].modified
				and vim.bo[bufnr].buftype == ""
			then
				vim.cmd("silent! bdelete " .. bufnr)
			end
		end
	end,
})
