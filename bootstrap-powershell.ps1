# Intended to install as much of my powershell customizations as possible on a new machine.
# Including this repo itself!
# Run this via:
#   (new-object net.webclient).DownloadString("https://raw.github.com/jbuedel/dotfiles/work-desktop/bootstrap-powershell.ps1") | iex

# Create ~\Documents\WindowsPowerShell
if(!(test-path $profile\..)) {mkdir $profile\.. }
cd $profile\..

#install chocolately
if(-not (get-command chocolatey)) {
  iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
}

cinst msysgit
git config --global user.name "Josh Buedel"
git config --global user.email "jbuedel@gmail.com"


if(!(test-path ~\.ssh\id_rsa)){
	write-host "ssh key file not found.  creating one."
	$keyfile = (Convert-Path ~\.ssh\) + "id_rsa"
	
	& 'C:\Program Files (x86)\Git\bin\ssh-keygen.exe' -t rsa -C "jbuedel@gmail.com" -f $keyfile
	& 'C:\Program Files (x86)\Git\bin\ssh-add.exe' $keyfile
	
	write-host "Put this key file on Github. It's on the clipboard."
	cat ~\.ssh\id_rsa.pub | clip
	start "https://github.com/settings/ssh"	
	return
}


git clone git@github.com:jbuedel/dotfiles.git .
git checkout work-desktop
# Actually fills out the submodules (does not happened automatically for some reason)
git submodule update --init

# Install PsWatch
iex ((new-object net.webclient).DownloadString("http://bit.ly/Install-PsWatch"))

(new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex
install-module PSReadline
install-module PSCX
