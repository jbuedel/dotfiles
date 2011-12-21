Set-Alias -name bc 'C:\Program Files (x86)\Beyond Compare 3\BComp.exe'
Set-Alias -name npp open-text
Set-Alias -name notepad++ 'C:\Program Files (x86)\Notepad++\notepad++.exe'
Set-Alias -name favorite-text-editor notepad++
Set-Alias hg 'C:\Program Files\Mercurial\hg.exe'


Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)


# POSH-JOSH Extension
Import-Module posh-josh

# POSH-HG Extension.  From http://poshhg.codeplex.com/.
# Load posh-hg module from current directory
Import-Module posh-hg

# Add POSH-GIT Extension
Import-Module posh-git

# Set up a simple prompt, adding the git prompt parts inside git repos
function prompt {
    $realLASTEXITCODE = $LASTEXITCODE
    
    # Reset color, which can be messed up by Enable-GitColors
    $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor
    
    Write-Host($pwd) -nonewline
    
    # Git Prompt
    $Global:GitStatus = Get-GitStatus
    Write-GitStatus $Global:GitStatus
    
	# My own Git Prompt.
	#$branchname = git branch | where { $_.StartsWith('*') } | %{ $_.Trim('*') }
	#Write-Host($branchname) -nonewline -ForegroundColor Red
    
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
        # GIT: Execute git tab completion for all git-related commands
        "$(Get-GitAliasPattern) (.*)" { GitTabExpansion $lastBlock }
		# TODO: add other expansions here...
        # DEFAULT: Fall back on existing tab expansion
        default { & $teBackup $line $lastWord }
    }
}

Enable-GitColors

$global:GitTabSettings.AllCommands = $false

Pop-Location

# put me in my current project directory
cd ~\Projects

"Your custom settings are almost complete, my overlord."
"You need to add Visual Studio tools to your environment.  Issue either a 'vs2005', 'vs2008', or 'vs2010' command to do this."
