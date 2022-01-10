#!/bin/bash
#
# create tar ball.

# $Id: create_tar.sh 24 2015-03-27 00:53:24Z w0anm $

if [ -z "$1" ] ; then
    version=$(svn info | grep Rev: | awk '{print $4}')
else
    version=$1
fi

REPO=arm_wxscripts
TMP_DIR=/tmp/$REPO
SVN_SRC_DIR=$(pwd)

if [ ! -d /tmp/$REPO ] ; then
    mkdir -p /tmp/$REPO
fi

cd $SVN_SRC_DIR


# run as root

cd ..

cp -rp $SVN_SRC_DIR/*  /tmp/$REPO/.

cd /tmp


# remove unwanted files
rm -rf /tmp/$REPO/.svn
rm -f /tmp/$REPO/create_tar.sh
rm -f /tmp/$REPO/*.tgz
rm -rf /tmp/$REPO/not_available
rm -rf /tmp/$REPO/archive
rm -rf /tmp/$REPO/sandbox
rm -f next_releaseToDo.txt

# fix permissions
chown -R root:root /tmp/$REPO
chmod 755 /tmp/$REPO/src/*

# create compressed tar file
tar zcf ${SVN_SRC_DIR}/arm-wxscripts-0.${version}.tgz -C /tmp  ./$REPO

# create zip file
# zip -r  ${SVN_SRC_DIR}/BBB-wxscripts-0.${version}.zip ./$REPO

rm -rf /tmp/$REPO

cd $SVN_SRC_DIR
chown ckovacs:ckovacs ./*.tgz

echo
echo "Done...":
exit
