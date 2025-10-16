return {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
        require("toggleterm").setup({
            -- Настройки по желанию
            --size = 20,
            
            direction = 'float',

            --direction = 'horizontal',
            --open_mapping = [[<c-t>]], -- Ctrl+/
        })
    end
}
