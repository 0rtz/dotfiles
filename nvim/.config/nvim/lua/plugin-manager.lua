-- Plugin management using vim.pack (Neovim builtin)
-- Lockfile: ~/.config/nvim/nvim-pack-lock.json
-- Plugins installed to: ~/.local/share/nvim/site/pack/core/opt/

-- Post-install plugins hooks must be listed before PackChanged autocmd registered
local hooks = {
  ["telescope-fzf-native.nvim"] = function(path)
    vim.notify("Building telescope-fzf-native.nvim in " .. path)
    local result = vim.system({ "make" }, { cwd = path }):wait()
    if result.code ~= 0 then
      vim.notify(
        "Failed to build telescope-fzf-native.nvim:\n" .. (result.stderr or "Unknown error"),
        vim.log.levels.ERROR
      )
    end
  end,

  ["nvim-treesitter"] = function(_)
    pcall(vim.cmd, "packadd nvim-treesitter")
    vim.cmd("TSUpdate")
  end,

  ["LuaSnip"] = function(path)
    vim.system({ "make", "install_jsregexp" }, { cwd = path })
  end,
}

---Add a plugin (GitHub URL prefix is default)
---@param repo string GitHub repo (user/repo) or full URL
---@param opts? table Options passed to vim.pack.add
function MyAddPlugin(repo, opts)
  local url = repo:match("^https?://") and repo or ("https://github.com/" .. repo)
  local ok, err = pcall(vim.pack.add, {url}, opts)
  if not ok then
    vim.notify("Failed to add plugin: " .. repo .. "\n" .. tostring(err), vim.log.levels.ERROR)
    return
  end
end

local group = vim.api.nvim_create_augroup("MyPackHooks", { clear = true })

-- Build hooks executed on plugins install/update
vim.api.nvim_create_autocmd("PackChanged", {
  group = group,
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if kind == "install" or kind == "update" then
      local hook = hooks[name]
      if hook then
        local path = ev.data.path
        vim.schedule(function()
          local ok, err = pcall(hook, path)
          if not ok then
            vim.notify(
              "Build hook failed for " .. name .. ":\n" .. tostring(err),
              vim.log.levels.ERROR
            )
          else
            vim.notify("Build hook completed for " .. name, vim.log.levels.INFO)
          end
        end)
      end
    end
  end,
})