# importing variables
Get-Content $PSScriptRoot/FCR.ini | Where-Object {$_.StartsWith("$")} | ForEach-Object {Invoke-Expression "$_" }

# creating functions
function New-RssItem($date, $path, $fileEvent){
$url = $protocol + "://" + $pc_addr + "/" + $path
Add-Content $tmp_RSS_items "        <item>
            <title>Event $fileEvent for file: $path</title>
            <link>$url</link>
            <guid>$url</guid>
            <pubDate>$date</pubDate>
            <description>&lt;a href=&quot;$url&quot;&gt; &lt;img src=&quot;$url&quot;&gt;&lt;/a&gt;Following file $fileEvent : $path from: $date</description>
        </item>"
}

# delete existing (if present) and create new empty tmp files
If(Test-Path $tmp_RSS_items){Remove-Item $tmp_RSS_items -Force}
New-Item -Path $tmp_RSS_items -ItemType "file" -Force >$null 2>&1
If(Test-Path $tmp_inverted_log){Remove-Item $tmp_inverted_log -Force}
New-Item -Path $tmp_inverted_log -ItemType "file" -Force >$null 2>&1

# inverting file change log, so the latest entries are on top
$log = Get-Content -Path $file_change_log
[array]::Reverse($log)
Add-Content -Path $tmp_inverted_log -Value $log

# writing RSS items to tmp_RSS_items file
$invLog = Get-Content $tmp_inverted_log

foreach($line in $invLog)
{
    $array = $line.Split(";")
    $date = $array[0]
    $rawPath = $array[1]
    $path = $rawPath.Replace($folders_to_strip, "")
    $fileEvent = $array[2]
    New-RssItem $date $path $fileEvent
}

# delete existing (if present) and create new final RSS file with header
If(Test-Path $RSS_output_file) {Remove-Item $RSS_output_file -Force}
New-Item -Path $RSS_output_file -ItemType "file" -Force >$null 2>&1


Add-Content $RSS_output_file "<?xml version=""1.0"" encoding=""utf-8""?><rss xmlns:atom=""http://www.w3.org/2005/Atom"" version=""2.0"">
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
