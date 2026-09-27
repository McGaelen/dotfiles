#!/usr/bin/env ruby
# @vicinae.schemaVersion 1
# @vicinae.title Niri - Toggle Center Columns
# @vicinae.mode silent

path = "#{ENV['HOME']}/.config/niri/center-column.kdl"

if File.exist? path
  `rm #{path}`
else
  File.write path, <<~EOF
    layout {
      center-focused-column "always"
    }
  EOF
end
