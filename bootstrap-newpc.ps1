# Intended to build out a new machine as much as possible.

# Install chocolatey.
(new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1') | iex

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
cinst conemu
cinst EthanBrown.ConEmuConfig
cinst hipchat
cinst ungit
cinst linqpad4
cinst sysinternals
cinst dropbox
cinst paint.net
cinst dropbox

cinst dotpeek
cinst resharper
cinst dotcover
cinst dotpeek

cinst ungit # html git client

# Autohotkey needs to reference my custom script, currently in DropBox.
cinst autohotkey

cinst webmatrix

