-- lua/plugins/cmp.lua
return {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" }, -- Load when entering insert mode or command line
  dependencies = {
    "hrsh7th/cmp-nvim-lsp", -- Source for LSP completions
    "hrsh7th/cmp-buffer",   -- Source for buffer word completions
    "hrsh7th/cmp-path",     -- Source for filesystem path completions
    -- NOTE: If you want snippet completion, add LuaSnip and cmp_luasnip here:
    -- "L3MON4D3/LuaSnip",
    -- "saadparwaiz1/cmp_luasnip",
  },
  config = function()
    local cmp = require("cmp")
    -- local luasnip = require("luasnip") -- Uncomment if using snippets

    -- NOTE: cmp-nvim-lsp capabilities are typically defined and used in lspconfig.lua now
    -- See the modified lspconfig.lua below.

    cmp.setup({
      -- Uncomment and configure if using snippets
      -- snippet = {
      --   expand = function(args)
      --     luasnip.lsp_expand(args.body)
      --   end,
      -- },

      -- Basic key mappings (feel free to customize)
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4), -- Scroll documentation back
        ['<C-f>'] = cmp.mapping.scroll_docs(4),  -- Scroll documentation forward
        ['<C-Space>'] = cmp.mapping.complete(), -- Trigger completion
        ['<C-e>'] = cmp.mapping.abort(),      -- Close completion window
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Confirm selection (set select=false if you prefer explicit selection)
        -- Add mappings for snippet navigation if using luasnip
        -- ["<Tab>"] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_next_item()
        --   elseif luasnip.expand_or_jumpable() then
        --     luasnip.expand_or_jump()
        --   else
        --     fallback()
        --   end
        -- end, { "i", "s" }), -- i for insert mode, s for select mode
        -- ["<S-Tab>"] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_prev_item()
        --   elseif luasnip.jumpable(-1) then
        --     luasnip.jump(-1)
        --   else
        --     fallback()
        --   end
        -- end, { "i", "s" }),
      }),

      -- Define completion sources
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
        -- { name = 'luasnip' }, -- Uncomment if using snippets
      }),

      -- Optional: Add borders or customize appearance
      -- window = {
      --   completion = cmp.config.window.bordered(),
      --   documentation = cmp.config.window.bordered(),
      -- },
    })

     -- If you set up cmdline completion (optional):
     cmp.setup.cmdline('/', {
       mapping = cmp.mapping.preset.cmdline(),
       sources = {
         { name = 'buffer' }
       }
     })
     cmp.setup.cmdline(':', {
       mapping = cmp.mapping.preset.cmdline(),
       sources = cmp.config.sources({
         { name = 'path' }
       }, {
         { name = 'cmdline' }
       })
     })

  end,
}
