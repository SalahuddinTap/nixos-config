-- Bridge between pi coding agent and Neovim (pi-ide-context).
-- After this loads, run `/ide` inside a pi session to pair it with this nvim;
-- pi then knows the current file/cursor/selection on every prompt.
return {
	{ "Andy8647/pi-ide-context", lazy = false },
}
