# Create vim's temp directory (as specified in my .vimrc)
md ~/vimtmp

# Install Pathogen for vim plugin management
md ~/vimfiles/autoload 
md ~/vimfiles/bundle
# This puts DOS line endings, and vim gets an error when loading!
(New-Object Net.WebClient).DownloadString("https://tpo.pe/pathogen.vim") > ~/vimfiles/autoload/pathogen.vim

# Install Solarized theme.
pushd ~/vimfiles/bundle
git clone git://github.com/altercation/vim-colors-solarized.git
popd
