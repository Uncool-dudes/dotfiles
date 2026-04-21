-- lua/plugins/disabled.lua
return {
  {
    "bufferline.nvim",
    enabled = true,
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
