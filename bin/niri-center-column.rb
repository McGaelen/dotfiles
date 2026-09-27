#!/usr/bin/env ruby

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
