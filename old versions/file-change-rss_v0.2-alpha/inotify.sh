#!/bin/bash

# read variables
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source $SCRIPT_DIR/FCR.config 2>/dev/null

# start inotify
inotifywait -mr -e create -e delete -e modify -e move --format "%T;%w%f;%e" --timefmt "%a, %d. %b. %G, %T" $FOLDERTOMONITOR >> $INOTIFY_LOG