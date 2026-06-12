return {
  {
    "andrewferrier/debugprint.nvim",
    lazy = false,
    dependencies = {
      "folke/snacks.nvim",
      "nvim-mini/mini.hipatterns",
    },
    opts = {
      display_counter = false,
      display_snippet = false,
      picker = "snacks.picker",
      print_tag = "DEBUGPRINT",
      keymaps = {
        normal = {
          variable_below = false,
          variable_above = false,
          delete_debug_prints = "g?d",
          toggle_comment_debug_prints = "g?c",
        },
      },
    },
    keys = {
      {
        "g?v",
        function()
          local variable = vim.fn.expand("<cword>")
          if variable == "" then
            vim.notify("No variable under cursor", vim.log.levels.WARN, { title = "Debugprint" })
            return
          end

          require("debugprint").debugprint({
            variable = true,
            variable_name = variable,
          })
        end,
        desc = "Variable Debug Below",
      },
      {
        "g?V",
        function()
          local variable = vim.fn.expand("<cword>")
          if variable == "" then
            vim.notify("No variable under cursor", vim.log.levels.WARN, { title = "Debugprint" })
            return
          end

          require("debugprint").debugprint({
            above = true,
            variable = true,
            variable_name = variable,
          })
        end,
        desc = "Variable Debug Above",
      },
      { "g?s", "<cmd>Debugprint search<cr>", desc = "Search Debug Prints" },
    },
  },
}
