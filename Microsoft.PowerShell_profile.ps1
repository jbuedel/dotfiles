set-alias git "${env:ProgramFiles}\Git\cmd\git.exe"
set-alias bc "${env:ProgramFiles(x86)}\Beyond Compare 4\BComp.exe"

Import-Module posh-git
Import-Module posh-josh -DisableNameChecking
Import-Module project-commands
Import-Module psreadline

Set-Alias -name favorite-text-editor notepad++
Set-Alias -name npp open-text

# I think there is a better way to get to ssh stuff. An environment var, or maybe Pageant.
Set-Alias ssh-agent "${env:ProgramFiles}\Git\usr\bin\ssh-agent.exe"
Set-Alias ssh-add "${env:ProgramFiles}\Git\usr\bin\ssh-add.exe"
Set-Alias ssh "${env:ProgramFiles}\Git\usr\bin\ssh.exe"

Set-Alias -name notepad++ "${env:ProgramFiles(x86)}\notepad++\notepad++.exe"
set-Alias linqpad "${env:ProgramFiles(x86)}\LINQPad4\LINQPad.exe"

Set-Alias st "${env:ProgramFiles(x86)}\Atlassian\SourceTree\SourceTree.exe"
Set-Alias 7z "${env:ProgramFiles}\7-Zip\7z.exe"

# Disable git status caching
$global:GitPromptSettings.StatusCacheSeconds = 0

# Add stuff to path (what's better, adding to path or creating an alias?)
# vim & gvim
$env:Path += ";${env:ProgramFiles(x86)}\vim\bin;"

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

# TODO: Switch to this https://github.com/Microsoft/Git-Credential-Manager-for-Windows
Start-SshAgent -Quiet
$global:GitTabSettings.AllCommands = $false

Pop-Location


# put me in my current project directory
cd ~\Projects\Repos\AMS-GIT\
cd ~\Projects\Repos\Eclipse\src\

# Ungit checks if it's already running and kills itself. No need to check for that here.
#write-host "Launching ungit on Olympus"
#start-job -ScriptBlock { pushd ~\Projects\Olympus ; ungit }

"Your custom settings are almost complete, my overlord."
"You need to add Visual Studio tools to your environment.  Issue either a 'vs2005', 'vs2008', 'vs2010', 'VS2012', or 'vs2013' command to do this."


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
    param([ValidateSet("jbuedel1-pc","buildagent1","dev.fpweb.net","ampdev.net","www1","www2", "mercury.fpweb.net","orchestrator","tickets.fpweb.net","vmm","lansweeper","ams-build-01.amscorp.net", "ams-tfs-01", "test-eclipse-02")][string]$server)

    $the_server = $server # $server can only be one of set values.

    # Note that these are the backup ips.  Not the private ips (which is how the build agent talks to them).
    if($server -eq "www1") { $the_server = "172.27.0.53" }
    if($server -eq "www2") { $the_server = "172.27.0.67" }
	if($server -eq "buildagent1") { $the_server = "204.144.122.42" }
    if($server -eq "orchestrator") { $the_server = "172.27.10.30" }
    if($server -eq "vmm") { $the_server = "172.27.10.10" }
    if($server -eq "lansweeper") { $the_server = "172.27.10.12" }

    Start-RDP -Server $the_server -Fullscreen
}

function ssh-to-known-host {
    param([ValidateSet("fpwebnet@blog.fpweb.net")][string]$myHost)

    if($myHost -eq "fpwebnet@blog.fpweb.net") { ssh fpwebnet@blog.fpweb.net }
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

function toggle-git {
  if (test-path .git) {
    mv .git .gitdisabled
  }
  else {
    if (test-path .gitdisabled) {
    mv .gitdisabled .git
    }
    else {
      echo "No git repository detected. Are you in the repo root?"
    }
  }
}

