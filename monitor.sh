#!/bin/bash

monitor() {
    current_day="$(date '+%d')"
    current_file="$(date '+%d-%m-%Y_%H-%M-%S').csv"
    while true
    do
        if [ "$(date '+%d')" != $current_day ]
        then
            current_day="$(date '+%d')"
            current_file="$(date '+%d-%m-%Y_%H-%M-%S').csv"
        fi
        info="$(date '+%H-%M-%S')"
        info="$info,$(df --output=iavail / | tail -n 1)"
        echo $info >> $current_file
        sleep 120
    done
}

if [[ -z $1 ]];
then
    echo "You should pass script parameter (START|STOP|STATUS)"
elif [ $1 != "START" ] && [ $1 != "STOP" ] && [ $1 != "STATUS" ];
then
    echo "Unsupported parameter: $1"
elif [ $1 != "START" ] && [[ -z $1 ]];
then
    echo "You should pass PID to get status or to stop monitoring"
elif [ $1 == "START" ];
then
    monitor &
    echo $!
elif [ $1 == "STOP" ];
then
    kill $2
elif [ $1 == "STATUS" ];
then
    if [[ -z $(ps -a | grep $2) ]];
    then
        echo "$2 IS STOPPED"
    else
        echo "$2 IS RUNNING"
    fi
fi
