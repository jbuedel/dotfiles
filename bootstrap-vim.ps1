# Create vim's temp directory (as specified in my .vimrc)
md ~/vimtmp

# Install Pathogen for vim plugin management
md ~/vimfiles/autoload 
md ~/vimfiles/bundle
# This puts DOS line endings, and vim gets an error when loading!
(New-Object Net.WebClient).DownloadString("https://tpo.pe/pathogen.vim") > ~/vimfiles/autoload/pathogen.vim

pushd ~/vimfiles/bundle

# Install Solarized theme.
git clone git://github.com/altercation/vim-colors-solarized.git

# Powershell syntax highlighting.
git clone https://github.com/pprovost/vim-ps1.git

# Omnisharp for .net dev - unfortunately does not work as my vim does not have +python support
git clone https://github.com/OmniSharp/omnisharp-vim.git
cd omnisharp
git submodule update --init --recursive
cd server
msbuild
choco install python2 /y

# OmniSharp requires 32 bit python
choco install python2-x86_32

popd
