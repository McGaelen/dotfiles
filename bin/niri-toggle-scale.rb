#!/usr/bin/env ruby
# @vicinae.schemaVersion 1
# @vicinae.title Niri - Toggle Scale
# @vicinae.mode silent

require 'json'

hostname = `hostname`

if hostname == 'Gaelens-LinuxPC'
  toggle_scale({ monitor: 'DP-1', default_scale: 1.75, expanded_scale: 1.35 })
elsif hostname == 'Gaelens-Framework13'
  toggle_scale({ monitor: 'eDP-1', default_scale: 1.75, expanded_scale: 1.35 })
end

def toggle_scale(args)
  json = JSON.parse(`niri msg --json outputs`)
  scale = json[args.monitor]['logical']['scale']

  `niri msg output DP-1 scale #{scale == args.default_scale ? args.expanded_scale : args.default_scale}`
end
