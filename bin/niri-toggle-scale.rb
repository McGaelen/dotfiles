#!/usr/bin/env ruby
# @vicinae.schemaVersion 1
# @vicinae.title Niri - Toggle Scale
# @vicinae.mode silent

require 'json'

def toggle_scale(monitor, default_scale, expanded_scale)
  json = JSON.parse(`niri msg --json outputs`)
  scale = json[monitor]['logical']['scale']
  new_scale = scale == default_scale ? expanded_scale : default_scale

  `niri msg output DP-1 scale #{new_scale}`

  puts "Scale set to #{new_scale}"
end

hostname = `hostname`.chomp

if hostname == 'Gaelens-LinuxPC'
  toggle_scale 'DP-1', 1.75, 1.35
elsif hostname == 'Gaelens-Framework13'
  toggle_scale 'eDP-1', 1.75, 1.35
end
