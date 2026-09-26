source /usr/share/cachyos-fish-config/cachyos-config.fish

# set -gx PATH $PATH /home/gaelen/.lmstudio/bin
# set -gx QT_QPA_PLATFORMTHEME qt6ct
# set -gx ELECTRON_OZONE_PLATFORM_HINT auto
# set -gx QT_QPA_PLATFORM "wayland"
# set -gx QT_WAYLAND_DECORATION
# set -gx XDG_CURRENT_DESKTOP "XFCE"

fish_add_path ~/.lmstudio/bin
fish_add_path /opt/jetbrains-toolbox/bin
fish_add_path ~/bin

alias cat="bat"
alias fzf="fzf --style full"
alias codium="codium --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland"
alias n="nnn -eHoUzA" # e: open text files in $VISUAL, H:hidden files, o:open on enter key, U:show user/group, z:fuzzy filters, A:disable auto-enter dir

fzf --fish | source

function fish_greeting
 # override CachyOS's default greeting (which is normally fastfetch.)
end

function source-fish -d "Source your fish config file"
  source ~/.config/fish/config.fish
end

function lll -d "Runs ls -al"
  ls -al $argv
end

if status is-interactive
  # Commands to run in interactive sessions can go here
  function ffiles -d "Interactively search filenames using fd and fzf"
    fd $argv | fzf --preview 'cat {}' --bind 'enter:execute(open {})'
  end

  function ftext -d "Interactively search for text in files using ripgrep"
    rg --files-with-matches --no-messages $argv | \
    fzf \
      --preview (string join ' ' 'highlight -O ansi {} | rg --colors "match:bg:yellow" --pretty --context 10 --ignore-case' $argv[(count argv)]) \
      --bind 'enter:execute(open {})'
  end
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
