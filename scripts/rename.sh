#!/bin/bash

# old scripts, not good.
# IFS=$'\n'

# if [[ ! -z $1 ]]; then
#     echo $1
#     cd $1
#     echo 'enter $1'
# else
#     echo 'handle local folder'
# fi

# for i in $(ls | grep " - Microsoft OneNote"); do
#     mv $i $(echo $i | awk -F ' - Microsoft OneNote' '{print $1}').md
# done

# unset IFS

for file in $(find . -name "*企业微信截图_*"); do mv $file $(echo $file | sed 's/企业微信截图_//g'); done
for file in $(find . -name "* - Microsoft OneNote*"); do mv $file $(echo $file | sed 's/ - Microsoft OneNote//g'); done

git add *.png
