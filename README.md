# file-change-RSS
file-change-RSS creates an RSS feed (xml file) of file changes in a local folder (and subfolders) for linux.
You can upload it later onto a webserver to read it with an RSS feed reader.

## Installation
Run this command in order to download the installation file to your current directory:

Alternatively you can download the file manually and move it where you want.

1. **Before running the setup** file open it with a text editor and specify the install folder for file-change-RSS.
All necessary files will be created in this directory.
If you downloaded the setup file manually, make sure to make it executable using:
`chmod +x FCR_setup.sh`
2. run the script:
`./FCR_setup.sh`
3. open "FCR.config" with a text editor and make necessary changes to folder paths (default paths are the home directory of my raspberry pi user)
4. restart the PC/server **or** run the following command (as specified in crontab)
make sure to swar out {your-filechangerss-install-path-here} for your file-change-RSS install folder:  
`screen -dmS filechangerss && screen -S filechangerss -X stuff "{your-filechangerss-install-path-here}/inotify.sh"`

## Usage/explanation
After installation two cronjobs will be created.
Job 1 will run "screen" to create a new screen in the background running inotify.
Inotify watches your specified folder (in the config file) for changes and writes them into a log file (specified in the config file).
Job 2 will run a powershell script every 5 minutes whitch takes the inotify log and converts it to an RSS feed xml file (output specified in the config file).

You can then publish the file to a webserver on your own, in order to read it with an RSS feed reader.
