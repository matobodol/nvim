-- 1. Ambil path instalasi vue-language-server dari Mason registry secara dinamis
local mason_registry = require('mason-registry')
local vue_server = mason_registry.get_package('vue-language-server')
local vue_language_server_path = vue_server:get_install_path() .. '/node_modules/@vue/language-server'

-- 2. Definisikan plugin Vue untuk TypeScript (vtsls)
local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_language_server_path,
  languages = { 'vue' },
  configNamespace = 'typescript',
}

-- 3. Konfigurasi vtsls (Pengganti ts_ls untuk Vue + TS)
return {
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          vue_plugin,
        },
      },
    },
    typescript = {
      inlayHints = {
        parameterNames = {
          enabled = "all", -- "none" | "literals" | "all"
          suppressWhenArgumentMatchesName = true,
        },
        parameterTypes = {
          enabled = true,
        },
        variableTypes = {
          enabled = true,
        },
        propertyDeclarationTypes = {
          enabled = true,
        },
        functionLikeReturnTypes = {
          enabled = true,
        },
        enumMemberValues = {
          enabled = true,
        },
      },
    },
    -- Terapkan juga untuk javascript jika diperlukan
    javascript = {
      inlayHints = {
        parameterNames = {
          enabled = "all",
          suppressWhenArgumentMatchesName = true,
        },
        parameterTypes = {
          enabled = true,
        },
        variableTypes = {
          enabled = true,
        },
        propertyDeclarationTypes = {
          enabled = true,
        },
        functionLikeReturnTypes = {
          enabled = true,
        },
        enumMemberValues = {
          enabled = true,
        },
      },
    },
  },
  filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
}
