source /usr/share/cachyos-fish-config/cachyos-config.fish

set -gx VISUAL "nano"
set -gx EDITOR "nano"

fish_add_path ~/.lmstudio/bin
fish_add_path /opt/jetbrains-toolbox/bin
fish_add_path ~/bin # My custom scripts
fish_add_path "$HOME/.local/bin" # Some tools like to install here

alias ls="eza --color=auto --group-directories-first --icons=auto"
alias lll="ls -al"
alias cat="bat -p"
alias codium="codium --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland"
alias nnn="nnn -eHoUzA" # e: open text files in $VISUAL, H:hidden files, o:open on enter key, U:show user/group, z:fuzzy filters, A:disable auto-enter dir

fzf --fish | source

function fish_greeting
 # override CachyOS's default greeting (which is normally fastfetch.)
end

function source-fish -d "Source your fish config file"
  source ~/.config/fish/config.fish
end

function detach -d "nohup <cmd> 1>/dev/null 2>/dev/null &; disown"
	nohup $argv 1>/dev/null 2>/dev/null &; disown
end

function times -d "Repeat a command n times"
  for i in (seq 1 $argv[1])
    echo $i
    eval $argv[2..-1]
  end
end

function ports -d "List applications listening on a given port"
  set port $argv[1]
  if test -n "$port"
    lsof -i -P | rg $port
  else
    lsof -i -P
  end
end

function fif -d "Find-In-Files: Interactively search for text in files using ripgrep"
  # Just using fzf for it's TUI. The options list is driven completely by rg - hence the `--disabled` flag.
  fzf \
    --disabled \
    --preview 'bat -p --color always {} | rg --colors "match:bg:yellow" --pretty --context 5 --ignore-case {q}' \
    --bind 'change:reload(rg -l --no-messages {q})' \
    --height 60% \
    --layout reverse \
    --list-border rounded \
    --list-label 'Find-In-Files'
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
