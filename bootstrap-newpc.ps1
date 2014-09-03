# Intended to build out a new machine as much as possible.

# Install chocolatey.
(new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1') | iex

cinst vim
cinst googlechrome
cinst firefox
cinst msysgit # duplicated from bootstrap-powershell.ps1 but whatever
cinst beyondcompare
cinst notepadplusplus
cinst windirstat
cinst itunes
cinst conemu
cinst EthanBrown.ConEmuConfig
cinst hipchat
cinst ungit
cinst linqpad4
cinst sysinternals
cinst dropbox
cinst paint.net

cinst dotpeek
cinst resharper
cinst dotcover
cinst dotpeek

cinst ungit # html git client

cinst autohotkey

# Doesn't exist.
#cinst webmatrix

#Set up symlinks to my .dotfiles
new-symlink ~\.vimrc ~\Documents\WindowsPowerShell\.vimrc
new-symlink ~\.gvimrc ~\Documents\WindowsPowerShell\.gvimrc
new-symlink ~\.vsvimrc ~\Documents\WindowsPowerShell\.vsvimrc
