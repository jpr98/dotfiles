return {
	"shortcuts/no-neck-pain.nvim",
	version = "*",
	opts = {
		buffers = {
			right = {
				enabled = false,
			},
			wo = {
				fillchars = "eob: ",
			},
			colors = { blend = 1 }, -- not working for me :/
		},
	},
}

-- vim: ts=4 sts=4 sw=4 et
