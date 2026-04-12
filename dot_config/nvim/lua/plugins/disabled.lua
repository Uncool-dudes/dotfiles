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
}
