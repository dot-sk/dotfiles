-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.lazyvim_prettier_needs_config = true

vim.opt.clipboard = "unnamedplus"
vim.opt.showtabline = 0
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.list = true
vim.opt.listchars = {
  space = "·",
  tab = "→ ",
  trail = "·",
  nbsp = "␣",
}

vim.opt.langmap = table.concat({
  "йq",
  "цw",
  "уe",
  "кr",
  "еt",
  "нy",
  "гu",
  "шi",
  "щo",
  "зp",
  "х[",
  "ъ]",
  "фa",
  "ыs",
  "вd",
  "аf",
  "пg",
  "рh",
  "оj",
  "лk",
  "дl",
  "ж\\;",
  "э'",
  "яz",
  "чx",
  "сc",
  "мv",
  "иb",
  "тn",
  "ьm",
  "б\\,",
  "ю.",
  "ЙQ",
  "ЦW",
  "УE",
  "КR",
  "ЕT",
  "НY",
  "ГU",
  "ШI",
  "ЩO",
  "ЗP",
  "Х{",
  "Ъ}",
  "ФA",
  "ЫS",
  "ВD",
  "АF",
  "ПG",
  "РH",
  "ОJ",
  "ЛK",
  "ДL",
  "Ж:",
  "Э\"",
  "ЯZ",
  "ЧX",
  "СC",
  "МV",
  "ИB",
  "ТN",
  "ЬM",
  "Б<",
  "Ю>",
}, ",")
