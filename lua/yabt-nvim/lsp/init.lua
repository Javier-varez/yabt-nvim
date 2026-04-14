local M = {}

--- Configures the yabt LSP integration and filetype.
--- @param yabt string? path to the yabt binary
--- @param lua_ls string? path to the lua-language-server binary
M.setup = function(yabt, lua_ls)
    yabt = yabt or 'yabt'
    lua_ls = lua_ls or 'lua-language-server'

    -- Register a new filetype named `yabt` for all yabt-related `.lua` files.
    -- By using a custom filetype we can better control what LSP will be
    -- triggered for these files, and override the LSP for the yabt files,
    -- while leaving the original lua-ls LSP behavior for all regular lua
    -- files.
    vim.filetype.add({
        pattern = {
            -- Lua files in a rules directory
            ['.*/rules/.*%.lua'] = 'yabt',
            -- BUILD.lua files in any directory
            ['.*/BUILD.lua'] = 'yabt',
        },
    })

    -- Create a new lsp configuration for the yabt files, which uses the custom language server
    vim.lsp.config('yabtlsp', {
        root_markers = { 'MODULE.lua' },
        cmd = { yabt, 'lsp', '--lsp-binary=' .. lua_ls },
        filetypes = { 'yabt' },
    })

    vim.lsp.enable('yabtlsp')

    -- Start treesitter with lsp syntax highlighting and configure and adequate comment string for
    -- each yabt file
    vim.api.nvim_create_autocmd('FileType', {
        pattern = 'yabt',
        callback = function(args)
            vim.treesitter.start(args.buf, 'lua')
            vim.bo.commentstring = '-- %s'
        end
    })
end

return M
