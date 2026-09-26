local niri = {}

function niri.focusWindow(id: number)
	noctalia.runAsync(`niri msg action focus-window --id {id}`)
end

--[[ 
	Determines the type of the event and casts it to the correct type.
	This returns a modified `state`.

	Note: I wanted to have this update state in-place, but it wasn't working - 
	I think because the WindowsChanged event overwrites the state.windows value, which seems
	to cause the reference to be lost by the caller. Probabaly same for `state.workspaces`.
]]
function niri.processEvent(
	state: NiriState,
	event: NiriEvent
): NiriState
	local e = event :: any

	if e.WorkspacesChanged ~= nil then
		state.workspaces = processWorkspacesChanged(state, e :: WorkspacesChanged)
	elseif e.WindowsChanged ~= nil then
    state.windows = processWindowsChanged(state, e :: WindowsChanged)
  elseif e.WindowOpenedOrChanged ~= nil then
    processWindowOpenedOrChanged(state, e :: WindowOpenedOrChanged)
  elseif e.WindowClosed ~= nil then
    processWindowClosed(state, e :: WindowClosed)
  elseif e.WindowFocusChanged ~= nil then
    processWindowFocusChanged(state, e :: WindowFocusChanged)
  elseif e.WindowUrgencyChanged ~= nil then
    processWindowUrgencyChanged(state, e :: WindowUrgencyChanged)
  elseif e.WindowLayoutsChanged ~= nil then
    processWindowLayoutsChanged(state, e :: WindowLayoutsChanged)
  end

	return state
end

function processWorkspacesChanged(state: NiriState, event: WorkspacesChanged): WorkspaceState
	local workspaces: WorkspaceState = {}

	for _, ws in ipairs(event.WorkspacesChanged.workspaces) do
		if ws.output == state.output then
			workspaces[ws.id] = ws
		end
	end

	return workspaces
end

function processWindowsChanged(state: NiriState, event: WindowsChanged): WindowState
	local windows: WindowState = {}

	if state.workspaces == nil then return windows end 

	for _, win in ipairs(event.WindowsChanged.windows) do
		if isWindowTracked(state.workspaces, win, state.output) then
			windows[win.id] = win
		end
	end

	return windows
end

function processWindowOpenedOrChanged(state: NiriState, event: WindowOpenedOrChanged)
	local window = event.WindowOpenedOrChanged.window

	if state.windows == nil or state.workspaces == nil then return end

	if isWindowTracked(state.workspaces, window, state.output) then
		state.windows[window.id] = window
		if window.is_focused then
			setWindowFocused(state.windows, window.id)
		end
	end
end

function processWindowClosed(state: NiriState, event: WindowClosed)
	if state.windows == nil then return end

	-- No need to check if it's tracked - if it wasn't tracked, it'd already be nil anyways.
	state.windows[event.WindowClosed.id] = nil
end

function processWindowFocusChanged(state: NiriState, event: WindowFocusChanged)
	if state.windows == nil then return end
	
	-- No need to check if tracked here either - if a window we don't track was focused,
	-- then this will set ALL our tracked windows to unfocused - which is intended.
	setWindowFocused(state.windows, event.WindowFocusChanged.id)
end

function processWindowUrgencyChanged(state: NiriState, event: WindowUrgencyChanged)
	if state.windows == nil then return end

	local win = state.windows[event.WindowUrgencyChanged.id]
	if win then win.is_urgent = event.WindowUrgencyChanged.urgent end
end

function processWindowLayoutsChanged(state: NiriState, event: WindowLayoutsChanged)
	if state.windows == nil then return end

	for _, change in pairs(event.WindowLayoutsChanged.changes) do
		local window_id = change[1]
		local layout = change[2]
		local w = state.windows[window_id]
		if w then w.layout = layout end
	end
end

--[[ 
Sets the focus state for a window. All other windows become unfocused. 
This doesn't take NiriState as a param so that the caller is forced to do the nil check on WindowState.
]]
function setWindowFocused(windows: WindowState, id: number?)
	for _, w in pairs(windows) do
		w.is_focused = id == w.id
	end
end

--[[ 
We only care about workspaces that are on the same monitor as the bar widget, which means
we also only care about windows that are on those workspaces.
This function looks at the workspace_id of a window and checks if it's a workspace that we care about.
(We can't just look at the WindowState, because windows could be added/removed to our tracked list.)
This doesn't take NiriState as a param so that the caller is forced to do the nil check on WorkspaceState.
]]
function isWindowTracked(workspaces: WorkspaceState, window: NiriWindow, output: string): boolean
	if window.workspace_id == nil then return false end

	local workspace = workspaces[window.workspace_id]
	return workspace ~= nil
end

return niri
