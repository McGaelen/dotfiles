#!/usr/bin/env ruby
# @vicinae.schemaVersion 1
# @vicinae.title Desktop - Toggle Scale
# @vicinae.mode silent

require 'json'

def main
  hostname = `hostname`.chomp

  if hostname == 'Gaelens-LinuxPC'
    toggle_scale 'DP-1', 1.75, 1.35
  elsif hostname == 'Gaelens-Framework13'
    toggle_scale 'eDP-1', 1.75, 1.35
  end
end

def toggle_scale(monitor, default_scale, expanded_scale)
  desktop = ENV['XDG_CURRENT_DESKTOP']

  if desktop == 'niri'
    json = JSON.parse(`niri msg --json outputs`)
    scale = json[monitor]['logical']['scale']
    new_scale = scale == default_scale ? expanded_scale : default_scale

    `niri msg output DP-1 scale #{new_scale}`
  elsif desktop == 'COSMIC'
    filepath = '/tmp/gaelen-cosmic-current-scale'
    scale = File.exist?(filepath) ? File.read(filepath).to_f : ''
    new_scale = scale == default_scale ? expanded_scale : default_scale

    `cosmic-randr mode --scale #{new_scale} --refresh 119.991 DP-1 3840 2560`

    File.write filepath, new_scale
  end

  puts "Scale set to #{new_scale}"
end

main
