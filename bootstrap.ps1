# Intended to install as much of my powershell customizations as possible on a new machine.

pushd $profile\..
if(!(test-path Modules)) { md Modules }

# Install psget - the NuGet of Powershell
(new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex

# Use psget to install other modules.
install-module psurl
install-module pswatch

# Install some modules using git (Modules is ignored in .gitignore - very important cause submodules suck).
pushd Modules
git clone git@github.com:jbuedel/posh-git.git
pushd posh-git
git remote add upstream git@github.com:dahlbyk/posh-git.git
popd # Back to Modules

git clone git@github.com:jbuedel/project-commands.git
git clone git@github.com:jbuedel/posh-josh.git

popd # Should end up in $profile directory.


write-host "Add these commands to your $PROFILE."
ls .\Modules | %{write-host "`tImport-Module $_"}
