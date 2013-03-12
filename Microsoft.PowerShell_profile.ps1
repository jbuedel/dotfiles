
Set-Alias -name bc 'C:\Program Files (x86)\Beyond Compare 3\BComp.exe'


import-module posh-josh
import-module posh-git
import-module project-commands

import-module psget
import-module psurl
import-module pswatch

#Import-Module posh-hg

Set-Alias -name git "c:\Program Files (x86)\Git\bin\git.exe"
Set-Alias -name favorite-text-editor notepad++
Set-Alias -name npp open-text

set-alias ssh-agent 'C:\Program Files (x86)\Git\bin\ssh-agent.exe'
set-alias ssh-add 'C:\Program Files (x86)\Git\bin\ssh-add.exe'
Set-Alias ssh 'C:\Program Files (x86)\Git\bin\ssh.exe'

Set-Alias -name notepad++ 'C:\Program Files (x86)\Notepad++\notepad++.exe'
set-alias gitex  'C:\Program Files (x86)\GitExtensions\GitExtensions.exe'
Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

. ".\Start-RDP.ps1"

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


<#
    .SYNOPSIS 
     Launches an rdp connection to one of my preferred list of servers.
     Use tab completion to fill in the server name from a hard coded list.
    .EXAMPLE
     rdp www.fpweb.net 
     Launches an rdp session to www.fpweb.net.
#>
function rdp {
    param([ValidateSet('www.fpweb.net','dev.fpweb.net','ampdev.net')][string]$server)
    Start-RDP -Server $server -Fullscreen
}

function Set-FileTime{
  param(
    [string[]]$paths,
    [bool]$only_modification = $false,
    [bool]$only_access = $false
  );
  begin {
    function updateFileSystemInfo([System.IO.FileSystemInfo]$fsInfo) {
      $datetime = get-date
      if ( $only_access )
      {
         $fsInfo.LastAccessTime = $datetime
      }
      elseif ( $only_modification )
      {
         $fsInfo.LastWriteTime = $datetime
      }
      else
      {
         $fsInfo.CreationTime = $datetime
         $fsInfo.LastWriteTime = $datetime
         $fsInfo.LastAccessTime = $datetime
       }
    }
    function touchExistingFile($arg) {
      if ($arg -is [System.IO.FileSystemInfo]) {
        updateFileSystemInfo($arg)
      }
      else {
        $resolvedPaths = resolve-path $arg
        foreach ($rpath in $resolvedPaths) {
          if (test-path -type Container $rpath) {
            $fsInfo = new-object System.IO.DirectoryInfo($rpath)
          }
          else {
            $fsInfo = new-object System.IO.FileInfo($rpath)
          }
          updateFileSystemInfo($fsInfo)
        }
      }
    }
    function touchNewFile([string]$path) {
      #$null > $path
      Set-Content -Path $path -value $null;
    }
  }
  process {
    if ($_) {
      if (test-path $_) {
        touchExistingFile($_)
      }
      else {
        touchNewFile($_)
      }
    }
  }
  end {
    if ($paths) {
      foreach ($path in $paths) {
        if (test-path $path) {
          touchExistingFile($path)
        }
        else {
          touchNewFile($path)
        }
      }
    }
  }
}
New-Alias touch Set-FileTime
