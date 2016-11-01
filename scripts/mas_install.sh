#!/bin/bash


mas_results=$(mas search "$1" | head -n1 )
mas_app_name=$(echo "$mas_results" | awk '{for (i=2; i<NF; i++) printf $i " "; print $NF}')

if [ "$mas_app_name" = "$1" ]; then
    mas_app_id=$(echo "$mas_results" | awk '{print $1}')
    mas install "$mas_app_id"
    exit 0
fi

echo "$1 could not be found in the Mac App Store!"
exit 1
