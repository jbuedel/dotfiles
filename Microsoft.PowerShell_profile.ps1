Import-Module psget
Import-Module pswatch
Import-Module psurl
Import-Module posh-josh
Import-Module posh-hg
Import-Module posh-git

Set-Alias -name bc 'C:\Program Files (x86)\Beyond Compare 3\BComp.exe'
Set-Alias -name npp open-text
Set-Alias -name notepad++ 'C:\Program Files (x86)\Notepad++\notepad++.exe'
Set-Alias -name favorite-text-editor notepad++
Set-Alias hg 'C:\Program Files\Mercurial\hg.exe'
Set-Alias ssh-agent 'C:\Program Files (x86)\Git\bin\ssh-agent.exe'
Set-Alias ssh-add 'C:\Program Files (x86)\Git\bin\ssh-add.exe'
Set-Alias rubymine "C:\Program Files (x86)\JetBrains\RubyMine 3.2.4\bin\rubymine.exe"
Set-Alias rcsi "C:\Program Files (x86)\Microsoft Codename Roslyn CTP\Binaries\rcsi.exe"
Set-Alias gitex 'C:\Program Files (x86)\GitExtensions\gitex.cmd'
Set-Alias linqpad 'C:\Program Files (x86)\LINQPad4\LINQPad.exe'
 
Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

# Add ssh-agent utils.
#. (Resolve-Path ~/Documents/WindowsPowershell/ssh-agent-utils.ps1)

# Set up a simple prompt, adding the git prompt parts inside git repos
function prompt {
    $realLASTEXITCODE = $LASTEXITCODE

    # Reset color, which can be messed up by Enable-GitColors
    $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor

	# TODO: Convert this to put ~/ instead of the full path when I'm in my home folder.
    Write-Host($pwd) -nonewline
        
	#if($pwd -notmatch "Fpweb.net") { # git status is REALLY slow in this folder
		# Git Prompt
		$Global:GitStatus = Get-GitStatus
		Write-GitStatus $Global:GitStatus
	#}
	# Need to be checking these for null.  The path also needs trimming down to just the project dir name (Mercury, etc.).
	$Host.UI.RawUI.WindowTitle = $Global:GitStatus.Branch + " " + (Get-LocalOrParentPath .git)
	
	# My own Git Prompt.
	#$branchname = git branch | where { $_.StartsWith('*') } | %{ $_.Trim('*') }
	#Write-Host($branchname) -nonewline -ForegroundColor Red

	# Doesn't work.  And puts a spurious 'PS' in the prompt.
	#SetTitleToProjectAndBranch($branchname)
	
    # Mercurial Prompt
    $Global:HgStatus = Get-HgStatus
    Write-HgStatus $HgStatus

	
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

        # mercurial and tortoisehg tab expansion
        '(hg|thg) (.*)' { HgTabExpansion($lastBlock) }

		# TODO: add other expansions here...
		
        # DEFAULT: Fall back on existing tab expansion
        default { & $teBackup $line $lastWord }
    }
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

$global:GitTabSettings.AllCommands = $false

Pop-Location

# put me in my current project directory
cd ~\Projects

"Your custom settings are almost complete, my overlord."
"You need to add Visual Studio tools to your environment.  Issue either a 'vs2005', 'vs2008', or 'vs2010' command to do this."
