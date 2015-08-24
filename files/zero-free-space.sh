#!/bin/bash
# Based off the great "Preparing Linux Template VMs"
# (http://lonesysadmin.net/2013/03/26/preparing-linux-template-vms/) article

# CentOS 6.6
export PREFIX="/sbin"

FileSystem=`grep ext /etc/mtab| awk -F" " '{ print $2 }'`

for i in $FileSystem
do
        echo $i
        number=`df -B 512 $i | awk -F" " '{print $3}' | grep -v Used`
        echo $number
        percent=$(echo "scale=0; $number * 98 / 100" | bc )
        echo $percent
        dd count=`echo $percent` if=/dev/zero of=`echo $i`/zf
        /bin/sync
        sleep 15
        rm -f $i/zf
done

VolumeGroup=`$PREFIX/vgdisplay | grep Name | awk -F" " '{ print $3 }'`

for j in $VolumeGroup
do
        echo $j
        $PREFIX/lvcreate -l `$PREFIX/vgdisplay $j | grep Free | awk -F" " '{ print $5 }'` -n zero $j
        if [ -a /dev/$j/zero ]; then
                cat /dev/zero > /dev/$j/zero
                /bin/sync
                sleep 15
                $PREFIX/lvremove -f /dev/$j/zero
        fi
done

# Make sure we wait until all the data is written to disk
sleep 30
sync
