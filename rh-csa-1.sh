#!/bin/bash
# common checks
printf "Checking system uptime....\t\t"; sleep 1; [[ $(timeUp) == "reboot" ]] && printf "$FAILCOLOR""needs reboot""$ENDCOLOR\n" && printf "\nPlease reboot the system and rerun this script\n\n" && exit 1 || printf "$SUCCESSCOLOR""Good""$ENDCOLOR\n"
printf "Checking hostname....\t\t\t"; sleep 2; [[ $(hostnamectl --static) == "$hostname" ]] && $success  || $failure
printf "Checking for user $username....\t\t"; sleep 2; [[ $(cat /etc/passwd | grep -o -m 1 $username | wc -l) -eq 2 ]] && $success  || $failure
printf "Checking $username's password....\t\t"; sleep 2; [[ $(sudo cat /etc/shadow | grep $username | awk -F: '{print $2}') == $userhash ]] && $success  || $failure
printf "Checking $username's ssh keys\t\t"; sleep 2; [[ $(ls /home/$username/.ssh/$keyname 2>/dev/null | wc -l) -eq 2 ]] && $success  || $failure
printf "Checking $username's sudo rights....\t"; sleep 2; [[ $(sudo id $username | egrep -o "sudo" | wc -w) -eq 1 ]] && $success  || $failure
printf "Checking sshd configs....\t\t"; sleep 2; [[ $(egrep -i "^PasswordAuthentication no$" /etc/ssh/sshd_config) ]] && [[ $(egrep -i "^PubKeyAuthentication yes$" /etc/ssh/sshd_config) ]] && $success  || $failure
printf "Checking /etc/hosts....\t\t\t"; sleep 2; [[ $(grep -Ei "^10.10.10.[23]{1}(.*)RH-CSA-[12]{1}$" /etc/hosts | wc -l) == "2" ]] && $success  || $failure
#printf "Checking repository....\t\t\t"; sleep 2; [[ $(egrep -i " && $success  || $failure
printf "Checking timezone....\t\t\t"; sleep 2; [[ $(timedatectl | egrep -i "^\W+time ?zone" | grep "America/Anchorage" | wc -l) == "1" ]] && $success  || $failure
printf "Checking ntp....\t\t\t"; sleep 2; [[ $(timedatectl | egrep -i "^\W+ntp ?service" | grep -i ": active" | wc -l) == "1" ]] && $success  || $failure

## RH-CSA-1 specific checks
printf "Checing for dd job....\t\t\t"; sleep 2; [[ $(ps aux | grep -v grep | grep "dd if=") ]] && $failure || $success
printf "Checking default pw age....\t\t"; sleep 2; [[ $( egrep -i "^PASS_MAX_DAYS\W+90$" /etc/login.defs | wc -l ) -eq '1' ]] && $success  || $failure
printf "Checking crontab....\t\t\t"; sleep 2; [[ $(journalctl -qxe | grep "Cron job ran at" | wc -l) -gt 0 ]] && $success  || $failure
printf "Checking file links....\t\t\t"; sleep 2; [[ $(diff /home/$username/links/services_copy /etc/services | wc -l) -eq 0 && $(diff /home/$username/links/services_link /etc/services | wc -l) -eq 0 ]] && $success  || $failure
printf "Checking ownership....\t\t\t"; sleep 2; sudo su -c "[[ -O /home/$username/archive ]]" $username && $success || $failure
printf "Checking for 99 dirs/files....\t\t"; sleep 2; [[ $(ls /home/$username/test/* | wc -l) -eq 9998 ]] && $success || $failure
printf "Checking tuned profile....\t\t"; sleep 2; [[ $(tuned-adm active 2>/dev/null) == "Current active profile: virtual-guest" ]] && $success || $failure
printf "Checking persistent logs....\t\t"; sleep 2; [[ $(grep "^Storage=persistent$" /etc/systemd/journald.conf | wc -l) -eq 1 ]] && $success || $failure
printf "Checking syslog for debug logs....\t"; sleep 2; [[ $(grep -R "^*.debug" /etc/rsyslog* | wc -l) -eq 1 ]] && $success || $failure

