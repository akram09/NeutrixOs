
WKDIR="$(pwd)"
# step 5 : creating the necessary foulders in the chroot environment

mkdir -p /usr/share/neutrixOS
mkdir -p /etc/skel/.config
mkdir -p /usr/share/images/desktop-base
mkdir -p /usr/share/icons/default
mkdir -p /usr/share/backgrounds
mkdir -p /usr/local/bin
mkdir -p /usr/share/applications
mkdir -p $WKDIR/neutrixOS/config/hooks/normal
mkdir -p /usr/share/doc/neutrixOS
mkdir -p /etc/skel/Desktop

# create config themes and icons 
mkdir -p /etc/skel/.themes
mkdir -p /etc/skel/.icons

#
# step 6: - Copy files into the chroot
#


# copy themes and icons themes
cp -r $WKDIR/neutrixBuster/themes/* /etc/skel/.themes/
cp -r $WKDIR/neutrixBuster/icon-themes/* /etc/skel/.icons/

# copy deb packages
cp -r $WKDIR/neutrixBuster/thirdParty/* $WKDIR/neutrixOS/config/packages.chroot/

cp -r $WKDIR/neutrixBuster /usr/share/neutrixOS/neutrixBuster
cp -r $WKDIR/neutrixBuster/bootloaders $WKDIR/neutrixOS/config/bootloaders
cp $WKDIR/neutrixBuster/hooks/* $WKDIR/neutrixOS/config/hooks/normal/
cp $WKDIR/neutrixBuster/scripts/* /usr/local/bin/
cp $WKDIR/neutrixBuster/doc/* /usr/share/doc/neutrixOS/
cp $WKDIR/neutrixBuster/backgrounds/* /usr/share/images/desktop-base/
cp $WKDIR/neutrixBuster/backgrounds/* /usr/share/backgrounds/
cp $WKDIR/neutrixBuster/icons/* /usr/share/icons/default/
cp $WKDIR/neutrixBuster/launchers/ezadmin.desktop /usr/share/applications/
ln -s /usr/share/doc/neutrixOS /etc/skel/Desktop/


        # create folder for lightdm config
mkdir -p /etc/lightdm

# create a folder for autostart applications
mkdir -p /etc/skel/.config/autostart

# Packages for xfce  desktop customization
sudo apt install appmenu-gtk-module-common \
    appmenu-gtk2-module appmenu-gtk3-module \
    vala-panel vala-panel-appmenu \
    xfce4-appmenu-plugin libgnome-menu-3-0 \
    gnome-menus synapse \
        numix-gtk-theme greybird-gtk-theme \
    breeze-icon-theme breeze-gtk-theme

        # copy xfce configuratioon files
cp -r $WKDIR/neutrixBuster/xfce4 /etc/skel/.config/xfce4
cp -r $WKDIR/neutrixBuster/plank /etc/skel/.config/plank
cp -r $WKDIR/neutrixBuster/synapse /etc/skel/.config/synapse
        
        # copy startup applications desktop
cp $WKDIR/neutrixBuster/autostart/* /etc/skel/.config/autostart/
        

        #copy lightdm configuration files
cp $WKDIR/neutrixBuster/lightdm/* /etc/lightdm/


#TODO add misc64 deb packages include in the chroot environment

# step 7 starting the build process
lb build

echo "Build starting "
