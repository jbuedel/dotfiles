Import-Module posh-josh
Import-Module posh-git

Import-Module psget
Import-Module psurl
Import-Module pswatch
Import-Module posh-hg


Set-Alias -name favorite-text-editor notepad++
Set-Alias -name npp open-text
Set-Alias -name bc 'C:\Program Files (x86)\Beyond Compare 3\BComp.exe'
Set-Alias ssh-agent 'C:\Program Files (x86)\Git\bin\ssh-agent.exe'
Set-Alias ssh-add 'C:\Program Files (x86)\Git\bin\ssh-add.exe'

Set-Alias -name notepad++ 'C:\Program Files (x86)\Notepad++\notepad++.exe'
Set-Alias hg 'C:\Program Files\Mercurial\hg.exe'
Set-Alias rubymine "C:\Program Files (x86)\JetBrains\RubyMine 3.2.4\bin\rubymine.exe"
Set-Alias rcsi "C:\Program Files (x86)\Microsoft Codename Roslyn CTP\Binaries\rcsi.exe"
Set-Alias gitex 'C:\Program Files (x86)\GitExtensions\gitex.cmd'
Set-Alias linqpad 'C:\Program Files (x86)\LINQPad4\LINQPad.exe'
 
Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

# Set up a simple prompt, adding the git prompt parts inside git repos
function prompt {
    $realLASTEXITCODE = $LASTEXITCODE

    # Reset color, which can be messed up by Enable-GitColors
    $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor

	# TODO: Convert this to put ~/ instead of the full path when I'm in my home folder.
    Write-Host($pwd) -nonewline
    
	Write-VcsStatus    
	
	$Host.UI.RawUI.WindowTitle = $Global:GitStatus.Branch + " " + ((Get-LocalOrParentPath .git) | split-path)
	
	# Doesn't work.  And puts a spurious 'PS' in the prompt.
	#SetTitleToProjectAndBranch($branchname)
	
    $LASTEXITCODE = $realLASTEXITCODE
    return "> "
}

function SetTitleToProjectAndBranch($branch) {
	write-host "getting project folder.  branch is $branch"
	$projectFolder = Get-LocalOrParentPath .git
	write-host "project folder is $projectFolder"
	if ($projectFolder -ne $null) {
		$HOST.UI.RawUI.WindowTitle = $projectFolder + " " + $branch
	}
}

# Copied from posh-git
function Get-LocalOrParentPath($path) {
    $checkIn = Get-Item .
    while ($checkIn -ne $NULL) {
        $pathToTest = [System.IO.Path]::Combine($checkIn.fullname, $path)
        if (Test-Path $pathToTest) {
            return $pathToTest
        } else {
            $checkIn = $checkIn.parent
        }
    }
    return $null
}

Enable-GitColors
Start-SshAgent -Quiet
$global:GitTabSettings.AllCommands = $false

Pop-Location

# put me in my current project directory
cd ~\Projects

"Your custom settings are almost complete, my overlord."
"You need to add Visual Studio tools to your environment.  Issue either a 'vs2005', 'vs2008', or 'vs2010' command to do this."
