-- lua/plugins/lspconfig.lua
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    -- Ensure cmp-nvim-lsp is listed as a dependency here
    -- so its capabilities are available when this config runs.
    "hrsh7th/cmp-nvim-lsp",
    -- Add any other LSP-related plugins like linters/formatters (e.g., none-ls or nvim-lint)
    -- or UI enhancers (e.g., lspsaga, lspkind) here if you use them.
  },
  config = function()
    local lspconfig = require("lspconfig")
    -- !! Crucial change: Get capabilities from the cmp-nvim-lsp plugin !!
    -- This now works because cmp-nvim-lsp is listed as a direct dependency above.
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- Your existing on_attach function remains the same
    local on_attach = function(client, bufnr)
      local opts = { buffer = bufnr, noremap = true, silent = true }
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'gT', vim.lsp.buf.type_definition, opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
      vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, opts)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
      print("LSP attached to buffer:", bufnr)
    end

    -- *** Manually setup servers installed via Nix ***

    -- Setup pyright, passing the cmp capabilities
    lspconfig.pyright.setup({
      on_attach = on_attach,
      capabilities = capabilities, -- Pass the capabilities here
    })

    -- Setup lua_ls, passing the cmp capabilities
    lspconfig.lua_ls.setup({
       on_attach = on_attach,
       capabilities = capabilities, -- Pass the capabilities here
       settings = {
         Lua = {
           runtime = { version = 'LuaJIT' },
           diagnostics = { globals = {'vim'} },
           workspace = { library = vim.api.nvim_get_runtime_file("", true) },
           telemetry = { enable = false },
         },
       },
    })

    -- For nim_langserver
    lspconfig.nim_langserver.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      -- Example setting from nim-lang/langserver docs if needed:
      -- settings = {
      --   nim = {
      --     -- Specify path if it's not in PATH or you need a specific build
      --     -- nimsuggestPath = "/path/to/your/nimsuggest",
      --     -- nimlangserverPath = "/path/to/your/nimlangserver"
      --   }
      -- }
    })

    lspconfig.tinymist.setup({
        on_attach = on_attach,
        capabilities = capabilities
    })
    -- Add setup calls here for any other LSP servers installed via Nix
    -- lspconfig.some_other_server.setup({ on_attach = on_attach, capabilities = capabilities })

  end,
}
