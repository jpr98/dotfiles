local M = {}

-- Function to display Diffview status
function M.diffview_status()
	-- Safely require 'diffview.lib' to avoid errors if it's not available
	local ok, diffview_lib = pcall(require, "diffview.lib")
	if not ok or not diffview_lib then
		return ""
	end

	local view = diffview_lib.get_current_view()
	if view then
		-- Customize the displayed text as needed
		local cok, conflict = pcall(require, "git-conflict")
		if not cok or not conflict then
			return ""
		end
		local conflict_count = conflict.conflict_count()
		if conflict_count > 0 then
			return "" .. conflict.conflict_count()
		end
	end

	return ""
end

-- Condition to check if Diffview is active
function M.is_diffview_active()
	-- Ensure Diffview is loaded
	if not package.loaded["diffview"] then
		return false
	end

	local ok, diffview_lib = pcall(require, "diffview.lib")
	if not ok or not diffview_lib then
		return false
	end

	-- Check if there's an active Diffview view
	return diffview_lib.get_current_view() ~= nil
end

return M

-- vim: ts=4 sts=4 sw=4 et
