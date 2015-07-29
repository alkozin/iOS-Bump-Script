#!/bin/bash

agvOutput=`agvtool bump -all`

while read line
do
    [[ "$line" =~ .*\/\.\.\/(.*)\".* ]] &&
    filePath=${BASH_REMATCH[1]}
    if [ -n "$filePath" ]
    then
        git add "$filePath"
    else
        if [ -z "$projectName" ]
        then
            [[ "$line" =~ .*of\ project\ (.*)\ to.* ]] &&
            projectName=${BASH_REMATCH[1]}
            git add "$projectName.xcodeproj/project.pbxproj"
        else
            if [ -z "$buildVersion" ]
            then
            [[ "$line" =~ ([0-9]*)\. ]] &&
            buildVersion=${BASH_REMATCH[1]}
            fi
        fi
    fi
done <<<"$agvOutput"

git commit -m "Bump $projectName to $buildVersion"
#git push
exit 0