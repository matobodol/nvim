local current_file = debug.getinfo(1, "S").source:sub(2)
local current_dir = vim.fn.fnamemodify(current_file, ":h")

local addr = "127.0.0.1:3000"
local server_job_id = nil

local function get_buffer_info()
  return {
    full_path = vim.fn.expand("%:p"),
    dir_path = vim.fn.expand("%:p:h"),
    path_out = vim.fn.expand("%:r"),
    file_eks = vim.fn.expand("%:e"),
    base_name = vim.fn.expand("%:t:r"),
  }
end

-- HTTP Request Helper
local function http_get(url, callback)
  vim.fn.jobstart({ "curl", "-s", url }, {
    on_exit = function(_, code)
      if callback and code == 0 then
        callback()
      end
    end,
  })
end

-- Helper untuk menjalankan Server Rust
local function start_html_server(file_path)
  local server_bin = current_dir .. "/server"

  if vim.fn.executable(server_bin) == 0 then
    vim.notify("[Err] Binary server tidak ditemukan di: " .. server_bin, vim.log.levels.ERROR)
    return
  end

  server_job_id = vim.fn.jobstart({ server_bin, file_path, addr }, {
    on_exit = function(_, code)
      server_job_id = nil
      if code ~= 0 and code ~= 143 then
        vim.notify("[Server] Live server terhenti", vim.log.levels.WARN)
      end
    end,
  })

  vim.notify("[Server] Berjalan di http://" .. addr, vim.log.levels.INFO)

  -- Buka browser pertama kali
  vim.defer_fn(function()
    vim.fn.system("xdg-open http://" .. addr)
  end, 300)
end

-- Autocommand: Pemicu Reload / Switch saat Save (:w) pada file HTML
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.html",
  callback = function()
    if not server_job_id then
      return
    end

    local current_path = vim.fn.expand("%:p")
    local encoded_path = string.gsub(current_path, "([^%w%-_%.%~/])", function(c)
      return string.format("%%%02X", string.byte(c))
    end)

    -- Panggil /__switch untuk memastikan server memuat file yang sedang dibuka, lalu reload
    local url = string.format("http://%s/__switch?path=%s", addr, encoded_path)
    http_get(url)
  end,
})

local function config(ext, info)
  local cfg = {
    py = { run = "python3 " .. info.full_path },
    ts = { run = "tsx " .. info.full_path },
    sh = { run = "bash " .. info.full_path },
    lua = { run = "lua " .. info.full_path },
    fish = { run = "fish " .. info.full_path },
    rs = { run = "cd %:p:h && cargo run" },

    cpp = {
      compile = string.format("g++ %s -o %s", info.full_path, info.path_out),
      run = string.format("&& %s", info.path_out),
      delTemp = string.format("&& rm -f %s", info.path_out),
    },

    java = {
      compile = string.format("javac %s -d %s", info.full_path, info.path_out),
      run = string.format("&& cd %s && java %s", info.path_out, info.base_name),
      delTemp = string.format("&& rm -rf %s", info.path_out),
    },

    kt = {
      compile = string.format("kotlinc %s -include-runtime -d %s.jar", info.full_path, info.path_out),
      run = string.format("&& java -jar %s.jar", info.path_out),
      delTemp = string.format("&& rm -f %s.jar", info.path_out .. ".jar"),
    },
  }

  return cfg[ext]
end

local function setup()
  local info = get_buffer_info()

  -- 1. Simpan file aktif
  vim.cmd.w()

  -- 2. Penanganan khusus HTML
  if info.file_eks == "html" then
    if not server_job_id then
      start_html_server(info.full_path)
    else
      -- Jika server sudah menyala, paksa pemicu reload/switch secara langsung
      local encoded_path = string.gsub(info.full_path, "([^%w%-_%.%~/])", function(c)
        return string.format("%%%02X", string.byte(c))
      end)
      http_get(string.format("http://%s/__switch?path=%s", addr, encoded_path))
    end
    return
  end

  -- 3. Penanganan bahasa lain via ToggleTerm
  local conf = config(info.file_eks, info)

  if not conf then
    vim.notify(
      "\n[Err] File type belum di-setup!\nSupport: sh, fish, cpp, rs, java, kt, py, ts, lua, html\n",
      vim.log.levels.ERROR
    )
    return
  end

  local cmd = table.concat(
    vim.tbl_filter(function(v)
      return v
    end, {
      conf.compile,
      conf.run,
      conf.delTemp,
    }),
    " "
  )

  if cmd ~= "" then
    local exec_cmd = string.format('TermExec cmd="%s" count=10 direction=horizontal', cmd:gsub('"', '\\"'))
    vim.cmd(exec_cmd)
  end
end

local function stop_server()
  if server_job_id then
    vim.fn.jobstop(server_job_id)
    server_job_id = nil
    vim.notify("[Server] Live server dihentikan", vim.log.levels.INFO)
  end
end

return {
  buffrunner = setup,
  stop_server = stop_server,
}
