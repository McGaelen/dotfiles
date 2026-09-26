export type NiriWorkspace = {
	id: number,
	idx: number,
	name: string?,
	output: string?,
	is_urgent: boolean,
	is_active: boolean,
	is_focused: boolean,
	active_window_id: number?,
}

export type NiriWindow = {
	id: number,
	title: string?,
	app_id: string?,
	pid: number?,
	workspace_id: number?,
	is_focused: boolean,
	is_floating: boolean,
	is_urgent: boolean,
	layout: NiriWindowLayout,
	focus_timestamp: NiriTimestamp?,
}

-- https://yalter.github.io/niri/niri_ipc/struct.WindowLayout.html
export type NiriWindowLayout = {
	-- (column index, tile index within column) coords - these are 1-based
	pos_in_scrolling_layout: {number}?,
	-- Size including borders. These are floats.
	tile_size: {number},
	-- Size NOT including borders. These are integers
	window_size: {number},
	-- Position within the "workspace view" (what you can see in the bounds of your monitor). These are floats.
	tile_pos_in_workspace_view: {number}?,
	-- Position within it's tile. These are floats.
	window_offset_in_tile: {number},
}

export type NiriTimestamp = {
	secs: number,
	nanos: number,
}

export type NiriKeyboardLayouts = {
	names: {string},
	current_idx: number,
}

export type WorkspacesChanged = {
	WorkspacesChanged: {
		workspaces: {NiriWorkspace},
	},
}

export type WorkspaceUrgencyChanged = {
	WorkspaceUrgencyChanged: {
		id: number,
		urgent: boolean,
	},
}

export type WorkspaceActivated = {
	WorkspaceActivated: {
		id: number,
		focused: boolean,
	},
}

export type WorkspaceActiveWindowChanged = {
	WorkspaceActiveWindowChanged: {
		workspace_id: number,
		active_window_id: number?,
	},
}

export type WindowsChanged = {
	WindowsChanged: {
		windows: {NiriWindow},
	},
}

export type WindowOpenedOrChanged = {
	WindowOpenedOrChanged: {
		window: NiriWindow,
	},
}

export type WindowClosed = {
	WindowClosed: {
		id: number,
	},
}

export type WindowFocusChanged = {
	WindowFocusChanged: {
		id: number?,
	},
}

export type WindowFocusTimestampChanged = {
	WindowFocusTimestampChanged: {
		id: number,
		focus_timestamp: NiriTimestamp?,
	},
}

export type WindowUrgencyChanged = {
	WindowUrgencyChanged: {
		id: number,
		urgent: boolean,
	},
}

export type NiriWindowLayoutChange = {number | NiriWindowLayout}

export type WindowLayoutsChanged = {
	WindowLayoutsChanged: {
		changes: {NiriWindowLayoutChange},
	},
}

export type KeyboardLayoutsChanged = {
	KeyboardLayoutsChanged: {
		keyboard_layouts: NiriKeyboardLayouts,
	},
}

export type KeyboardLayoutSwitched = {
	KeyboardLayoutSwitched: {
		idx: number,
	},
}

export type OverviewOpenedOrClosed = {
	OverviewOpenedOrClosed: {
		is_open: boolean,
	},
}

export type ConfigLoaded = {
	ConfigLoaded: {
		failed: boolean,
	},
}

export type ScreenshotCaptured = {
	ScreenshotCaptured: {
		path: string?,
	},
}

export type CastsChanged = {
	CastsChanged: {},
}

export type CastStartedOrChanged = {
	CastStartedOrChanged: {},
}

export type CastStopped = {
	CastStopped: {
		stream_id: number,
	},
}

export type NiriEvent =
	WorkspacesChanged
	| WorkspaceUrgencyChanged
	| WorkspaceActivated
	| WorkspaceActiveWindowChanged
	| WindowsChanged
	| WindowOpenedOrChanged
	| WindowClosed
	| WindowFocusChanged
	| WindowFocusTimestampChanged
	| WindowUrgencyChanged
	| WindowLayoutsChanged
	| KeyboardLayoutsChanged
	| KeyboardLayoutSwitched
	| OverviewOpenedOrClosed
	| ConfigLoaded
	| ScreenshotCaptured
	| CastsChanged
	| CastStartedOrChanged
	| CastStopped

export type WorkspaceState = {
	[number]: NiriWorkspace?
}

export type WindowState = {
  [number]: NiriWindow?
}

export type NiriState = {
	workspaces: WorkspaceState?,
	windows: WindowState?,
	output: string
}

export type WindowDisplay = {{NiriWindow}}
