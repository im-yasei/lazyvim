-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.api.nvim_create_autocmd("FileType", {
  -- This handler will fire when the buffer's 'filetype' is "python"
  pattern = { "verilog", "systemverilog" },
  callback = function()
    vim.lsp.start({
      name = "verible",
      cmd = { "verible-verilog-ls", "--rules_config_search" },
    })
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.v",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Setting the filetype for Verilog
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*.v" },
  command = "set filetype=verilog",
})

-- Setting the filetype for SystemVerilog
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*.sv" },
  command = "set filetype=systemverilog",
})
