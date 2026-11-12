return {
  cmd = { "rust-analyzer" },
  settings = {
    ["rust-analyzer"] = {
      inlayHints = {
        chainingHints = { enable = true },
        parameterHints = { enable = true },
        typeHints = { enable = true },
      },
      -- Opsi baru: checkOnSave berbentuk boolean
      checkOnSave = true,
      check = {
        command = "clippy",
      },
      procMacro = {
        enable = true,
      },
    },
  },
}
