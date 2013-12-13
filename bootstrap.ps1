# Intended to install as much of my powershell customizations as possible on a new machine.

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


git clone git@github.com:jbuedel/dotfiles.git .
git checkout work-desktop
# Actually fills out the submodules (does not happened automatically for some reason)
git submodule update --init
