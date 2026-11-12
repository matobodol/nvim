local Terminal = require("toggleterm.terminal").Terminal

local M = {}

--------------------------------------------------
-- HELPER: Sembunyikan terminal yang sedang aktif
--------------------------------------------------
local function hide_other_terms(current_id)
  -- Jika terminal lain sedang terbuka, tutup dulu instance-nya
  local all_terms = require("toggleterm.terminal").get_all()
  for _, term in ipairs(all_terms) do
    if term.id ~= current_id and term:is_open() then
      term:close()
    end
  end
end

--------------------------------------------------
-- TERMINAL UTAMA (M-i)
--------------------------------------------------
M.direction = "float"

local function set_and_open(dir)
  M.direction = dir
  local term_win = vim.fn.bufwinnr("toggleterm")
  if term_win ~= -1 then
    vim.cmd("ToggleTerm")
  end
  vim.cmd("ToggleTerm direction=" .. M.direction)
end

function M.toggle()
  hide_other_terms(1)
  vim.cmd("ToggleTerm direction=" .. M.direction)
end

function M.horizontal()
  set_and_open("horizontal")
end

function M.vertical()
  set_and_open("vertical")
end

function M.float()
  set_and_open("float")
end

--------------------------------------------------
-- TERMINAL SEKUNDER (M-0)
--------------------------------------------------
local term_secondary = Terminal:new({
  id = 2,
  direction = "float",
  float_opts = {
    border = "curved",
    width = math.floor(vim.o.columns * 0.75),  -- Ukuran sedikit beda agar tidak bentrok
    height = math.floor(vim.o.lines * 0.55),
  },
  hidden = true,
})

function M.toggle_secondary()
  hide_other_terms(2)
  term_secondary:toggle()
end

return M

