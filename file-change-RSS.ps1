#importing variables
Get-Content $PSScriptRoot/FCR.config | Where-Object {$_.StartsWith("$")} | ForEach-Object {Invoke-Expression "$_" }

#creating functions
function RSS_items($date, $path, $event){
Add-Content $tmp_RSS_items "        <item>
            <title>Event $event for file: $path</title>
            <link>file://$path</link>
            <guid>file://$path</guid>
            <pubDate>$date</pubDate>
            <description>Event $event for file: $path from: $date</description>
            <media:thumbnail url=""file://$path""/>
        </item>"
}

#delete existing (if present) and create new empty tmp files
If (Test-Path $tmp_RSS_items) { Remove-Item $tmp_RSS_items -Force }
New-Item -Path $tmp_RSS_items -ItemType "file" -Force >$null 2>&1
If (Test-Path $tmp_inverted_inotify_log) { Remove-Item $tmp_inverted_inotify_log -Force }
New-Item -Path $tmp_inverted_inotify_log -ItemType "file" -Force >$null 2>&1

#inverting inotify log
$log = Get-Content -Path $inotify_log
Add-Content -Path $tmp_inverted_inotify_log -Value ($log[($log.Length-1)..0])

#writing RSS items to tmp_RSS_items file
$input = Get-Content $tmp_inverted_inotify_log

foreach ($line in $input)
{
    $array = $line.Split(";")
    $date = $array[0]
    $path = $array[1]
    $event = $array[2]
    RSS_items $date $path $event
}

#delete existing (if present) and create new final RSS file with header
If (Test-Path $RSS_output_file) { Remove-Item $RSS_output_file -Force }
New-Item -Path $RSS_output_file -ItemType "file" -Force >$null 2>&1


Add-Content $RSS_output_file "<?xml version=""1.0"" encoding=""utf-8""?>
<rss version=""2.0"">
	<channel>
		<title>$channel_name</title>
		<link></link>
		<description>$channel_description</description>"
		
#add items to final RSS file
$items = Get-Content $tmp_RSS_items
Add-Content $RSS_output_file $items

#close remaining RSS tags
Add-Content $RSS_output_file "	</channel>
</rss>"

#delete tmp files
Remove-Item $tmp_RSS_items -Force
Remove-Item $tmp_inverted_inotify_log -Force