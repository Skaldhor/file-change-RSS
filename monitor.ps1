# importing variables
Get-Content $PSScriptRoot/FCR.ini | Where-Object {$_.StartsWith("$")} | ForEach-Object {Invoke-Expression "$_" }

# set up file system watcher
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $folder_to_monitor
$watcher.Filter = $file_filter
$watcher.IncludeSubdirectories = $watch_subfolders
$watcher.EnableRaisingEvents = $true

# check if lofile exists and create it if not
if(!(Test-Path $file_change_log)){New-Item -Path $file_change_log -ItemType "file" -Force >$null 2>&1}

# create log with RSS compatible time stamp
$create_log = {
    $path = $Event.SourceEventArgs.FullPath
    $change = $Event.SourceEventArgs.ChangeType
    $date = Get-Date -Format "ddd, dd MMM yyyy HH:mm:ss"
    $log = "$date $timezone;$path;$change"
    Add-content $file_change_log -value $log
}    
# importing defined events to watch
$watchlist = Get-Content $PSScriptRoot/FCR.ini | Where-Object {$_.StartsWith("watch:")}
foreach($line in $watchlist)
{
    $array = $line.Split(":")
    $watch_event = $array[1]
    Register-ObjectEvent -InputObject $watcher -EventName $watch_event -Action $create_log
}

while($true){Start-Sleep 5}
