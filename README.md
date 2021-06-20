# file-change-RSS
file-change-RSS creates an RSS feed (xml file) of file changes in a local folder (and subfolders).
You can upload it later onto a webserver to read it with an RSS feed reader.

## Installation
1. Make sure to install all dependencies first, file-change-RSS requires: [powershell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-7.1)  
If you're using linux, make sure to install software for scheduled script execution, for example [cron](https://man7.org/linux/man-pages/man8/cron.8.html) / [crontab](https://man7.org/linux/man-pages/man5/crontab.5.html). You may also want to install [screen](https://man7.org/linux/man-pages/man1/screen.1.html), since the folder monitoring will block the terminal.
2. Download the three files [from the releases](https://github.com/Skaldhor/file-change-RSS/releases/latest) and save them all in the same folder.
3. Open "FCR.ini" with a text editor and make necessary changes to folder paths.
4. Create a scheduled task to run the folder monitoring script once at reboot (monitor.ps1).  
You can use the Windows Task Scheduler for this, or for linux you can create a cron job like:  
`@reboot sleep 60 && screen -dmS fcr && screen -S fcr -X stuff "pwsh /home/pi/FCR/monitor.ps1^M"`  
Make sure to reboot or start the script manually once.
5. Create a scheduled task to create the RSS file (file-change-RSS.ps1) every few minutes (or how often you want it to be updated).  
You can use the Windows Task Scheduler for this, or for linux you can create a cron job like:  
`*/5 * * * * pwsh /home/pi/FCR/file-change-RSS.ps1`
6. Done, your RSS feed xml file will be created/updated at the set interval (at the specified path in the ini file).

## Usage after installation
If you set everything up, there should now be your RSS feed saved at the specified path in the ini file.  
You can then publish the file to a webserver, in order to read it with an RSS feed reader.  
Ideally, you set the RSS output path in the ini file directly to the web server, if it's hosted locally.
