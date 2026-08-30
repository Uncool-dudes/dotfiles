-- lua/plugins/disabled.lua
return {
  {
    "bufferline.nvim",
    enabled = false,
  },
  {
    "snacks.nvim",
    opts = {
      scroll = { enabled = false },
      animate = { enabled = false },
      zen = { enabled = false },
      scratch = { enabled = false },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "" },
        change = { text = "" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "" },
      },
      sign_column = false,
      linehl = true,
      numhl = false,
    },
  },
  {
    "folke/noice.nvim",
    opts = {
      cmdline = { enabled = false },
      messages = { enabled = false },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.inlay_hints = { enabled = false }
      opts.diagnostics = vim.tbl_deep_extend("force", opts.diagnostics or {}, {
        virtual_text = false,
      })
      return opts
    end,
  },
}
