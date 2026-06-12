return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.setup = opts.setup or {}
      local eslint_setup = opts.setup.eslint

      opts.setup.eslint = function(server, server_opts)
        if eslint_setup then
          eslint_setup(server, server_opts)
        end

        local base_on_attach = vim.lsp.config.eslint.on_attach

        vim.lsp.config("eslint", {
          on_attach = function(client, bufnr)
            if base_on_attach then
              base_on_attach(client, bufnr)
            end

            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              command = "LspEslintFixAll",
            })
          end,
        })
      end
    end,
  },
}
