Set-Alias -name bc 'C:\Program Files (x86)\Beyond Compare 3\BComp.exe'
Set-Alias -name npp 'C:\Program Files (x86)\Notepad++\notepad++.exe'
#set-alias -name npp open-text
Set-Alias hg 'C:\Program Files\Mercurial\hg.exe'


Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)


# POSH-JOSH Extension
. .\posh-josh\posh-josh.ps1

# POSH-HG Extension.  From http://poshhg.codeplex.com/.
# Load posh-hg module from current directory
Import-Module .\posh-hg

# Add POSH-GIT Extension
Import-Module .\posh-git

# If module is installed in a default location ($env:PSModulePath),npp
# use this instead (see about_Modules for more information):
# Import-Module posh-hg

# Set up a simple prompt, adding the git prompt parts inside git repos
function prompt {
    $realLASTEXITCODE = $LASTEXITCODE

    # Reset color, which can be messed up by Enable-GitColors
    $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor

    Write-Host($pwd) -nonewline
        
    # Git Prompt
	# Removed b/c it's just too slow!!!
    #$Global:GitStatus = Get-GitBranch
    #Write-GitStatus $GitStatus

    $LASTEXITCODE = $realLASTEXITCODE
    return "> "
}

$teBackup = 'posh-git_DefaultTabExpansion'
if(!(Test-Path Function:\$teBackup)) {
    Rename-Item Function:\TabExpansion $teBackup
}

# Set up tab expansion and include git expansion
function TabExpansion($line, $lastWord) {
    $lastBlock = [regex]::Split($line, '[|;]')[-1].TrimStart()
    switch -regex ($lastBlock) {
        # Execute git tab completion for all git-related commands
        "$(Get-GitAliasPattern) (.*)" { GitTabExpansion $lastBlock }
        # Fall back on existing tab expansion
        default { & $teBackup $line $lastWord }
    }
}

Enable-GitColors

Pop-Location

# put me in my current project directory
cd ~\Projects

"Your custom settings are almost complete, my overlord."
"You need to add Visual Studio tools to your environment.  Issue either a 'vs2005', 'vs2008', or 'vs2010' command to do this."
