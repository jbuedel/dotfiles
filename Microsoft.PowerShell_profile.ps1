set-alias git "${env:ProgramFiles}\Git\cmd\git.exe"
set-alias bc "${env:ProgramFiles(x86)}\Beyond Compare 4\BComp.exe"

#Import-Module posh-git
#$GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true

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

Set-Alias st "${env:LOCALAPPDATA}\SourceTree\SourceTree.exe"
Set-Alias 7z "${env:ProgramFiles}\7-Zip\7z.exe"

Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

. ".\Start-RDP.ps1"


# TODO: Switch to this https://github.com/Microsoft/Git-Credential-Manager-for-Windows
Start-SshAgent -Quiet
$global:GitTabSettings.AllCommands = $false
$global:GitPromptSettings.EnableStashStatus = $true

Pop-Location


# put me in my project directory
cd ~\Projects\ 

# Use vim bindings
Set-PSReadlineOption -EditMode Vi
Set-PSReadlineOption -HistorySearchCursorMovesToEnd


######3
## Sadly, this doesn't work inside Hyper. Only in standard powershell consoles. (I'm thinking hyper doesn't let the ctrL+ cmds filter through.)
######
#
# Ctrl+Shift+j then type a key to mark the current directory.
# Ctrj+j then the same key will change back to that directory without
# needing to type cd and won't change the command line.

#
$global:PSReadlineMarks = @{}

Set-PSReadlineKeyHandler -Key Ctrl+Shift+j `
                         -BriefDescription MarkDirectory `
                         -LongDescription "Mark the current directory" `
                         -ScriptBlock {
    param($key, $arg)

    write-host "in there"

    $key = [Console]::ReadKey($true)
    $global:PSReadlineMarks[$key.KeyChar] = $pwd
}

Set-PSReadlineKeyHandler -Key Ctrl+j `
                         -BriefDescription JumpDirectory `
                         -LongDescription "Goto the marked directory" `
                         -ScriptBlock {
    param($key, $arg)

    $key = [Console]::ReadKey()
    $dir = $global:PSReadlineMarks[$key.KeyChar]
    if ($dir)
    {
        cd $dir
        [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
    }
}

Set-PSReadlineKeyHandler -Key Alt+j `
                         -BriefDescription ShowDirectoryMarks `
                         -LongDescription "Show the currently marked directories" `
                         -ScriptBlock {
    param($key, $arg)

    $global:PSReadlineMarks.GetEnumerator() | % {
        [PSCustomObject]@{Key = $_.Key; Dir = $_.Value} } |
        Format-Table -AutoSize | Out-Host

    [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
}

Set-PSReadlineOption -CommandValidationHandler {
    param([CommandAst]$CommandAst)

    switch ($CommandAst.GetCommandName())
    {
        'git' {
            $gitCmd = $CommandAst.CommandElements[1].Extent
            switch ($gitCmd.Text)
            {
                'cmt' {
                    [Microsoft.PowerShell.PSConsoleReadLine]::Replace(
                        $gitCmd.StartOffset, $gitCmd.EndOffset - $gitCmd.StartOffset, 'commit')
                }
            }
        }
    }
}

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
    param([ValidateSet("jbuedel1-pc","buildagent1","dev.fpweb.net","ampdev.net","www1","www2", "mercury.fpweb.net","orchestrator","tickets.fpweb.net","vmm","lansweeper","ams-build-01.amscorp.net", "ams-tfs-01", "test-eclipse-02.amscorp.net", "demo.amscontrols.com", "pro-beta.amscontrols.com")][string]$server)

    $the_server = $server # $server can only be one of set values.

    # Note that these are the backup ips.  Not the private ips (which is how the build agent talks to them).
    if($server -eq "www1") { $the_server = "172.27.0.53" }
    if($server -eq "www2") { $the_server = "172.27.0.67" }
	if($server -eq "buildagent1") { $the_server = "204.144.122.42" }
    if($server -eq "orchestrator") { $the_server = "172.27.10.30" }
    if($server -eq "vmm") { $the_server = "172.27.10.10" }
    if($server -eq "lansweeper") { $the_server = "172.27.10.12" }
    if($server -eq "demo.amscontrols.com") { $the_server = "demo.amscontrols.com:3389" }
    if($server -eq "pro-beta.amscontrols.com") { $the_server = "pro-beta.amscontrols.com" }

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
# Function not alias because you can't use aliases with pipes.
function whence($name)
{
    Get-Command $name | Select-Object -ExpandProperty Definition
}

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
