
WKDIR="$(pwd)"
# step 5 : creating the necessary foulders in the chroot environment

mkdir -p -v /usr/share/neutrixOS
mkdir -p -v /etc/skel/.config
mkdir -p -v /usr/share/images/desktop-base
mkdir -p -v /usr/share/icons/default
mkdir -p -v /usr/share/backgrounds
mkdir -p -v /usr/local/bin
mkdir -p -v /usr/share/applications
mkdir -p -v $WKDIR/neutrixOS/config/hooks/normal
mkdir -p -v /usr/share/doc/neutrixOS
mkdir -p -v /etc/skel/Desktop

# create config themes and icons 
mkdir -p -v /etc/skel/.themes
mkdir -p -v /etc/skel/.icons

echo 
#
# step 6: - Copy files into the chroot
#


# copy themes and icons themes
cp -r -f -v $WKDIR/neutrixBuster/themes/* /etc/skel/.themes/
cp -r -f -v $WKDIR/neutrixBuster/icon-themes/* /etc/skel/.icons/

# copy deb packages
cp -r -f -v $WKDIR/neutrixBuster/thirdParty/* $WKDIR/neutrixOS/config/packages.chroot/

cp -r -f -v $WKDIR/neutrixBuster /usr/share/neutrixOS/neutrixBuster
cp -r -f -v $WKDIR/neutrixBuster/bootloaders $WKDIR/neutrixOS/config/bootloaders
cp -r -f -v $WKDIR/neutrixBuster/hooks/* $WKDIR/neutrixOS/config/hooks/normal/
cp -r -f -v $WKDIR/neutrixBuster/scripts/* /usr/local/bin/
cp -r -f -v $WKDIR/neutrixBuster/doc/* /usr/share/doc/neutrixOS/
cp -r -f -v $WKDIR/neutrixBuster/backgrounds/* /usr/share/images/desktop-base/
cp -r -f -v $WKDIR/neutrixBuster/backgrounds/* /usr/share/backgrounds/
cp -r -f -v $WKDIR/neutrixBuster/icons/* /usr/share/icons/default/
cp -r -f -v $WKDIR/neutrixBuster/launchers/ezadmin.desktop /usr/share/applications/
ln -s /usr/share/doc/neutrixOS /etc/skel/Desktop/


        # create folder for lightdm config
mkdir -p -v /etc/lightdm

# create a folder for autostart applications
mkdir -p -v /etc/skel/.config/autostart

# Packages for xfce  desktop customization
sudo apt install appmenu-gtk-module-common \
    appmenu-gtk2-module appmenu-gtk3-module \
    vala-panel vala-panel-appmenu \
    xfce4-appmenu-plugin libgnome-menu-3-0 \
    gnome-menus synapse \
        numix-gtk-theme greybird-gtk-theme \
    breeze-icon-theme breeze-gtk-theme

        # copy xfce configuratioon files
cp -r -f -v $WKDIR/neutrixBuster/xfce4 /etc/skel/.config/xfce4
cp -r -f -v $WKDIR/neutrixBuster/plank /etc/skel/.config/plank
cp -r -f -v $WKDIR/neutrixBuster/synapse /etc/skel/.config/synapse
        
        # copy startup applications desktop
cp -r -f -v $WKDIR/neutrixBuster/autostart/* /etc/skel/.config/autostart/
        

        #copy lightdm configuration files
cp -r -f -v $WKDIR/neutrixBuster/lightdm/* /etc/lightdm/


#TODO add misc64 deb packages include in the chroot environment

# step 7 starting the build process
