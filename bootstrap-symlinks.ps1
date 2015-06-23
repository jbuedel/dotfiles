choco install pscx # this is where new-symlink lives
import-module pscx

#Set up symlinks to my .dotfiles
new-symlink ~\.vimrc ~\Documents\WindowsPowerShell\.vimrc
new-symlink ~\.gvimrc ~\Documents\WindowsPowerShell\.gvimrc
new-symlink ~\.vsvimrc ~\Documents\WindowsPowerShell\.vsvimrc
# AutoHotKey looks in ~\Documents by default.
new-symlink ~\Documents\AutoHotKey.ahk ~\Documents\WindowsPowerShell\AutoHotKey.ahk

new-symlink ~\.ConEmu.xml ~\AppData\Roaming\ConEmu.xml
