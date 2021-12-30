# importing variables
Get-Content $PSScriptRoot/FCR.ini | Where-Object {$_.StartsWith("$")} | ForEach-Object {Invoke-Expression "$_" }

# creating functions
function RSS_items($date, $path, $fileEvent){
Add-Content $tmp_RSS_items "        <item>
            <title>Event $fileEvent for file: $path</title>
            <link>$protocol//$pc_addr/$path</link>
            <guid>$protocol//$pc_addr/$path</guid>
            <pubDate>$date</pubDate>
            <description>Following file $fileEvent : $path from: $date</description>
            <media:thumbnail url=""$protocol//$pc_addr/$path""/>
        </item>"
}

# delete existing (if present) and create new empty tmp files
If (Test-Path $tmp_RSS_items) { Remove-Item $tmp_RSS_items -Force }
New-Item -Path $tmp_RSS_items -ItemType "file" -Force >$null 2>&1
If (Test-Path $tmp_inverted_log) { Remove-Item $tmp_inverted_log -Force }
New-Item -Path $tmp_inverted_log -ItemType "file" -Force >$null 2>&1

# inverting file change log, so the latest entries are on top
$log = Get-Content -Path $file_change_log
#Add-Content -Path $tmp_inverted_log -Value ($log[($log.Length-1)..0])
[array]::Reverse($log)
Add-Content -Path $tmp_inverted_log -Value $log

# writing RSS items to tmp_RSS_items file
$invLog = Get-Content $tmp_inverted_log

foreach ($line in $invLog)
{
    $array = $line.Split(";")
    $date = $array[0]
    $rawPath = $array[1]
    if($rawPath.Contains("/") -eq $true){$os_type = "Linux"}
    elseif($rawPath.Contains("\") -eq $true){$os_type = "Windows"}
    if($os_type -eq "Linux"){$splitPath = $rawPath.Split("/")}
    elseif($os_type -eq "Windows"){$splitPath = $rawPath.Split("\")}
    if($splitPath[0] -eq ""){$folders_to_strip = $folders_to_strip + 1}
    $strippedPathLength = ($splitPath.Length) - $folders_to_strip
    $first_item = $splitPath.Length - $strippedPathLength
    $path_array = $splitPath[$first_item..($splitPath.Length - 1)]
    $path = $path_array -join "/"
    $fileEvent = $array[2]
    RSS_items $date $path $fileEvent
}

# delete existing (if present) and create new final RSS file with header
If (Test-Path $RSS_output_file) { Remove-Item $RSS_output_file -Force }
New-Item -Path $RSS_output_file -ItemType "file" -Force >$null 2>&1


Add-Content $RSS_output_file "<?xml version=""1.0"" encoding=""utf-8""?>
<rss version=""2.0"" xmlns:media=""http://search.yahoo.com/mrss/"">
	<channel>
		<title>$channel_name</title>
		<link></link>
		<description>$channel_description</description>"
		
# add items to final RSS file
$items = Get-Content $tmp_RSS_items
Add-Content $RSS_output_file $items

# close remaining RSS tags
Add-Content $RSS_output_file "	</channel>
</rss>"

# delete tmp files
Remove-Item $tmp_RSS_items -Force
Remove-Item $tmp_inverted_log -Force