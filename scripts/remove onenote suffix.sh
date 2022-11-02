#!/bin/bash

IFS=$'\n'

if [[ ! -z $1 ]]; then
    echo $1
    cd $1
    echo 'enter $1'
else
    echo 'handle local folder'
fi

for i in $(ls | grep " - Microsoft OneNote"); do
    mv $i $(echo $i | awk -F ' - Microsoft OneNote' '{print $1}').md
done

unset IFS
