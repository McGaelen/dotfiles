#!/usr/bin/env fish

cd ~/dotfffiles && git pull && ./install

if test $status != 0
  notify-send -u critical -t 10000 "Dotfiles Error" "Failed to pull the latest dotfiles."
end
