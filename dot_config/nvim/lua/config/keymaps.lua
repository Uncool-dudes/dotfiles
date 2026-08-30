-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.del("n", "<leader>bb")
vim.keymap.del("n", "[b")
vim.keymap.del("n", "]b")
vim.keymap.del("n", "<leader>wm")
vim.keymap.del("n", "]d")
vim.keymap.del("n", "[d")
vim.keymap.del("n", "]D")
vim.keymap.del("n", "[D")

vim.keymap.set("n", ";", function() vim.diagnostic.goto_next() end, { desc = "Next diagnostic" })
vim.keymap.set("n", ",", function() vim.diagnostic.goto_prev() end, { desc = "Prev diagnostic" })

vim.keymap.del("n", "<leader>K")
vim.keymap.del("n", "<leader>L")
vim.keymap.del("n", "<leader>uI")
vim.keymap.del("n", "<leader>ui")
vim.keymap.del("n", "<leader>dpp")
vim.keymap.del("n", "<leader>dph")
vim.keymap.del("n", "<leader>dps")
vim.keymap.del("n", "<leader>uS")
vim.keymap.del("n", "<leader>ua")
vim.keymap.del("n", "<leader>uD")
vim.keymap.del("n", "<leader>ub")
vim.keymap.del("n", "<leader>up")
vim.keymap.del("n", "<leader>uZ")
vim.keymap.del("n", "]e")
vim.keymap.del("n", "[e")
vim.keymap.del("n", "]w")
vim.keymap.del("n", "[w")

vim.keymap.del("n", "<leader>qs")
vim.keymap.del("n", "<leader>qd")
vim.keymap.del("n", "<leader>ql")
vim.keymap.del("n", "<leader>qS")

vim.keymap.set("n", "zz", function()
  if vim.o.foldlevel == 0 then
    vim.cmd("normal! zR")
  else
    vim.cmd("normal! zM")
  end
end, { desc = "Toggle all folds" })

vim.keymap.set("n", "<leader>fp", function()
  local path = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":.")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy relative path" })

vim.keymap.set("n", "<leader>fP", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy absolute path" })
