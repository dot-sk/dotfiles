-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("i", "<M-Left>", "<C-o>b", { desc = "Previous Word" })
vim.keymap.set("i", "<M-Right>", "<C-o>w", { desc = "Next Word" })
vim.keymap.set("i", "<M-b>", "<C-o>b", { desc = "Previous Word" })
vim.keymap.set("i", "<M-f>", "<C-o>w", { desc = "Next Word" })

-- Ghostty Alt-arrow CSI sequences.
vim.keymap.set("i", "\27[1;3D", "<C-o>b", { desc = "Previous Word" })
vim.keymap.set("i", "\27[1;3C", "<C-o>w", { desc = "Next Word" })

-- Ghostty Cmd-arrow CSI sequences.
vim.keymap.set("i", "\27[1;9D", "<C-o>0", { desc = "Start of Line" })
vim.keymap.set("i", "\27[1;9C", "<C-o>$", { desc = "End of Line" })
vim.keymap.set("i", "\27[1;9A", "<C-o>gg<C-o>0", { desc = "Start of File" })
vim.keymap.set("i", "\27[1;9B", "<C-o>G<C-o>$", { desc = "End of File" })
vim.keymap.set("i", "<D-Left>", "<C-o>0", { desc = "Start of Line" })
vim.keymap.set("i", "<D-Right>", "<C-o>$", { desc = "End of Line" })
vim.keymap.set("i", "<D-Up>", "<C-o>gg<C-o>0", { desc = "Start of File" })
vim.keymap.set("i", "<D-Down>", "<C-o>G<C-o>$", { desc = "End of File" })

vim.keymap.set("n", "\27[1;9D", "0", { desc = "Start of Line" })
vim.keymap.set("n", "\27[1;9C", "$", { desc = "End of Line" })
vim.keymap.set("n", "\27[1;9A", "gg0", { desc = "Start of File" })
vim.keymap.set("n", "\27[1;9B", "G$", { desc = "End of File" })
vim.keymap.set("n", "<D-Left>", "0", { desc = "Start of Line" })
vim.keymap.set("n", "<D-Right>", "$", { desc = "End of Line" })
vim.keymap.set("n", "<D-Up>", "gg0", { desc = "Start of File" })
vim.keymap.set("n", "<D-Down>", "G$", { desc = "End of File" })

-- Ghostty Cmd+/ sequence.
vim.keymap.set("n", "\27[47;9u", "gcc", { remap = true, desc = "Toggle Comment" })
vim.keymap.set("x", "\27[47;9u", "gc", { remap = true, desc = "Toggle Comment" })
vim.keymap.set("n", "<D-/>", "gcc", { remap = true, desc = "Toggle Comment" })
vim.keymap.set("x", "<D-/>", "gc", { remap = true, desc = "Toggle Comment" })

-- Cmd+C should copy visual selection instead of triggering Vim's "change" command.
vim.keymap.set({ "x", "s" }, "<D-c>", '"+y', { desc = "Copy to System Clipboard", silent = true })
vim.keymap.set({ "x", "s" }, "\27[99;9u", '"+y', { desc = "Copy to System Clipboard", silent = true })
vim.keymap.set({ "n", "i", "o", "c", "t" }, "<D-c>", "<Nop>", { silent = true })
vim.keymap.set({ "n", "i", "o", "c", "t" }, "\27[99;9u", "<Nop>", { silent = true })

local function notify_gitbrowse(message, level)
  Snacks.notify(message, { title = "Git Browse", level = level or vim.log.levels.WARN })
end

local function gitbrowse_current_line(opts)
  local file = vim.api.nvim_buf_get_name(0)

  if file == "" or vim.fn.filereadable(file) == 0 then
    notify_gitbrowse("Open a tracked file before browsing it on remote")
    return
  end

  local cwd = vim.fn.fnamemodify(file, ":h")

  vim.fn.systemlist({ "git", "-C", cwd, "ls-files", "--error-unmatch", "--", file })
  if vim.v.shell_error ~= 0 then
    notify_gitbrowse("Current file is not tracked by git")
    return
  end

  local commit = vim.fn.systemlist({ "git", "-C", cwd, "rev-parse", "--verify", "HEAD" })[1]
  if vim.v.shell_error ~= 0 or not commit or commit == "" then
    notify_gitbrowse("Could not resolve current git commit")
    return
  end

  Snacks.gitbrowse(vim.tbl_extend("force", {
    what = "permalink",
    commit = commit,
  }, opts or {}))
end

vim.keymap.set({ "n", "x" }, "<leader>gB", function()
  gitbrowse_current_line()
end, { desc = "Git Browse Current Line" })

vim.keymap.set({ "n", "x" }, "<leader>gY", function()
  gitbrowse_current_line({
    notify = false,
    open = function(url)
      vim.fn.setreg("+", url)
      notify_gitbrowse("Copied remote line URL", vim.log.levels.INFO)
    end,
  })
end, { desc = "Git Browse Copy Current Line" })
