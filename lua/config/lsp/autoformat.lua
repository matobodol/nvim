-- autoformat.lua (di config/lsp/autoformat.lua)
local M = {}

-- Status awal autoformat
vim.g.disable_autoformat = false

--- Memutar status autoformat global (Enable/Disable)
function M.toggle_format_on_save()
	vim.g.disable_autoformat = not vim.g.disable_autoformat
	if vim.g.disable_autoformat then
		vim.notify("Autoformat on save: NONAKTIF", vim.log.levels.WARN)
	else
		vim.notify("Autoformat on save: AKTIF", vim.log.levels.INFO)
	end
end

-- Pendaftaran keymap toggle
vim.keymap.set("n", "<leader>tf", M.toggle_format_on_save, {
	desc = "Toggle Autoformat on Save",
})

return M
