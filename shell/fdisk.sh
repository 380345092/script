#!/bin/sh
fdisk /dev/sdc << EOF
n
p



w
EOF
mkfs.xfs /dev/sdc1
mkdir /data01
mount /dev/sdc1 /data01
echo "/dev/sdc1                                /data01                    xfs    defaults        0 0" >> /etc/fstab

