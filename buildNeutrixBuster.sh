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
echo "task-$DESKTOP_ENV-desktop" >$WKDIR/neutrixOS/config/package-lists/desktop.list.chroot
#
#
# Core Packages
echo less gdebi  \
    psensor synaptic \
    gparted \
    faad faac \
    x265 x264 \
    aisleriot \
    libxvidcore4 \
    p7zip-full \
    p7zip-rar hardinfo \
    gnome-disk-utility  \
    gnome-system-tools \
    dialog \
    rar unrar \
    cifs-utils fuse gvfs-fuse \
    gvfs-backends gvfs-bin pciutils \
    squashfs-tools syslinux \
    syslinux-common dosfstools \
    isolinux fakeroot linux-headers-amd64 \
    lsb-release menu dkms wget iftop \
    apt-transport-https dirmngr \
    libqt5opengl5 \
    firmware-linux \
    firmware-linux-nonfree firmware-misc-nonfree \
    firmware-realtek firmware-atheros firmware-bnx2 \
    firmware-bnx2x firmware-brcm80211 firmware-ipw2x00 \
    firmware-intelwimax firmware-iwlwifi firmware-libertas \
    firmware-netxen firmware-zd1211 > $WKDIR/neutrixOS/config/package-lists/packages.list.chroot
#

# Packages for desktop customization
echo numix-icon-theme-circle \
    appmenu-gtk-module-common \
    appmenu-gtk2-module appmenu-gtk3-module \
    vala-panel vala-panel-appmenu \
    xfce4-appmenu-plugin libgnome-menu-3-0 \
    gnome-menus synapse papirus-icon-theme \
    arc-theme numix-gtk-theme greybird-gtk-theme \
    breeze-icon-theme breeze-gtk-theme >$WKDIR/neutrixOS/config/package-lists/desktop-packages.list.chroot

# Utility
echo plank gnome-dictionary \
    evince okular galculator \
    gnome-chess libreoffice verbiste \
    vlc htop \
    simple-scan remmina neofetch >$WKDIR/neutrixOS/config/package-lists/util-packages.list.chroot

# the apps to install :
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
    >$WKDIR/neutrixOS/config/package-lists/grubuefi.list.binary

# TODO add leafpad
# Education
echo geogebra octave kalgebra > $WKDIR/neutrixOS/config/package-lists/edu-packages.list.chroot


# Browsers
echo chromium  > $WKDIR/neutrixOS/config/package-lists/browser-packages.list.chroot


#enabling Boradcom network drivers
if $ENABLE_BROADCOM_WIRELESS_DRIVERS -eq "true"; then
    echo "Broadcom drivers enabled"
    echo b43-fwcutter \
        firmware-b43-installer \
        firmware-b43legacy-installer \
        >$WKDIR/neutrixOS/config/package-lists/wifidrivers.list.chroots
fi

# Calamares install if specified in the config file
if $CALAMARES_ENABLE -eq "true"; then

    echo calamares \
        calamares-settings-debian \
        >$WKDIR/neutrixOS/config/package-lists/calamares.list.chroot

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
mkdir -p $WKDIR/neutrixOS/config/includes.chroot/usr/share/backgrounds
mkdir -p $WKDIR/neutrixOS/config/includes.chroot/usr/local/bin
mkdir -p $WKDIR/neutrixOS/config/includes.chroot/usr/share/applications
mkdir -p $WKDIR/neutrixOS/config/hooks/normal
mkdir -p $WKDIR/neutrixOS/config/includes.chroot/usr/share/doc/neutrixOS
mkdir -p $WKDIR/neutrixOS/config/includes.chroot/etc/skel/Desktop

# create config themes and icons 
mkdir -p $WKDIR/neutrixOS/config/includes.chroot/etc/skel/.themes
mkdir -p $WKDIR/neutrixOS/config/includes.chroot/etc/skel/.icons

#
# step 6: - Copy files into the chroot
#


# copy themes and icons themes
cp -r $WKDIR/neutrixBuster/themes/* $WKDIR/neutrixOS/config/includes.chroot/etc/skel/.themes/
cp -r $WKDIR/neutrixBuster/icon-themes/* $WKDIR/neutrixOS/config/includes.chroot/etc/skel/.icons/

# copy deb packages
cp -r $WKDIR/neutrixBuster/thirdParty/* $WKDIR/neutrixOS/config/packages.chroot/

cp -r $WKDIR/neutrixBuster $WKDIR/neutrixOS/config/includes.chroot/usr/share/neutrixOS/neutrixBuster
cp -r $WKDIR/neutrixBuster/bootloaders $WKDIR/neutrixOS/config/bootloaders
cp $WKDIR/neutrixBuster/hooks/* $WKDIR/neutrixOS/config/hooks/normal/
cp $WKDIR/neutrixBuster/scripts/* $WKDIR/neutrixOS/config/includes.chroot/usr/local/bin/
cp $WKDIR/neutrixBuster/doc/* $WKDIR/neutrixOS/config/includes.chroot/usr/share/doc/neutrixOS/
cp $WKDIR/neutrixBuster/backgrounds/* $WKDIR/neutrixOS/config/includes.chroot/usr/share/images/desktop-base/
cp $WKDIR/neutrixBuster/backgrounds/* $WKDIR/neutrixOS/config/includes.chroot/usr/share/backgrounds/
cp $WKDIR/neutrixBuster/icons/* $WKDIR/neutrixOS/config/includes.chroot/usr/share/icons/default/
cp $WKDIR/neutrixBuster/launchers/ezadmin.desktop $WKDIR/neutrixOS/config/includes.chroot/usr/share/applications/
ln -s /usr/share/doc/neutrixOS $WKDIR/neutrixOS/config/includes.chroot/etc/skel/Desktop/

case $DESKTOP_ENV in
    "xfce")
        # create folder for lightdm config
        mkdir -p $WKDIR/neutrixOS/config/includes.chroot/etc/lightdm

        # create a folder for autostart applications
        mkdir -p $WKDIR/neutrixOS/config/includes.chroot/etc/skel/.config/autostart
        
        # Packages for xfce  desktop customization
        echo appmenu-gtk-module-common \
            appmenu-gtk2-module appmenu-gtk3-module \
            vala-panel vala-panel-appmenu \
            xfce4-appmenu-plugin libgnome-menu-3-0 \
            gnome-menus synapse \
             numix-gtk-theme greybird-gtk-theme \
            breeze-icon-theme breeze-gtk-theme >$WKDIR/neutrixOS/config/package-lists/desktop-xfce-packages.list.chroot

        # copy xfce configuratioon files
        cp -r $WKDIR/neutrixBuster/xfce4 $WKDIR/neutrixOS/config/includes.chroot/etc/skel/.config/xfce4
        cp -r $WKDIR/neutrixBuster/plank $WKDIR/neutrixOS/config/includes.chroot/etc/skel/.config/plank
        cp -r $WKDIR/neutrixBuster/synapse $WKDIR/neutrixOS/config/includes.chroot/etc/skel/.config/synapse
        
        # copy startup applications desktop
        cp $WKDIR/neutrixBuster/autostart/* $WKDIR/neutrixOS/config/includes.chroot/etc/skel/.config/autostart/
        

        #copy lightdm configuration files
        cp $WKDIR/neutrixBuster/lightdm/* $WKDIR/neutrixOS/config/includes.chroot/etc/lightdm/

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
