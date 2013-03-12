Set-Alias -name git "c:\Program Files (x86)\Git\bin\git.exe"
Set-Alias -name favorite-text-editor notepad++
Set-Alias -name npp open-text
Set-Alias -name bc 'C:\Program Files (x86)\Beyond Compare 3\BComp.exe'
set-alias ssh-agent 'C:\Program Files (x86)\Git\bin\ssh-agent.exe'
set-alias ssh-add 'C:\Program Files (x86)\Git\bin\ssh-add.exe'
set-alias gitex  'C:\Program Files (x86)\GitExtensions\GitExtensions.exe'

import-module posh-josh
import-module posh-git
import-module project-commands
import-module psget
import-module psurl
import-module pswatch


Set-Alias -name notepad++ 'C:\Program Files (x86)\Notepad++\notepad++.exe'
Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

# Set up a simple prompt, adding the git prompt parts inside git repos
function prompt {
    $realLASTEXITCODE = $LASTEXITCODE

    # Reset color, which can be messed up by Enable-GitColors
    $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor

    Write-Host (foo) -nonewline
        
	# This method comes from posh-git and/or posh-hg.
	Write-VcsStatus    

	# This line depends on posh-git and posh-josh.
	$Host.UI.RawUI.WindowTitle = $Global:GitStatus.Branch + " " + ((Get-LocalOrParentPath .git) | split-path)
	
    $LASTEXITCODE = $realLASTEXITCODE
    return "> "
}

Enable-GitColors
Start-SshAgent -Quiet
$global:GitTabSettings.AllCommands = $false

Pop-Location

# put me in my current project directory
cd ~\Projects

"Your custom settings are almost complete, my overlord."
"You need to add Visual Studio tools to your environment.  Issue either a 'vs2005', 'vs2008', or 'vs2010' command to do this."


function foo {
	if($pwd.Path.StartsWith($home)) {
		return '~' + $pwd.Path.Substring($home.Length)
        }
	else {
		return $pwd
    }
}



Import-Module PowerShellServer
