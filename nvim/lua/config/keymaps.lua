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

local russian_key_aliases = {
  q = "й",
  w = "ц",
  e = "у",
  r = "к",
  t = "е",
  y = "н",
  u = "г",
  i = "ш",
  o = "щ",
  p = "з",
  ["["] = "х",
  ["]"] = "ъ",
  a = "ф",
  s = "ы",
  d = "в",
  f = "а",
  g = "п",
  h = "р",
  j = "о",
  k = "л",
  l = "д",
  [";"] = "ж",
  ["'"] = "э",
  z = "я",
  x = "ч",
  c = "с",
  v = "м",
  b = "и",
  n = "т",
  m = "ь",
  [","] = "б",
  ["."] = "ю",
  Q = "Й",
  W = "Ц",
  E = "У",
  R = "К",
  T = "Е",
  Y = "Н",
  U = "Г",
  I = "Ш",
  O = "Щ",
  P = "З",
  ["{"] = "Х",
  ["}"] = "Ъ",
  A = "Ф",
  S = "Ы",
  D = "В",
  F = "А",
  G = "П",
  H = "Р",
  J = "О",
  K = "Л",
  L = "Д",
  [":"] = "Ж",
  ['"'] = "Э",
  Z = "Я",
  X = "Ч",
  C = "С",
  V = "М",
  B = "И",
  N = "Т",
  M = "Ь",
  ["<"] = "Б",
  [">"] = "Ю",
}

local function translate_lhs_to_russian(lhs)
  local translated = {}
  local changed = false
  local index = 1

  while index <= #lhs do
    local char = lhs:sub(index, index)

    if char == "<" then
      local closing = lhs:find(">", index, true)
      if closing then
        table.insert(translated, lhs:sub(index, closing))
        index = closing + 1
      else
        table.insert(translated, char)
        index = index + 1
      end
    else
      local code = vim.fn.char2nr(lhs:sub(index), true)
      char = vim.fn.nr2char(code)
      local alias = russian_key_aliases[char]

      table.insert(translated, alias or char)
      changed = changed or alias ~= nil
      index = index + #char
    end
  end

  return changed and table.concat(translated) or nil
end

local function is_leader_lhs(lhs)
  return lhs:match("^ ") or lhs:match("^<Space>")
end

local function copy_leader_map_with_russian_lhs(mode, map, bufnr)
  local lhs = map.lhsraw or map.lhs

  if not is_leader_lhs(lhs) then
    return
  end

  local alias = translate_lhs_to_russian(lhs)
  if not alias then
    return
  end

  local opts = {
    buffer = bufnr,
    desc = map.desc,
    expr = map.expr == 1,
    nowait = map.nowait == 1,
    remap = map.noremap == 0,
    replace_keycodes = map.replace_keycodes == 1,
    script = map.script == 1,
    silent = map.silent == 1,
  }

  vim.api.nvim_buf_call(bufnr or 0, function()
    if vim.fn.maparg(alias, mode) ~= "" then
      return
    end

    vim.keymap.set(mode, alias, map.callback or map.rhs, opts)
  end)
end

local function copy_leader_maps_with_russian_lhs(bufnr)
  for _, mode in ipairs({ "n", "x", "o" }) do
    local maps = bufnr and vim.api.nvim_buf_get_keymap(bufnr, mode) or vim.api.nvim_get_keymap(mode)

    for _, map in ipairs(maps) do
      copy_leader_map_with_russian_lhs(mode, map, bufnr)
    end
  end
end

local function schedule_copy_leader_maps_with_russian_lhs(bufnr)
  vim.schedule(function()
    if not bufnr or vim.api.nvim_buf_is_valid(bufnr) then
      copy_leader_maps_with_russian_lhs(bufnr)
    end
  end)
end

schedule_copy_leader_maps_with_russian_lhs()

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("user_russian_global_leader_aliases", { clear = true }),
  pattern = "VeryLazy",
  callback = function()
    schedule_copy_leader_maps_with_russian_lhs()
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "LspAttach" }, {
  group = vim.api.nvim_create_augroup("user_russian_leader_aliases", { clear = true }),
  callback = function(event)
    schedule_copy_leader_maps_with_russian_lhs(event.buf)
  end,
})
