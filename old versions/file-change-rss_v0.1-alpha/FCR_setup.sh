#!/bin/bash

#set installation folder for file-change-rss
FILECHANGERSS="/home/pi/file-change-rss"


##### script - do not change #####

#create install-, log- and tmp-folders, if they aren't present already
[ ! -d "$FILECHANGERSS" ] && mkdir $FILECHANGERSS
[ ! -d "$FILECHANGERSS/log" ] && mkdir $FILECHANGERSS/log
[ ! -d "$FILECHANGERSS/tmp" ] && mkdir $FILECHANGERSS/tmp

#download additional files
curl -L https://github.com/Skaldhor/file-change-RSS/releases/download/v0.1-alpha/file-change-RSS.ps1 -o $FILECHANGERSS/file-change-RSS.ps1
curl -L https://github.com/Skaldhor/file-change-RSS/releases/download/v0.1-alpha/inotify.sh -o $FILECHANGERSS/inotify.sh
curl -L https://github.com/Skaldhor/file-change-RSS/releases/download/v0.1-alpha/FCR.config -o $FILECHANGERSS/FCR.config

#make inotify executable
chmod +x $FILECHANGERSS/inotify.sh

#create cron jobs
crontab -l > $FILECHANGERSS/cronjobs
echo '@reboot sleep 60 && screen -dmS filechangerss && screen -S filechangerss -X stuff "'$FILECHANGERSS/inotify.sh'^M"' >> $FILECHANGERSS/cronjobs
echo "*/5 * * * * pwsh $FILECHANGERSS/file-change-RSS.ps1" >> $FILECHANGERSS/cronjobs
crontab $FILECHANGERSS/cronjobs
rm $FILECHANGERSS/cronjobs