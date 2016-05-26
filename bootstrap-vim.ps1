pushd ~

# Create vim's temp directory (is used in my .vimrc)
if(test-path ~/vimtmp) {} else {
  md ~/vimtmp
}
if(test-path ~/vimtmp/swapfiles) {} else {
  md ~/vimtmp/swapfiles
}
# Install Pathogen for vim plugin management
if(test-path ~/vimfiles/autoload){} else {
  md ~/vimfiles/autoload 
}
if(test-path ~/vimfiles/bundle) {} else {
  md ~/vimfiles/bundle
}

function clone-if-not-cloned {
  param($repourl, $repolocal)

  cd ~/vimfiles/bundle

  if(test-path $repolocal) {
    pushd $repolocal
    if(git status) {
      write-host "$repourl already cloned."
      return 
    } 
    else {
      write-host "$repolocal exists, but is not a git repo. Deleting..."
      cd ..
      rm $repolocal -recurse -force
    }
    popd
  }
  write-host "Cloning $repourl to $repolocal..."
  cd $repolocal\..
  git clone $repourl $repolocal
}
write-host "Downloading pathogen.vim...(overwriting if it exists)..."
invoke-webrequest -Uri "https://tpo.pe/pathogen.vim" -OutFile ~/vimfiles/autoload/pathogen.vim

write-host "Moving to ~/vimfiles/bundle for downloading plugins..."
cd ~/vimfiles/bundle

write-host "Install Solarized theme..."
clone-if-not-cloned git://github.com/altercation/vim-colors-solarized.git vim-colors-solarized

write-host "Powershell syntax highlighting..."
clone-if-not-cloned https://github.com/pprovost/vim-ps1.git vim-ps1

write-host "Omnisharp for .net dev - unfortunately does not work as my vim does not have +python support..."
clone-if-not-cloned https://github.com/OmniSharp/omnisharp-vim.git omnisharp-vim
if(get-command msbuild) 
{
  cd ~/vimfiles/bundle/omnisharp-vim
  git submodule update --init --recursive
  cd server
  msbuild /v:minimal
 # OmniSharp requires 32 bit python
  choco install python2-x86_32
}
else {
  write-host "Msbuild not found. Couldn't updated omni-sharp."
}

popd

