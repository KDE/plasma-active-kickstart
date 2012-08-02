# -*-mic2-options-*- -f loop --save-kernel -*-mic2-options-*-

#
# Do not Edit! Generated by:
# kickstarter.py
#

lang en_US.UTF-8
keyboard us
timezone --utc Europe/Berlin
rootpw mer
desktop --autologinuser=mer
user --name mer  --groups audio,video --password mer

repo --name=ce-utils --baseurl=http://repo.pub.meego.com/CE:/Utils/Mer_Core_armv7l --save
repo --name=mer-core --baseurl=http://releases.merproject.org/releases/latest/builds/armv7l/packages/ --save
repo --name=mer-core-debuginfo --baseurl=http://releases.merproject.org/releases/latest/builds/armv7l/debug/ --save
repo --name=mer-shared --baseurl=http://repo.pub.meego.com/CE:/MW:/Shared/Mer_Core_armv7l/ --save
repo --name=mer-plasma-shared --baseurl=http://repo.pub.meego.com/CE:/MW:/PlasmaActive/CE_MW_Shared_armv7l/ --save
repo --name=mer-extras --baseurl=http://repo.pub.meego.com/Project:/KDE:/Mer_Extras/Mer_Extras_armv7l/ --save
repo --name=plasma --baseurl=http://repo.pub.meego.com/Project:/KDE:/Devel/CE_UX_PlasmaActive_armv7l/ --save
repo --name=adaptation-archos-gen9 --baseurl=http://repo.pub.meego.com/Project:/KDE:/Mer_Extras:/Adaptation:/Archos-gen9/Project_KDE_Devel_CE_UX_PlasmaActive_armv7l/ --save

%packages
# ce_tools repository
#####################

# mer-core repository
####################

@Mer Core Utils
# connman-test diffutils openssh-clients vim-enhanced tar

@Mer Core
# Mer Core defines following packages (06 dec 2011)
# basesystem bash boardname coreutils deltarpm e2fsprogs file filesystem fontpackages-filesystem
# kbd lsb-release meego-release nss pam passwd prelink procps readline rootfiles rpm setup
# shadow-utils shared-mime-info systemd-sysv time udev usbutils util-linux xdg-user-dirs zypper

@Mer Connectivity
# Mer Connectivity defines following packages (06 dec 2011)
# bluez connman crda iproute iputils net-tools ofono wireless-tools wpa_supplicant

#remove connman
-connman
-connman-test

@Mer Graphics Common
# Mer Graphics Common defines following packages (06 dec 2011)
# cjkuni-fonts droid-sans-fonts droid-sans-mono-fonts droid-serif-fonts liberation-fonts-common
# liberation-mono-fonts liberation-sans-fonts liberation-serif-fonts uxlaunch

@Mer Minimal Xorg
# Mer Minimal Xorg defines following packages (06 dec 2011)
# xorg-x11-server-Xorg xorg-x11-xauth

# Additional packages from mercore repository
cpio
gzip
tar
openssh-server
libqtwebkit-qmlwebkitplugin
xorg-x11-drv-evdev
xorg-x11-drv-fbdev
xorg-x11-drv-vesa
xorg-x11-utils-xhost
mesa-llvmpipe-dri-swrast-driver
# get virtualbox running
xorg-x11-server-Xorg-setuid
# FIXME - packages should explicitly depend on it
dbus-x11
libqtwebkit-qmlwebkitplugin
libqtdeclarative4-gestures
libqtdeclarative4-particles
libdeclarative-multimedia
alsa-utils
upower


# mer-shared repository
#######################
# not needed
# @Nemo Middleware Shared 
# Nemo Middleware Shared defines following packages (06 dec 2011)
# maliit-framework maliit-plugins ohm

# Additional packages from mer-shared repository
gdb
gst-plugins-good
xterm
ca-certificates
pulseaudio-policy-enforcement

# mer-plasma-shared repository
##############################
iodbc

# plasma repository
###################
contour
contour-intro
declarative-plasmoids
kdelibs-data
kdelibs-imageio-plugins
kdelibs-plasma-runtime
kdepim-strigi-plugins
kde-runtime-desktoptheme
kde-runtime-emoticons
kde-runtime-nepomuk
kde-runtime-netattach
kde-runtime-newstuff
kde-runtime-plasma
kde-runtime-solid
kde-runtime-sounds
kde-runtime-wallet
konsole
kmix
plasma-active
plasma-mobile-mouse
startactive
virtuoso
virtuoso-drivers
virtuoso-server
# Required by kde-workspace crash helper tool installdbgsymbols.sh
kdialog
# add some simple testing tools
simple-tests
sample-media
ConsoleKit
ConsoleKit-libs
ConsoleKit-x11
dhclient
libpcap
ModemManager
NetworkManager
NetworkManager-glib
NetworkManager-kde
NetworkManager-kde-libs
plasmoid-networkmanagement

# add kde-security packages
encfs
fuse
rlog

# Games
lskat
katomic
kfourinline
knetwalk
kshisen
kmahjongg
kpat
kreversi


# Apps
bangarang
kwrite


# adaptation-archos-gen9 repository
###################################
alsa-mixer-asound-state-archos-gen9
plasma-mobile-config-archos-gen9
plasma-mobile-config-archos-gen9-blacklist
kernel-adaptation-archos-gen9
pixcir-touch-callibration
xorg-conf-archos-gen9
pm-utils-config-wlan-archos
libwl1271-bin
linux-firmware
archos-udev-rules

# mer-extras repository
#######################
alsa-plugins-pulseaudio
less
strace
xorg-x11-drv-omapfb
xorg-x11-drv-mtev


-okular

%end


%post
# save a little bit of space at least...
rm -f /boot/initrd*

# Prelink can reduce boot time
if [ -x /usr/sbin/prelink ]; then
    /usr/sbin/prelink -aRqm
fi

rm -f /var/lib/rpm/__db*
rpm --rebuilddb



# Create empty initramfs.cpio.lzo for NAND deployment
touch /boot/initramfs.cpio.lzo

# Create a session file x-plasma-active.desktop
echo "[Desktop Entry]" >> /usr/share/xsessions/x-plasma-active.desktop
echo "Version=1.0" >> /usr/share/xsessions/x-plasma-active.desktop
echo "Name=mtf compositor session" >> /usr/share/xsessions/x-plasma-active.desktop
echo "Exec=/usr/bin/startactive" >> /usr/share/xsessions/x-plasma-active.desktop
echo "Type=Application" >> /usr/share/xsessions/x-plasma-active.desktop

# Set symlink pointing to .desktop file 
ln -sf x-plasma-active.desktop /usr/share/xsessions/default.desktop


%end

%post --nochroot
if [ -n "" ]; then
    echo "BUILD: " >> /etc/meego-release
fi

%end
