#Set up symlinks to my .dotfiles
new-symlink ~\.vimrc ~\Documents\WindowsPowerShell\.vimrc
new-symlink ~\.gvimrc ~\Documents\WindowsPowerShell\.gvimrc
new-symlink ~\.vsvimrc ~\Documents\WindowsPowerShell\.vsvimrc
; AutoHotKey looks in ~\Documents by default.
new-symlink ~\Documents\AutoHotKey.ahk ~\Documents\WindowsPowerShell\AutoHotKey.ahk