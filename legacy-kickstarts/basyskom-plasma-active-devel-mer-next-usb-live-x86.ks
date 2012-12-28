# -*-mic2-options-*- -f livecd -*-mic2-options-*-

#
# Do not Edit! Generated by:
# kickstarter.py
#

lang en_US.UTF-8
keyboard us
timezone --utc Europe/Berlin
part / --size 3000 --ondisk sda --fstype=ext4
rootpw mer
xconfig --startxonboot
bootloader  --timeout=0 --menu="autoinst:Installation:systemd.unit=installer-shell.service"
desktop --autologinuser=mer
user --name mer  --groups audio,video --password mer

#repo --name=ce_tools --baseurl=http://repo.pub.meego.com/CE:/Utils/Mer_Core-next_i586 --save --debug
repo --name=mer-core --baseurl=http://releases.merproject.org/releases/next/builds/i586/packages/ --save
repo --name=mer-shared  --baseurl=http://repo.pub.meego.com/CE:/MW:/Shared/Mer_Core-next_i586/ --save
repo --name=mer-extras --baseurl=http://repo.pub.meego.com/Project:/KDE:/Mer_Extras/CE_MW_Shared_Mer_Core-next_i586/ --save
repo --name=plasma --baseurl=http://repo.pub.meego.com/Project:/KDE:/Devel/Mer_Core-next_CE_UX_PlasmaActive_i586/ --save
repo --name=adaptation-x86-generic --baseurl=http://repo.pub.meego.com/CE:/Adaptation:/x86-generic/Mer_Core-next_i586/ --save

%packages
#custom-kernel
##############
kernel-adaptation-pc

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
openssh-server
libqtwebkit-qmlwebkitplugin
xorg-x11-drv-fbdev
xorg-x11-drv-vesa
xorg-x11-utils-xhost
# get virtualbox running
xorg-x11-server-Xorg-setuid
# FIXME - packages should explicitly depend on it
dbus-x11
libqtdeclarative4-gestures
libdeclarative-multimedia
alsa-utils


# mer-shared repository
#######################
# not needed
# @Nemo Middleware Shared 
# Nemo Middleware Shared defines following packages (06 dec 2011)
# maliit-framework maliit-plugins ohm

# Additional packages from mer-shared repository
gdb
gst-plugins-good
ca-certificates
pulseaudio-policy-enforcement

# mer-extras repository
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
plasma-mobile-config-default-blacklist
bodega-client

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


# adaptation-x86-generic repository
###################################
@Intel x86 Generic Support
#Intel x86 Generic Support defines following packages (08 dec 2011)
# acpid linux-firmware installer-shell xorg-x11-drv-mtev xorg-x11-drv-synaptics
# xorg-x11-drv-intel mesa-dri-i915-driver mesa-dri-i965-driver mesa-libGLESv2
# contextkit-meego-battery-upower
mesa-x86-generic

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


echo "DISPLAYMANAGER=\"uxlaunch\"" >> /etc/sysconfig/desktop


# Create a session file x-plasma-active.desktop
echo "[Desktop Entry]" >> /usr/share/xsessions/x-plasma-active.desktop
echo "Version=1.0" >> /usr/share/xsessions/x-plasma-active.desktop
echo "Name=mtf compositor session" >> /usr/share/xsessions/x-plasma-active.desktop
echo "Exec=/usr/bin/startactive" >> /usr/share/xsessions/x-plasma-active.desktop
echo "Type=Application" >> /usr/share/xsessions/x-plasma-active.desktop

# Set symlink pointing to .desktop file 
ln -sf x-plasma-active.desktop /usr/share/xsessions/default.desktop

# Workaround to enable debug packages
sed -i 's/enabled=0/enabled=1/g' /etc/zypp/repos.d/*.repo

echo "10-pegatron" > /etc/boardname-override
echo "10-pegatron" > /etc/boardname
cp /etc/sensorfw/sensord.conf.d/* /etc/sensorfw/

# kde-security: load the fuse module
#echo "/sbin/modprobe fuse" >> /etc/modprobe.d/dist.conf
mkdir -p /etc/modules-load.d/
echo "fuse" > /etc/modules-load.d/fuse.conf

# work around for maemo6 sensor crash
rm /usr/lib/qt4/plugins/sensors/libqtsensors_meego.so

# Work around for camera
rm /usr/lib/gstreamer-0.10/libgstcamerabin.so

#avoid kernel updates, currently broken
zypper mr -d adaptation-x86-generic

%end

%post --nochroot
if [ -n "" ]; then
    echo "BUILD: " >> /etc/meego-release
fi

%end
