-- Toggle manual untuk nomor baris (Spasi + t + n)
local function toggle_number()
	if vim.o.number or vim.o.relativenumber then
		vim.o.number = false
		vim.o.relativenumber = false
		print("Line numbers: NONAKTIF")
	else
		vim.o.number = true
		vim.o.relativenumber = true
		print("Line numbers: AKTIF")
	end
end

vim.keymap.set("n", "<leader>tn", toggle_number, { desc = "Toggle line numbers" })
