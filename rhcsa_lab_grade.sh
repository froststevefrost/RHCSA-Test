#!/bin/bash

###############################
#                             #
#  Current as of 15 Dec 2020  #
#                             #
###############################

# Setting colors for results
    SUCCESSCOLOR=$'\033[32;1m'
    FAILCOLOR=$'\033[33;1m'
    ENDCOLOR=$'\033[0m'

# Setting variables to make changes easier in the future
    username='steve'
    userhash='$6$NIG2yNL5twSPoTMO$ke3lXegKbQsB1zaqAIJRctKi9XCxXBnxGnTDQDG8p2fJu6fZt0vgRlwylvVc1.BjlKjt3H9oGNubymSwLwouI1'
    hostname='frost-desk01'
    keyname='id_ed25519*'
    arcFile="/home/$username/archive.txt"
    redirect="redirect-test"
    success="printf "$SUCCESSCOLOR""Success!\\n""$ENDCOLOR""
    failure="printf "$FAILCOLOR""Fail\\n""$ENDCOLOR""
    
# Creating a function to check system uptime
#timeUp() { [[ $(uptime -p | grep -Ev "day[s]*|hour[s]*" | awk '{print $2}') -eq null ]] && echo reboot || echo Good ; }
timeUp() { echo "Good"; }


# Header line
printf "\n\t\033[3;1m\033[31;1mRHCSA\033[0m Grading Script\n\n\033[0m"
printf "\nPlease reboot both systems before grading.\nYou won't have an accurate test if you don't.\n\n"
printf "loading..."
sleep 3

# RH-CSA-1


# RH-CSA-2

# End warning & comments
printf "\n\t$FAILCOLOR""WARNING!""$ENDCOLOR"
printf "\n\tVDO checks are not enabled at this time."
printf "\n\tYou'll need to grade those drives on your own."

printf "\n\n"
