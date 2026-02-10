-- Dependency of 'nvim-lualine/lualine.nvim'
MyAddPlugin("kyazdani42/nvim-web-devicons")
-- Fast and easy to configure statusline
MyAddPlugin("nvim-lualine/lualine.nvim")

local opt = vim.opt

-- Set single statusline for all buffers in a window
-- Unfortunately fucking statusline can not be hidden completely even with laststatus=0
-- https://github.com/neovim/neovim/issues/28488
-- https://github.com/neovim/neovim/issues/5626
opt.laststatus = 3

local function trailing_whitespace()
  return vim.fn.search([[\s\+$]], "nw") ~= 0 and "TW" or ""
end

local function transparent_section(fg_override)
  local base = { bg = "None", gui = "bold" }
  local a = fg_override and vim.tbl_extend("force", base, { fg = fg_override }) or base
  return { a = a, b = base, c = base, x = base, y = base, z = base }
end

local lualine_theme_transparent = {
  normal   = transparent_section(),
  insert   = transparent_section("#00FF11"),
  visual   = transparent_section("#71b7ff"),
  replace  = transparent_section(),
  command  = transparent_section(),
  inactive = transparent_section(),
}

require("lualine").setup({
  options = {
    theme = lualine_theme_transparent,
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = { "GV" },
    globalstatus = true,
  },

  sections = {

    lualine_a = {
      { "filename" }
    },

    lualine_b = {
      { "branch" },
      { "diff", colored = true },
    },

    lualine_c = {
      { "diagnostics", colored = true, sources = { "nvim_diagnostic" } },
      { trailing_whitespace },
      {
        -- Show current keyboard language
        "vim.opt.keymap._value",
        cond = function()
          return vim.opt.keymap._value ~= ""
        end,
        color = { fg = "#000000", bg = "#d50000" },
      },
    },

    lualine_x = {
      { "filetype", colored = true }
    },

    lualine_y = {
      { "'%l:%c'" }
    },

    lualine_z = {
      { "filesize" }, { "'LOC:%L'" }
    },

  },

  extensions = { "nvim-tree", "fugitive" },
})