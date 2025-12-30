-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

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
