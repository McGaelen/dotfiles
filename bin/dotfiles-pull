#!/usr/bin/env ruby

`cd ~/dotfiles && git pull && ./install`

if $? != 0
  # Need to sleep, because this could be run before noctalia (or another notification manager) starts up.
  sleep 3
  `notify-send -u critical -t 10000 "Dotfiles Error" "Failed to pull the latest dotfiles."`
end
