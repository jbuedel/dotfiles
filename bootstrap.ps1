# Intended to install as much of my powershell customizations as possible on a new machine.

# Install psget - the NuGet of Powershell
(new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex

# Use psget to install other modules.
install-module psurl
install-module pswatch
install-module posh-hg