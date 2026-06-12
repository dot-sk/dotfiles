return {
  {
    "folke/persistence.nvim",
    init = function()
      local function cleanup_startup_ui()
        vim.schedule(function()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local name = vim.api.nvim_buf_get_name(buf)

            if name ~= "" and vim.bo[buf].buftype == "" and vim.fn.isdirectory(name) == 0 then
              vim.api.nvim_set_current_win(win)
              return
            end
          end

          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buf].filetype == "snacks_dashboard" then
              pcall(vim.api.nvim_buf_delete, buf, { force = true })
            end
          end
        end)
      end

      vim.api.nvim_create_autocmd("UIEnter", {
        group = vim.api.nvim_create_augroup("user_restore_session", { clear = true }),
        once = true,
        callback = function()
          vim.defer_fn(function()
            if #vim.api.nvim_list_uis() == 0 then
              return
            end

            local argc = vim.fn.argc(-1)
            local first_arg = argc == 1 and vim.fn.argv(0) or nil
            local starts_with_dir = first_arg and vim.fn.isdirectory(first_arg) == 1

            if argc > 1 or (argc == 1 and not starts_with_dir) then
              return
            end

            if starts_with_dir then
              require("persistence").load()
            else
              require("persistence").load({ last = true })
            end

            cleanup_startup_ui()
          end, 100)
        end,
      })
    end,
  },
}
