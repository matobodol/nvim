local ok, telescope = pcall(require, "telescope")
if not ok then
	return
end

telescope.setup({
	defaults = {
		path_display = { "smart" },
		file_ignore_patterns = { "node_modules", ".git/", "target/" },
		layout_strategy = "vertical", --"horizontal",
		layout_config = {
			width = 0.90,
			height = 0.75,
			prompt_position = "bottom",
			horizontal = {
				mirror = false,
				preview_width = 60,
			},
			vertical = {
				mirror = false,
				preview_width = 0.70,
			},
		},
	},
})

-- Perbaikan Typo: load_extension (pakai 's')
pcall(telescope.load_extension, "fzf")
