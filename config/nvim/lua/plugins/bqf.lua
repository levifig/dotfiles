return {
  "kevinhwang91/nvim-bqf",
  config = function()
    require("bqf").setup({
      auto_enable = true,
      auto_resize_height = true,
      preview = {
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 80,
        border_chars = {'┃', '┃', '━', '━', '┏', '┓', '┗', '┛', '█'},
        should_preview_cb = function(bufnr, qwinid)
          local ret = true
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          local fsize = vim.fn.getfperm(bufname):match('^..-') and vim.fn.getfsize(bufname) or 0
          if fsize > 100 * 1024 then
            ret = false
          end
          return ret
        end
      },
      func_map = {
        vsplit = '',
        ptogglemode = 'z,',
        stoggleup = ''
      },
      filter = {
        fzf = {
          action_for = {['ctrl-s'] = 'split'},
          extra_opts = {'--bind', 'ctrl-o:toggle-all', '--prompt', '> '}
        }
      }
    })
  end,
}