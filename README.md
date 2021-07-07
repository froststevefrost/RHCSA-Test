# RHCSA-Test
Files for practicing RHCSA exam

These tasks are based on the competencies that Red Hat has set forth.
All files, test, labs, etc were handcrafted by myself.

The RHCSA Competencies for RHEL8 are included in the "rhcsa_competencies" file.

Follow the instructions in the file "rhcsa_rubric".


These files are untested and should be considered as an "alpha" release. Use at your own risk.

# Lab Setup:

#### Create three vms:

  - RH-Wkstn (Workstation w/ GUI)
  - RH-CSA-1 (Server w/ no GUI)
  - RH-CSA-2 (Server w/ no GUI)

#### Set grub time out to be longer on the two servers to make it easier to fix issues:
```
# sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=30/' /etc/default/grub
# grub2-mkconfig -o /boot/grub2/grub.cfg
```

#### Create a CPU hog on RH-CSA-1:
```
# dd if=/dev/zero of=/dev/null &
```

#### Add three spare hdds to RH-CSA-2:
  - Two with 2G
  - One with 5G

#### Create "rhat" user on RH-Wkstn, passwd rhat to Redhat123:
```
# useradd rhat
# passwd rhat
```
#### RH-CSA-1 should have a bad root password of NotAgoodOne:
```
# passwd
```
#### RH-CSA-2 root password is Redhat123:
```
# passwd
```
#### RH-CSA-1 should boot into graphical.target:
```
# systemctl set-default graphical.target
```

#### RH-CSA-2 should have a corrupt fstab:
```
# echo '/fake/drive  /fake/mount nfs defaults    0 0' >> /etc/fstab
```

#### Set timezone to America/Jamaica on both:
```
# timedatectl set-timezone America/Jamaica
```

#### Set RH-CSA-1's tuned profile to be "Desktop":
```
# tuned-adm profile desktop
```

#### create index.html on RH-CSA-2:
``` 
# echo "This is the content of the web server. Congrats!" > index.html
# tar -cvjf containers.tar.bzip2 index.html
# rm index.html
```
