#!/usr/bin/env ruby
# @vicinae.schemaVersion 1
# @vicinae.title Screenshare Mode - Off
# @vicinae.mode silent

desktop = ENV['XDG_CURRENT_DESKTOP']
file = "#{ENV['HOME']}/.config/niri/screenshare-mode.kdl"

if desktop == 'niri'
  `niri msg output DP-1 scale 1`
  `niri msg output DP-1 mode 2560x1440@359.999`
  `niri msg output DP-2 on`
  File.delete file
else
  `kscreen-doctor output.DP-1.scale.1 output.DP-1.mode.2560x1440@360`
  `kscreen-doctor output.DP-2.enable`
end
