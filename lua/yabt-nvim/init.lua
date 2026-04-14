local M = {}

--- @class nvim-yabt.Opts
--- @field public lua_ls? string path to the lua-language-server binary
--- @field public yabt? string path to the yabt binary

--- Configures the yabt LSP integration and filetype.
--- @param opts nvim-yabt.Opts Options for the plugin
M.setup = function(opts)
    require 'yabt-nvim.lsp'.setup(opts.yabt, opts.lua_ls)
end

return M
