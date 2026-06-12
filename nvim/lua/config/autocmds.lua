-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local autosave_group = vim.api.nvim_create_augroup("user_autosave", { clear = true })

local function autosave()
  if
    vim.bo.modified
    and vim.bo.modifiable
    and not vim.bo.readonly
    and vim.bo.buftype == ""
    and vim.api.nvim_buf_get_name(0) ~= ""
  then
    LazyVim.format({ buf = vim.api.nvim_get_current_buf() })

    if vim.fn.exists(":LspEslintFixAll") == 2 then
      vim.cmd("silent! LspEslintFixAll")
    end

    vim.cmd("silent! noautocmd update")
  end
end

vim.api.nvim_create_autocmd({ "FocusLost", "InsertLeave" }, {
  group = autosave_group,
  callback = autosave,
})
