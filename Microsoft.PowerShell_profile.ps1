import-module posh-josh
import-module posh-git
import-module powertab -ArgumentList "C:\Users\jbuedel\Documents\WindowsPowerShell\PowerTabConfig.xml"

set-alias favorite-text-editor "c:\program files (x86)\notepad++\notepad++.exe"
set-alias npp favorite-text-editor
set-alias bc 'C:\Program Files (x86)\Beyond Compare 3\BComp.exe'
set-alias ssh-agent 'C:\Program Files (x86)\Git\bin\ssh-agent.exe'
set-alias ssh-add 'C:\Program Files (x86)\Git\bin\ssh-add.exe'

# Set up a simple prompt, adding the git prompt parts inside git repos
function prompt {
    $realLASTEXITCODE = $LASTEXITCODE

    # Reset color, which can be messed up by Enable-GitColors
    $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor

    Write-Host($pwd) -nonewline
        
    # Git Prompt
    $Global:GitStatus = Get-GitStatus
    Write-GitStatus $GitStatus

    $LASTEXITCODE = $realLASTEXITCODE
    return "> "
}

if(Test-Path Function:\TabExpansion) {
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
}

Enable-GitColors
Start-SshAgent

cd ~\Projects