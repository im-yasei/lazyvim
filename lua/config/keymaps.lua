-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- jj works like Esc
vim.api.nvim_set_keymap("i", "ii", "<Esc>", { noremap = false })

-- Disabling arrows
local modes = { "n", "i", "v" }
for _, mode in ipairs(modes) do
  vim.keymap.set(mode, "<Up>", "<Nop>", { noremap = true, silent = true })
  vim.keymap.set(mode, "<Down>", "<Nop>", { noremap = true, silent = true })
  vim.keymap.set(mode, "<Left>", "<Nop>", { noremap = true, silent = true })
  vim.keymap.set(mode, "<Right>", "<Nop>", { noremap = true, silent = true })
end

-- Array of file names indicating root directory. Modify to your liking.
local root_names = {
  ".git",
  ".gitignore",
}

local root_cache = {}

local set_root = function()
  -- Get directory path to start search from
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    return
  end
  path = vim.fs.dirname(path)

  -- Try cache and resort to searching upward for root directory
  local root = root_cache[path]
  if root == nil then
    local root_file = vim.fs.find(root_names, { path = path, upward = true })[1]
    if root_file == nil then
      return
    end
    root = vim.fs.dirname(root_file)
    root_cache[path] = root
  end

  -- Set current directory
  vim.fn.chdir(root)
  return root
end

-- Функция для открытия toggleterm в корне проекта
local open_terminal_in_root = function()
  local root = set_root()
  if root then
    -- Проверяем, установлен ли toggleterm
    local status_ok, toggleterm = pcall(require, "toggleterm")
    if status_ok then
      toggleterm.toggle()
    else
      -- Альтернатива если toggleterm не установлен
      vim.cmd("terminal")
    end
  else
    require("toggleterm").toggle()
  end
end

-- Автоматическое определение корня при смене буфера
local root_augroup = vim.api.nvim_create_augroup("MyAutoRoot", {})
vim.api.nvim_create_autocmd("BufEnter", {
  group = root_augroup,
  callback = set_root,
})

-- Hotkeys terminal root dir
vim.keymap.set("n", "<leader>fT", open_terminal_in_root, {
  desc = "Terminal (root dir)",
})

-- Hotkeys terminal cwd
vim.api.nvim_create_user_command("TerminalFileDir", ":ToggleTerm dir=%:p:h<CR>", {})
vim.keymap.set("n", "<leader>ft", ":TerminalFileDir<CR>", { desc = "Terminal (cwd)" })

-- Enter normal mode from terminal mode
vim.api.nvim_set_keymap("t", "ii", "<C-\\><C-n>", { noremap = false, silent = true })

-- Block other commands for terminal
vim.api.nvim_set_keymap("n", "<C-/>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<C-/>", "<Nop>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<C-\\>", "<Nop>", { noremap = true, silent = true })

-- snacks explorer cwd
local function open_snacks_explorer()
  local current_dir = vim.fn.expand("%:p:h")
  require("snacks.explorer").open({
    cwd = current_dir,
  })
end

vim.keymap.set("n", "<leader>E", open_snacks_explorer, { desc = "Explorer Snacks (cwd)" })
vim.keymap.set("n", "<leader>fE", open_snacks_explorer, { desc = "Explorer Snacks (cwd)" })

--disable useless keymap
vim.keymap.del("n", "<leader>gG")
vim.keymap.del("n", "<leader>gL")
