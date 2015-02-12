# Intended to build out a new machine as much as possible.

# Install chocolatey.
(new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1') | iex

# Install boxstarter, which gives a bunch of other commands.
choco install boxstarter

# Make explorer more tolerable.
Set-ExplorerOptions -showHidenFilesFoldersDrives -showProtectedOSFiles -showFileExtensions

choco install vim
choco install googlechrome
choco install firefox
choco install msysgit # duplicated from bootstrap-powershell.ps1 but whatever
choco install beyondcompare
choco install notepadplusplus
choco install windirstat
choco install itunes
choco install conemu
choco install EthanBrown.ConEmuConfig
choco install hipchat

choco install linqpad4
choco install sysinternals
choco install dropbox
choco install paint.net

choco install dotpeek
choco install resharper
choco install dotcover
choco install dotpeek

# AutoHotKey has it's script file set via a sym-link created elsewhere.
choco install autohotkey
choco install windowpad

choco install webmatrix

choco install pscx

# Create vim's temp directory (as specified in my .vimrc)
md ~/vimtmp

# Install Pathogen for vim plugin management
md ~/vimfiles/autoload 
md ~/vimfiles/bundle
# This puts DOS line endings, and vim gets an error when loading!
(New-Object Net.WebClient).DownloadString("https://tpo.pe/pathogen.vim") > ~/vimfiles/autoload/pathogen.vim
