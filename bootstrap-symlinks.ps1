choco install pscx # this is where new-symlink lives
import-module pscx

# Set up symlinks to my .dotfiles
new-symlink ~\.vimrc ~\Documents\WindowsPowerShell\.vimrc
new-symlink ~\.gvimrc ~\Documents\WindowsPowerShell\.gvimrc
new-symlink ~\.vsvimrc ~\Documents\WindowsPowerShell\.vsvimrc
# AutoHotKey looks in ~\Documents by default.
new-symlink ~\Documents\AutoHotKey.ahk ~\Documents\WindowsPowerShell\AutoHotKey.ahk


# Set up symlinks to my Beyond Compare settings.
New-Symlink -TargetPath '~\Documents\WindowsPowerShell\Beyond Compare 4\' -LiteralPath '~\AppData\Roaming\Scooter Software\Beyond Compare 4'

# Symlink to my ConEmu settings.
new-symlink $env:AppData\ConEmu.xml ~\Documents\WindowsPowerShell\ConEmu.xml
