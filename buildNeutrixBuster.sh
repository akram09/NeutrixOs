#!/bin/bash

# build neutrixOS with live-build 

#build steps : 

#step 1 : setting workdir var 
WKDIR=$(pwd)

#sourcing the config file
. ./neutrixBuild.conf

#step 2 : 
#
mkdir neutrixOS
#
cd neutrixOS
#
#

#step 3 : setting up the CONFIG for live-build env 

lb config --binary-images iso-hybrid \
            --mode debian \
            --architectures amd64 \
            --linux-flavours amd64 \
            --distribution buster \
            --archive-areas "main contrib non-free" \
            --updates false \
            --security false \
            --cache true \
            --debian-installer live \
            --debian-installer-gui true \
            --win32-loader false \
            --iso-application neutrixOS \
            --iso-preparer neutrix-https://sourceforge.net/projects/neutrixos/ \
            --iso-publisher neutrix-https://sourceforge.net/projects/neutrixos/ \
            --iso-volume neutrixOS \
            --memtest none \
            --hdd-size 6 \
            --apt-recommends true \
            --apt-secure false \
            --binary-images iso


#
#step 4 : installing the selected desktop environment and the applications 
#
echo "task-$DESKTOP_ENV-desktop" > $WKDIR/neutrixOS/config/package-lists/desktop.list.chroot
#
#
# the apps to install : 

echo haveged less \
        orage gdebi \
        galculator grsync \
        psensor synaptic \
        gparted bleachbit \
        flac faad \
        faac mjpegtools \
        x265 x264 \
        mpg321 ffmpeg \
        streamripper sox \
        mencoder dvdauthor \
        twolame lame \
        asunder aisleriot \
        gnome-mahjongg gnome-chess \
        dosbox libxvidcore4 \
        vlc \
        cdrdao frei0r-plugins \
        htop jfsutils \
        xfsprogs ntfs-3g \
        cdtool mtools \
        gthumb gimp \
        testdisk numix-gtk-theme \
        greybird-gtk-theme breeze-icon-theme \
        breeze-gtk-theme xorriso \
        cdrskin p7zip-full \
        p7zip-rar keepassx hardinfo \
        inxi gnome-disk-utility \
        simplescreenrecorder chromium \
        simple-scan remmina arc-theme \
        gstreamer1.0-plugins-bad \
        gstreamer1.0-plugins-ugly \
        gstreamer1.0-plugins-good \
        gnome-system-tools \
        dos2unix dialog papirus-icon-theme \
        transmission-gtk handbrake \
        handbrake-cli python-glade2 \
        rar unrar cifs-utils fuse \
        gvfs-fuse gvfs-backends \
        gvfs-bin pciutils \
        squashfs-tools \
        syslinux \
        syslinux-common \
        dosfstools \
        isolinux fakeroot \
        linux-headers-amd64 \
        lsb-release menu \
        dkms wget iftop \
        apt-transport-https \
        dirmngr openvpn \
        network-manager-openvpn \
        openvpn-systemd-resolved \
        libqt5opengl5 zulumount-gui \
        zulucrypt-gui zulupolkit \
        neofetch xscreensaver \
        firmware-linux \
        firmware-linux-nonfree \
        firmware-misc-nonfree \
        firmware-realtek \
        firmware-atheros \
        firmware-bnx2 \
        firmware-bnx2x \
        firmware-brcm80211 \
        firmware-ipw2x00 \
        firmware-intelwimax \
        firmware-iwlwifi \
        firmware-libertas \
        firmware-netxen \
        firmware-zd1211 \
        gnome-nettool \
        guvcview > $WKDIR/neutrixOS/config/package-lists/packages.list.chroot
#

# boot apps to install : 
echo grub-common \
        grub2-common \
        grub-pc-bin \
        efibootmgr \
        grub-efi-amd64 \
        grub-efi-amd64-bin \
        grub-efi-amd64-signed \
        grub-efi-ia32-bin \
        libefiboot1 \
        libefivar1 \
        mokutil \
        shim-helpers-amd64-signed \
        shim-signed-common \
        shim-unsigned \
        > $WKDIR/neutrixOS/config/package-lists/grubuefi.list.binary


#enabling Boradcom network drivers
if $ENABLE_BROADCOM_WIRELESS_DRIVERS -eq "true" ;
then 
    echo "Broadcom drivers enabled"
    echo b43-fwcutter \
    firmware-b43-installer \
    firmware-b43legacy-installer  \
    > $WKDIR/neutrixOS/config/package-lists/wifidrivers.list.chroots
fi

# Calamares install if specified in the config file 
if $CALAMARES_ENABLE -eq "true" ;
then 

    echo calamares \
    calamares-settings-debian \
    > $WKDIR/neutrixOS/config/package-lists/calamares.list.chroot

    mkdir -p $WKDIR/neutrixOS/config/includes.chroot/etc/calamares/branding

    cp $WKDIR/neutrixBuster/calamares/settings.conf \
        $WKDIR/neutrixOS/config/includes.chroot/etc/calamares/settings.conf

    cp $WKDIR/neutrixBuster/calamares/usr/share/applications/install-debian.desktop \
        $WKDIR/neutrixOS/config/includes.chroot/usr/share/applications/install-debian.desktop

    cp -r $WKDIR/neutrixBuster/calamares/branding/neutrixos \
        $WKDIR/neutrixOS/config/includes.chroot/etc/calamares/branding/neutrixos

fi 

# step 5 : creating the necessary foulders in the chroot environment 

mkdir -p $WKDIR/neutrixOS/config/includes.chroot/usr/share/neutrixOS
mkdir -p $WKDIR/neutrixOS/config/includes.chroot/etc/skel/.config
mkdir -p $WKDIR/neutrixOS/config/includes.chroot/usr/share/images/desktop-base
mkdir -p $WKDIR/neutrixOS/config/includes.chroot/usr/share/icons/default
mkdir -p $WKDIR/neutrixOS/config/includes.chroot/usr/local/bin
mkdir -p $WKDIR/neutrixOS/config/includes.chroot/usr/share/applications
mkdir -p $WKDIR/neutrixOS/config/hooks/normal
mkdir -p $WKDIR/neutrixOS/config/includes.chroot/usr/share/doc/neutrixOS
mkdir -p $WKDIR/neutrixOS/config/includes.chroot/etc/skel/Desktop



#
# step 6: - Copy files into the chroot
#
cp -r $WKDIR/neutrixBuster $WKDIR/neutrixOS/config/includes.chroot/usr/share/neutrixOS/neutrixBuster
cp -r $WKDIR/neutrixBuster/bootloaders $WKDIR/neutrixOS/config/bootloaders
cp $WKDIR/neutrixBuster/hooks/* $WKDIR/neutrixOS/config/hooks/normal/
cp $WKDIR/neutrixBuster/scripts/* $WKDIR/neutrixOS/config/includes.chroot/usr/local/bin/
cp $WKDIR/neutrixBuster/doc/* $WKDIR/neutrixOS/config/includes.chroot/usr/share/doc/neutrixOS/
cp $WKDIR/neutrixBuster/backgrounds/* $WKDIR/neutrixOS/config/includes.chroot/usr/share/images/desktop-base/
cp $WKDIR/neutrixBuster/icons/* $WKDIR/neutrixOS/config/includes.chroot/usr/share/icons/default/
cp $WKDIR/neutrixBuster/launchers/ezadmin.desktop $WKDIR/neutrixOS/config/includes.chroot/usr/share/applications/
ln -s /usr/share/doc/neutrixOS $WKDIR/neutrixOS/config/includes.chroot/etc/skel/Desktop/


case $DESKTOP_ENV in
        "xfce")
            cp -r $WKDIR/neutrixBuster/xfce4 $WKDIR/neutrixOS/config/includes.chroot/etc/skel/.config/xfce4

            ;;
        "lxqt")
                #stuff to do is lxqt
            ;;
        
         "lxqt")
                #stuff to do is gnome 
            ;;
esac


#TODO add misc64 deb packages include in the chroot environment 



# step 7 starting the build process
lb build

echo "Build starting "
