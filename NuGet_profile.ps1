Set-Alias -name bc 'C:\Program Files (x86)\Beyond Compare 3\BComp.exe'
Set-Alias -name npp 'C:\Program Files (x86)\Notepad++\notepad++.exe'


Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

# Add POSH-GIT Extension
Import-Module .\posh-git

# If module is installed in a default location ($env:PSModulePath),npp
# use this instead (see about_Modules for more information):
# Import-Module posh-hg

# Set up a simple prompt, adding the git prompt parts inside git repos
function prompt {
    $realLASTEXITCODE = $LASTEXITCODE

    Write-Host($pwd) -nonewline

    $LASTEXITCODE = $realLASTEXITCODE
    return "> "
}



Pop-Location


"Your custom settings are almost complete, my overlord."
