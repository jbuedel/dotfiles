# Intended to build out a new machine as much as possible.

# Install chocolatey.
(new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1') | iex

cinst googlechrome
cinst git
cinst beyondcompare
cinst notepadplusplus
cinst windirstat
cinst itunes

# Doesn't exist.
#cinst webmatrix

