if vim.loader then
	vim.loader.enable()
end

_G.dd = function(...)
	require("util.debug").dump(...)
end
vim.print = _G.dd

require("config.lazy")
return {
	-- Other plugins...
	{
		"folke/persistence.nvim",
		event = "BufReadPre", -- this loads it early
		opts = {},
		config = function(_, opts)
			require("persistence").setup(opts)
			-- Automatically restore the session for the current directory on startup
			vim.api.nvim_create_autocmd("VimEnter", {
				nested = true,
				callback = function()
					-- Only restore if no files were passed via CLI and we aren't in a git commit
					if vim.fn.argc() == 0 and not vim.g.started_with_stdin then
						require("persistence").load()
					end
				end,
			})
		end,
	},
}
