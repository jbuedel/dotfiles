Function Write-Utf8([string] $path, [string] $filter='*.*')
{
    $path = (gi $path).FullName
    [IO.SearchOption] $option = [IO.SearchOption]::AllDirectories;
    [String[]] $files = [IO.Directory]::GetFiles($path, $filter, $option);
    foreach($file in $files)
    {
    	"Writing $file...";
    	[String]$s = [IO.File]::ReadAllText($file);
     	[IO.File]::WriteAllText($file, $s, [Text.Encoding]::UTF8);
    }
}

Write-Utf8 . *.cshtml


