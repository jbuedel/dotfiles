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
choco install screentogif
choco install tailblazer

choco install linqpad4
choco install linqpad5
choco install sysinternals
choco install dropbox
choco install paint.net

# AutoHotKey has it's script file set via a sym-link created elsewhere.
choco install autohotkey
choco install windowpad

choco install webmatrix

choco install dependencywalker
choco install pscx


# Use vim as default editor in git.
git config --global core.editor "vim"
