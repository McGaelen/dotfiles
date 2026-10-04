#!/usr/bin/env ruby
# @vicinae.schemaVersion 1
# @vicinae.title Screenshare Mode - On
# @vicinae.mode silent

desktop = ENV['XDG_CURRENT_DESKTOP']
file = "#{ENV['HOME']}/.config/niri/screenshare-mode.kdl"

if desktop == 'niri'
  `niri msg output DP-1 scale 1.25`
  `niri msg output DP-1 mode 1680x1050@59.954`
  `niri msg output DP-2 off`
  File.write file, <<~KDL
    input {
      mouse {
        accel-speed 0
      }
    }
  KDL
else
  `kscreen-doctor output.DP-1.scale.1 output.DP-1.mode.2560x1440@360`
  `kscreen-doctor output.DP-2.enable`
end
