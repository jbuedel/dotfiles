# Intended to build out a new machine as much as possible.

# Install chocolatey.
(new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1') | iex

# Install boxstarter, which gives a bunch of other commands.
choco install boxstarter

# Make explorer more tolerable.
Set-ExplorerOptions -showHidenFilesFoldersDrives -showProtectedOSFiles -showFileExtensions

choco install vim
choco install beyondcompare
choco install notepadplusplus
choco install screentogif
choco install tailblazer

choco install linqpad4
choco install sysinternals
choco install paint.net

choco install resharper

# Use vim as default editor in git.
git config --global core.editor "vim"
