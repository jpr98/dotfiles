---@diagnostic disable: need-check-nil
local M = {}

-- List of patterns to exclude
local excluded_patterns = {
	".*%.png",
	-- Add more patterns as needed
}

-- Function to execute a git command and return output
local function git_status()
	local handle = io.popen("git diff --name-only")
	if not handle then
		print("ERROR: handle was nil")
		return
	end
	local result = handle:read("*a")
	handle:close()
	return result
end

-- Function to check if filename matches exclude patterns
local function is_excluded(file)
	for _, pattern in ipairs(excluded_patterns) do
		if file:match(pattern) then
			return true
		end
	end
	return false
end

-- Main function to filter files and open Diffview
function M.open_filtered_diffview()
	local files_info = git_status()
	if not files_info then
		print("ERROR: files_info was nil")
		return
	end
	local files_to_include = {}

	for line in files_info:gmatch("[^\r\n]+") do
		if not is_excluded(line) then
			table.insert(files_to_include, line)
		end
	end

	-- Open Diffview with filtered files
	if #files_to_include > 0 then
		vim.cmd("DiffviewOpen -- " .. table.concat(files_to_include, " "))
	else
		print("No changes in relevant files.")
	end
end

-- Function to determine which branch (main or master) is available
local function get_git_branch()
	local handle = io.popen("git branch --list main")
	local result = handle:read("*a")
	handle:close()

	if result:match("main") then
		return "main"
	else
		handle = io.popen("git branch --list master")
		result = handle:read("*a")
		handle:close()

		if result:match("master") then
			return "master"
		else
			return nil
		end
	end
end
-- Function to open diff on main/master depending availability
function M.open_main_master_diffview()
	local branch = get_git_branch()
	if branch then
		vim.cmd("DiffviewOpen " .. branch)
	else
		print("Neither 'main' nor 'master' branch found.")
	end
end

return M

-- vim: ts=4 sts=4 sw=4 et
