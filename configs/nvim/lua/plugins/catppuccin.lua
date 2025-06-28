-- lua/plugins/catppuccin.lua
return {
  "catppuccin/nvim",
  name = "catppuccin",
  event = "BufReadPost", -- Load catpuccin after a buffer is opened
  config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        background = { -- :h background
          light = "latte",
          dark = "mocha",
        },
        transparent_background = false, -- disables setting the background color.
        show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
        term_colors = true, -- sets terminal colors.
        dim_inactive = {
          enabled = false, -- dims the background color of inactive window.
          shade = "dark",
          percentage = 0.15,
        },
        no_italic = false, -- Force no italic
        no_bold = false, -- Force no bold
        no_underline = false, -- Force no underline
        styles = { -- Handles the styles of general hi groups (see `:h highlight-args`)
          telescope = "italic",
          sidebars = "italic",
          comments = { "italic" },
          keywords = { "italic" },
          functions = { "italic" },
          variables = { "italic" },
          conditionals = { "italic" },
          loops = {},
          operators = {},
          strings = {},
          numbers = {},
          booleans = {},
          types = {},
          builtins = {},
          symbols = {},
          virt_text = {},
          errors = { "italic" },
          warnings = { "italic" },
          info = { "italic" },
          hints = { "italic" },
        },
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          telescope = true,
          notify = false,
          treesitter = true,
          lsp_trouble = false,
          mini = false,
          native_lsp = {
            enabled = true,
            underlines = {
              errors = { "underline" },
              warnings = { "underline" },
              hints = { "underline" },
              information = { "underline" },
            },
          },
          dap = {
            enabled = true,
          },
        },
  })
  end
  -- setup must be called before loading the colorscheme
}