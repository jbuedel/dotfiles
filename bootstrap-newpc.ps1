# Intended to build out a new machine as much as possible.

# Install chocolatey.
(new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1') | iex

choco feature enable -n=allowGlobalConfirmation

# Install boxstarter, which gives a bunch of other commands.
choco install boxstarter

# Make explorer more tolerable.
Set-ExplorerOptions -showHidenFilesFoldersDrives -showProtectedOSFiles -showFileExtensions

cinst vim
cinst googlechrome
cinst firefox
cinst msysgit # duplicated from bootstrap-powershell.ps1 but whatever
cinst beyondcompare
cinst notepadplusplus
cinst windirstat
cinst itunes

cinst linqpad4
cinst linqpad5
cinst sysinternals
cinst dropbox
cinst paint.net

# TODO: Autohotkey needs to reference my custom script, currently in DropBox.
cinst autohotkey

cinst webmatrix

