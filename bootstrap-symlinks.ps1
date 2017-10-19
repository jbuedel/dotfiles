# Set up symlinks to my .dotfiles

new-item -Path ~\.vimrc -ItemType SymbolicLink -Value $PSScriptRoot\.vimrc
new-item -Path ~\.gvimrc -ItemType SymbolicLink -Value $PSScriptRoot\.gvimrc
new-item -Path ~\.vsvimrc -ItemType SymbolicLink -Value $PSScriptRoot\.vsvimrc

# AutoHotKey looks in ~\Documents by default.
# (but where does it look when Documents is on Onedrive? need to look into this probably)
new-item -Path ~\Documents\AutoHotKey.ahk -ItemType SymbolicLink -Value $PSScriptRoot\AutoHotKey.ahk
