local ensure_installed = {
  "lua_ls",
  "bashls",
  "fish_lsp",
  "html",
  "cssls",
  "jsonls",
  "vtsls",
  "vue_ls",
  "rust_analyzer",
}

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = ensure_installed,
  automatic_installation = false,
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()
local priority_servers = { "vtsls", "vue_ls" }
local mason_lspconfig = require("mason-lspconfig")

local function contains(tbl, val)
  for _, v in ipairs(tbl) do
    if v == val then
      return true
    end
  end
  return false
end

-- Fungsi setup baru menggunakan API vim.lsp.config bawaan Neovim 0.11+ / 0.12+
local function setup_server(server_name)
  local opts = {
    capabilities = capabilities,
  }

  -- Muat konfigurasi kustom jika ada (misal: config/lsp/language/vue_ls.lua)
  local ok, language_setting = pcall(require, "config.lsp.language." .. server_name)
  if ok and type(language_setting) == "table" then
    opts = vim.tbl_deep_extend("force", opts, language_setting)
  end

  -- Langsung daftarkan server_name asli (vue_ls, vtsls, lua_ls, dll)
  local status_ok, _ = pcall(function()
    vim.lsp.config(server_name, opts)
    vim.lsp.enable(server_name)
  end)

  if not status_ok then
    -- Pcall guard untuk mengabaikan tool non-LSP (seperti formatter/linter)
  end
end

-- Server yang diinstal manual via paket manager OS
local installed_servers = mason_lspconfig.get_installed_servers()

-- 1. Setup server prioritas dari Mason
for _, server_name in ipairs(priority_servers) do
  if contains(installed_servers, server_name) then
    setup_server(server_name)
  end
end

-- 2. Setup sisa server dari Mason
for _, server_name in ipairs(installed_servers) do
  if not contains(priority_servers, server_name) then
    setup_server(server_name)
  end
end

-- 3. Setup server dari sistem OS
-- local system_servers = { "rust_analyzer" }
-- for _, server_name in ipairs(system_servers) do
--   setup_server(server_name)
-- end

-- Autocmd LspAttach untuk nvim-navic
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf
    local filetype = vim.bo[bufnr].filetype

    local status_navic_ok, nvim_navic = pcall(require, "nvim-navic")
    if status_navic_ok and client and client.server_capabilities["documentSymbolProvider"] then
      if filetype == "vue" and client.name == "vtsls" then
        return
      end

      if not vim.b[bufnr].navic_attached then
        nvim_navic.attach(client, bufnr)
        vim.b[bufnr].navic_attached = true
      end
    end
  end,
})
