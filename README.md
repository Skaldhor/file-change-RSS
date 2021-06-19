# file-change-RSS
file-change-RSS creates an RSS feed (xml file) of file changes in a local folder (and subfolders) for linux.
You can upload it later onto a webserver to read it with an RSS feed reader.

## Installation
1. Make sure install all dependencies first, file-change-RSS requires:
    1. [curl](https://man7.org/linux/man-pages/man1/curl.1.html)
    2. [cron](https://man7.org/linux/man-pages/man8/cron.8.html) / [crontab](https://man7.org/linux/man-pages/man5/crontab.5.html)
    3. [inotify](https://man7.org/linux/man-pages/man7/inotify.7.html)
    4. [powershell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-7.1)
    5. [screen](https://man7.org/linux/man-pages/man1/screen.1.html)

2. Run this command in order to download the setup "FCR_setup.sh" file to your current directory:  
`curl https://github.com/Skaldhor/file-change-RSS/releases/download/v0.1-alpha/FCR_setup.sh -o FCR.config && chmod +x FCR_setup.sh`  
Alternatively you can download the file manually [from the releases](https://github.com/Skaldhor/file-change-RSS/releases/latest) and move it where you want.

3. **Before running the setup** file open it with a text editor and specify the install folder for file-change-RSS.
All necessary files will be created in this directory.
If you downloaded the setup file manually, make sure to make it executable using:
`chmod +x FCR_setup.sh`
4. run the script:
`./FCR_setup.sh`
5. open "FCR.config" with a text editor and make necessary changes to folder paths (default paths are the home directory of my raspberry pi user)
6. restart the PC/server **or** run the following command (as specified in crontab)
make sure to swap out {your-filechangerss-install-path-here} for your file-change-RSS install folder:  
`screen -dmS filechangerss && screen -S filechangerss -X stuff "{your-filechangerss-install-path-here}/inotify.sh"`
7. Done, your RSS feed xml file will be created/updated every 5 minutes (at the specified path in the config file).

## Usage/explanation
After installation two cronjobs will be created.
Job 1 will run "screen" to create a new screen in the background running inotify.
Inotify watches your specified folder (in the config file) for changes and writes them into a log file (specified in the config file).
Job 2 will run a powershell script every 5 minutes whitch takes the inotify log and converts it to an RSS feed xml file (output specified in the config file).

You can then publish the file to a webserver on your own, in order to read it with an RSS feed reader.
