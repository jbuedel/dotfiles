# Intended to build out a new machine as much as possible.

# Install chocolatey.
(new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1') | iex

cinst vim
cinst googlechrome
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

cinst paint.net

cinst resharper
cinst dotcover

cinst autohotkey

# Doesn't exist.
#cinst webmatrix

