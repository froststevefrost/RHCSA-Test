#!/bin/bash
## common checks
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

## RH-CSA-2 specific checks
printf "Checking archive results....\t\t"; sleep 2; [[ ! -w $arcFile && ! -x $arcFile ]] && $success  || $failure
printf "Checking file redirect test....\t\t"; sleep 2; [[ $( cat test/redirect-test | wc -l) -eq 7 ]] && $success  || $failure
printf "Checking redirection results....\t"; sleep 2; [[ $(wc -l /home/steve/$redirect | awk '{print $1}') -eq 7 ]] && $success || $failure
printf "Checking acl settings....\t\t"; sleep 2; cd ; [[ $(getfacl -c test/ | egrep -v "^#.*" | grep "default:user:$username:rw-$" | wc -l) -eq 1 ]] && $success || $failure
printf "Checking vg & lv....\t\t\t"; sleep 2; [[ -b /dev/mapper/myVg-myLv ]] && $success || $failure
printf "Checking for xfs mount....\t\t"; sleep 2; [[ $(mount | grep "/xfsMount") ]] && $success || $failure
printf "Checking for stratis block....\t\t"; sleep 2; [[ $(mount | grep -i stratis | wc -l) -eq 2 && \
    $(egrep "UUID=[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}(.*)requires=stratisd.service\W+0\W+0$" /etc/fstab | wc -l) -eq 2 ]] && $success || $failure
printf "Checking firewall....\t\t\t"; sleep 2; [[ $(firewall-cmd --list-services | egrep -i "^http\W*ssh$") ]] && $success || $failure

