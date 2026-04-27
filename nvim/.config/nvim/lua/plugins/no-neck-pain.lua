local function get_repo_name()
	local handle = io.popen("git rev-parse --show-toplevel 2> /dev/null")
	if handle == nil then
		return nil
	end

	local git_root = handle:read("*a"):gsub("%s+$", "")
	handle:close()

	if git_root == "" then
		return nil
	end

	return vim.fn.fnamemodify(git_root, ":t")
end

local function get_or_create_notes(repoName)
	local home = os.getenv("HOME")
	local path = home .. "/Documents/nvim-notes/" .. repoName
	local ok, err = os.execute('mkdir -p "' .. path .. '"')
	if not ok then
		error("Failed to create directory: " .. err)
	end
	return path
end

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
			scratchPad = {
				enabled = true,
				pathToFile = get_or_create_notes(get_repo_name()) .. "/notes.md",
			},
		},
	},
}

-- vim: ts=4 sts=4 sw=4 et
