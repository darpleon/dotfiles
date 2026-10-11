-- Buffer-based markdown renderer: prettifies headings, bullets,
-- checkboxes, code blocks and tables directly in the buffer.
-- https://github.com/MeanderingProgrammer/render-markdown.nvim
return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  keys = {
    { 'md', function() require('render-markdown').toggle() end, desc = 'Toggle [M]ark[d]own rendering' },
    -- `md` shadows built-in mark d; `mk` + letter recovers any mark:
    { 'mk', 'm', desc = 'Set [m]ar[k]: prefix + letter' },
  },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {},
}
