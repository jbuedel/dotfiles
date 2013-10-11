set-alias git 'D:\Program Files (x86)\Git\bin\git.exe'
set-alias bc 'C:\Program Files (x86)\Beyond Compare 3\BComp.exe'

Import-Module posh-git
Import-Module posh-josh
Import-Module project-commands

Import-Module psget
Import-Module psurl
Import-Module pswatch

Set-Alias -name favorite-text-editor notepad++
Set-Alias -name npp open-text
Set-Alias -name bc 'D:\Program Files (x86)\Beyond Compare 3\BComp.exe'
Set-Alias ssh-agent 'D:\Program Files (x86)\Git\bin\ssh-agent.exe'
Set-Alias ssh-add 'D:\Program Files (x86)\Git\bin\ssh-add.exe'
Set-Alias ssh 'D\Program Files (x86)\Git\bin\ssh.exe'

Set-Alias -name notepad++ 'C:\Program Files (x86)\Notepad++\notepad++.exe'
Set-Alias rcsi "C:\Program Files (x86)\Microsoft Codename Roslyn CTP\Binaries\rcsi.exe"
Set-Alias gitex 'C:\Program Files (x86)\GitExtensions\gitex.cmd'

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
    return ">"
}

Enable-GitColors
Start-SshAgent -Quiet
$global:GitTabSettings.AllCommands = $false
if((git config --global core.preloadindex) -ne 'true') { git config --global core.preloadindex true }

Pop-Location


# put me in my current project directory
cd ~\Projects

"Your custom settings are almost complete, my overlord."
"You need to add Visual Studio tools to your environment.  Issue either a 'vs2005', 'vs2008', 'vs2010', or 'vs2012' command to do this."


function foo {
	if($pwd.ProviderPath.StartsWith($home)) {
		return '~' + $pwd.ProviderPath.Substring($home.Length)
	}
	else {
		return $pwd
	}
}


<#
    .SYNOPSIS 
     Launches an rdp connection to one of my preferred list of servers.
     Use tab completion to fill in the server name from a hard coded list.
     Opens the session in FullScreen mode.

     Use the Start-RDP command to go to any server.
    .EXAMPLE
     rdp www.fpweb.net 
     Launches an rdp session to www.fpweb.net.
#>
function rdp {
    param([ValidateSet("old_www_box","dev.fpweb.net","ampdev.net","www1","www2", "mercury.fpweb.net")][string]$server)

    $the_server = $server # $server can only be one of set values.

    # Note that these are the backup ips.  Not the private ips (which is how the build agent talks to them).
    if($server -eq "www1") { $the_server = "172.27.0.53" }
    if($server -eq "www2") { $the_server = "172.27.0.67" }
	if($server -eq "old_www_box") { $the_server = "204.144.122.42" }

    Start-RDP -Server $the_server -Fullscreen
}

function ssh-to-known-host {
    param([ValidateSet("blog.fpweb.net")][string]$myHost)

    if($myHost -eq "blog.fpweb.net") { ssh -l root blog.fpweb.net }
    else { write-Host "'$myHost' is not in the list of my known hosts.  Add it to the ssh-to validateset parameter list."}
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
