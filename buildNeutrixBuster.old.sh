#!/bin/bash
#
# bld neutrixBuster -- Revision: 109r1 -- by neutrix
# (GNU/General Public License version 3.0)
#
# Step by Step Live-Build
#
#
# ~/neutrixOS -- build folder
# ~/neutrixBuster  -- files location
#
#
# Phase 1: - Assign WKDIR variable the output of pwd
#
WKDIR="$(pwd)"
#
#
# Phase 2: - Create the build staging folder
#
mkdir neutrixOS
#
cd neutrixOS
#
#
# Phase 3: - Set up build environment
#
lb config --binary-images iso-hybrid --mode debian --architectures amd64 --linux-flavours amd64 --distribution buster --archive-areas "main contrib non-free" --updates true --security true --cache true --apt-recommends true --debian-installer live --debian-installer-gui true --win32-loader false --iso-application neutrixOS --iso-preparer neutrix-https://sourceforge.net/projects/neutrixos/ --iso-publisher neutrix-https://sourceforge.net/projects/neutrixos/ --iso-volume neutrixOS
#
#
# Phase 4: - Install desktop and applications
#
echo task-xfce-desktop > $WKDIR/neutrixOS/config/package-lists/desktop.list.chroot
# Core Packages
echo less orage gdebi  psensor synaptic gparted bleachbit faad faac mjpegtools x265 x264 mpg321 ffmpeg streamripper dvdauthor lame asunder aisleriot gnome-mahjongg dosbox libxvidcore4 hplip-gui cdrdao frei0r-plugins  jfsutils xfsprogs ntfs-3g cdtool mtools testdisk xorriso cdrskin p7zip-full p7zip-rar keepassx hardinfo inxi gnome-disk-utility  gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-plugins-good gnome-system-tools dos2unix dialog handbrake handbrake-cli python-glade2 rar unrar cifs-utils fuse gvfs-fuse gvfs-backends gvfs-bin pciutils squashfs-tools syslinux syslinux-common dosfstools isolinux fakeroot linux-headers-amd64 lsb-release menu dkms wget iftop apt-transport-https dirmngr libqt5opengl5 zulumount-gui zulucrypt-gui zulupolkit xscreensaver firmware-linux firmware-linux-nonfree firmware-misc-nonfree firmware-realtek firmware-atheros firmware-bnx2 firmware-bnx2x firmware-brcm80211 firmware-ipw2x00 firmware-intelwimax firmware-iwlwifi firmware-libertas firmware-netxen firmware-zd1211 gnome-nettool guvcview > $WKDIR/neutrixOS/config/package-lists/packages.list.chroot


# Packages for desktop customization
echo numix-icon-theme-circle appmenu-gtk-module-common appmenu-gtk2-module appmenu-gtk3-module  vala-panel vala-panel-appmenu xfce4-appmenu-plugin libgnome-menu-3-0 gnome-menus synapse  papirus-icon-theme arc-theme numix-gtk-theme greybird-gtk-theme breeze-icon-theme breeze-gtk-theme > $WKDIR/neutrixOS/config/package-lists/desktop-packages.list.chroot


# Grub And Boot configuration Packages
echo grub-common grub2-common grub-pc-bin efibootmgr grub-efi-amd64 grub-efi-amd64-bin grub-efi-amd64-signed grub-efi-ia32-bin libefiboot1 libefivar1 mokutil shim-helpers-amd64-signed shim-signed-common shim-unsigned > $WKDIR/neutrixOS/config/package-lists/grubuefi.list.binary



#################################################################
#             Third Party Applications
#################################################################

# Packages For different use cases


# Utility
echo plank gnome-dictionary evince okular galculator libreoffice verbiste gnome-chess vlc htop gthumb gimp simplescreenrecorder simple-scan remmina neofetch> $WKDIR/neutrixOS/config/package-lists/util-packages.list.chroot

# TODO add leafpad
# Education
echo geogebra octave kalgebra  codeblocks  > $WKDIR/neutrixOS/config/package-lists/edu-packages.list.chroot

# Browsers
echo chromium falkon  > $WKDIR/neutrixOS/config/package-lists/browser-packages.list.chroot


#
# Uncomment below line include Broadcom wireless drivers
# echo b43-fwcutter firmware-b43-installer firmware-b43legacy-installer  > $WKDIR/neutrixOS/config/package-lists/wifidrivers.list.chroots
#
# Uncomment below line for calamares installer

echo calamares calamares-settings-debian > $WKDIR/neutrixOS/config/package-lists/calamares.list.chroot
#
#
# Phase 5: - Make folders in the chroot
#
mkdir -p $WKDIR/neutrixOS/config/includes.chroot/usr/share/neutrixOS
mkdir -p $WKDIR/neutrixOS/config/includes.chroot/etc/skel/.config
mkdir -p $WKDIR/neutrixOS/config/includes.chroot/etc/skel/.themes
mkdir -p $WKDIR/neutrixOS/config/includes.chroot/etc/skel/.icons
mkdir -p $WKDIR/neutrixOS/config/includes.chroot/usr/share/images/desktop-base
mkdir -p $WKDIR/neutrixOS/config/includes.chroot/usr/share/backgrounds
mkdir -p $WKDIR/neutrixOS/config/includes.chroot/usr/share/icons/default
mkdir -p $WKDIR/neutrixOS/config/includes.chroot/usr/local/bin
mkdir -p $WKDIR/neutrixOS/config/includes.chroot/usr/share/applications
mkdir -p $WKDIR/neutrixOS/config/hooks/normal
mkdir -p $WKDIR/neutrixOS/config/includes.chroot/usr/share/doc/neutrixOS
mkdir -p $WKDIR/neutrixOS/config/includes.chroot/etc/skel/Desktop

# create folder for lightdm config
mkdir -p $WKDIR/neutrixOS/config/includes.chroot/etc/lightdm

# create a folder for autostart applications
mkdir -p $WKDIR/neutrixOS/config/includes.chroot/etc/skel/.config/autostart

#
# Uncomment below line for calamares installer
mkdir -p $WKDIR/neutrixOS/config/includes.chroot/etc/calamares/branding
#
#
# Phase 6: - Copy files into the chroot
#
cp -r $WKDIR/neutrixBuster $WKDIR/neutrixOS/config/includes.chroot/usr/share/neutrixOS/neutrixBuster
cp -r $WKDIR/neutrixBuster/bootloaders $WKDIR/neutrixOS/config/bootloaders
cp -r $WKDIR/neutrixBuster/themes/* $WKDIR/neutrixOS/config/includes.chroot/etc/skel/.themes/
cp -r $WKDIR/neutrixBuster/icon-themes/* $WKDIR/neutrixOS/config/includes.chroot/etc/skel/.icons/

# copy xfce configuratioon files
cp -r $WKDIR/neutrixBuster/xfce4 $WKDIR/neutrixOS/config/includes.chroot/etc/skel/.config/xfce4
cp -r $WKDIR/neutrixBuster/plank $WKDIR/neutrixOS/config/includes.chroot/etc/skel/.config/plank
cp -r $WKDIR/neutrixBuster/synapse $WKDIR/neutrixOS/config/includes.chroot/etc/skel/.config/synapse

# copy startup applications desktop
cp $WKDIR/neutrixBuster/autostart/* $WKDIR/neutrixOS/config/includes.chroot/etc/skel/.config/autostart/
# copy deb packages
cp -r $WKDIR/neutrixBuster/thirdParty/* $WKDIR/neutrixOS/config/packages.chroot/

cp $WKDIR/neutrixBuster/hooks/* $WKDIR/neutrixOS/config/hooks/normal/
cp $WKDIR/neutrixBuster/scripts/* $WKDIR/neutrixOS/config/includes.chroot/usr/local/bin/
cp $WKDIR/neutrixBuster/doc/* $WKDIR/neutrixOS/config/includes.chroot/usr/share/doc/neutrixOS/
cp $WKDIR/neutrixBuster/backgrounds/* $WKDIR/neutrixOS/config/includes.chroot/usr/share/images/desktop-base/
cp $WKDIR/neutrixBuster/backgrounds/* $WKDIR/neutrixOS/config/includes.chroot/usr/share/backgrounds/
cp $WKDIR/neutrixBuster/icons/* $WKDIR/neutrixOS/config/includes.chroot/usr/share/icons/default/
cp $WKDIR/neutrixBuster/launchers/ezadmin.desktop $WKDIR/neutrixOS/config/includes.chroot/usr/share/applications/
ln -s /usr/share/doc/neutrixOS $WKDIR/neutrixOS/config/includes.chroot/etc/skel/Desktop/



#
# Uncomment below three lines for calamares installer
cp $WKDIR/neutrixBuster/calamares/settings.conf $WKDIR/neutrixOS/config/includes.chroot/etc/calamares/settings.conf
cp $WKDIR/neutrixBuster/calamares/usr/share/applications/install-neutrix.desktop $WKDIR/neutrixOS/config/includes.chroot/usr/share/applications/install-neutrix.desktop
cp -r $WKDIR/neutrixBuster/calamares/branding/neutrixos $WKDIR/neutrixOS/config/includes.chroot/etc/calamares/branding/neutrixos
#
#copy lightdm configuration files

cp $WKDIR/neutrixBuster/lightdm/* $WKDIR/neutrixOS/config/includes.chroot/etc/lightdm/



#
#
# Uncomment below line IF you wish to include deb packages from misc64 folder
# cp $WKDIR/neutrixBuster/misc64/* $WKDIR/neutrixOS/config/packages.chroot/
#
#
# Phase 7: - Start the build process
#
lb build
#
# Disclaimer:
#
# THIS SOFTWARE IS PROVIDED BY neutrix “AS IS” AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
# EVENT SHALL neutrix BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
# IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#