--!nonstrict

local niri = require('./niri.luau')

function render(windowState: WindowState)
  local container = barWidget.isVertical() and ui.column or ui.row

  local inactiveBackground = noctalia.getConfig('inactive_background') :: string
  local focusedBackground = noctalia.getConfig('focused_background') :: string
  local inactiveText = noctalia.getConfig('inactive_text') :: string
  local focusedText = noctalia.getConfig('focused_text') :: string
  local maxWidth = noctalia.getConfig('max_width') :: number

  local columns: {UiNode} = {}

  for _, window in pairs(windowState) do
    local position = window.layout.pos_in_scrolling_layout
    -- Ignore floating windows, or if Niri didn't send a position.
    if not window.is_floating and position ~= nil then
      local colIdx = position[1]
      local tileIdx = position[2]

      -- Initialize the container for this column if it isn't already.
      -- Values in pos_in_scrolling_layout are 1 based and contiguous,
      -- so we can use that value as an index directly into a table.
      if columns[colIdx] == nil then
        columns[colIdx] = container({
          flexGrow = window.layout.tile_size[1],
          maxWidth = window.layout.tile_size[1],
          borderWidth = 1,
          radius = 20,
          fill = inactiveBackground
        })
      end

      -- Get the app icon
      local appIcon = noctalia.appIconPath(window.app_id, 25)

      -- Add the window as a child of the column
      columns[colIdx].children[tileIdx] = container(
        {
          paddingH = 12,
          minWidth = 50,
          flexGrow = window.layout.tile_size[2],
          align = 'center',
          gap = 5,
          radius = 20,
          fill = window.is_focused and focusedBackground or inactiveBackground,
          onClick = function() niri.focusWindow(window.id) end,
        }, {
          appIcon and
            ui.image({ path = appIcon, width = 25 }) or
            ui.glyph({ name = 'question-mark', size = 25, color = window.is_focused and focusedText or inactiveText, }),
          ui.label({
            maxLines = 1,
            flexGrow = 1,
            opacity = window.is_focused and 1.0 or 0.75,
            fontSize = 13,
            color = window.is_focused and focusedText or inactiveText,
            text = window.title,
          }),
      })
    end
  end

  barWidget.render(container({ width = maxWidth, gap = 5, align = "center" }, columns))
end

local outputName = barWidget.outputName()

if outputName == nil then
  noctalia.notifyError("Niri Taskbar failed to initialize", "Noctalia returned `nil` when querying the current monitor name.")
else
  local state: NiriState = {
    output = outputName
  }

  noctalia.runStream('niri msg --json event-stream', function(line: string)
    local event = noctalia.json.decode(line) :: NiriEvent

    state = niri.processEvent(state, event)

    if state.windows then
      render(state.windows)
    end
  end)
end
