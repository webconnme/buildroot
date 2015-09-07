#!/bin/bash
MNTDIR=mnt_disk
TGTDIR=src_ramdisk
USR_ROOTFS=usr_rootfs
RAMDISK_NAME=ramdisk_nxp2120_24M

echo "Create Ramdisk Image 24M Size ..."
dd if=/dev/zero of=$RAMDISK_NAME bs=1k count=24576
losetup    /dev/loop0 $RAMDISK_NAME
mke2fs     /dev/loop0

mkdir -p $MNTDIR
mount -t ext2 -o loop /dev/loop0 $MNTDIR 
#rm -rf src_ramdisk/*
tar xf ../buildroot-2015.05/output/images/rootfs.tar -C $TGTDIR

# file remove
rm -rf $TGTDIR/usr/share/locale 
rm -rf $TGTDIR/webconn/cfg
rm -rf $TGTDIR/webconn/bin
rm -rf $TGTDIR/etc/init.d/S50dropbear
rm -rf $TGTDIR/etc/init.d/S42webconnapp

# file copy
cp -dR $TGTDIR/* $MNTDIR
cp -dR $USR_ROOTFS/* $MNTDIR

umount $MNTDIR
losetup -d /dev/loop0
gzip -f $RAMDISK_NAME
 

