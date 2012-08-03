# -*-mic2-options-*- -f livecd -*-mic2-options-*-

#
# Do not Edit! Generated by:
# kickstarter.py
#

lang en_US.UTF-8
keyboard us
timezone --utc Europe/Berlin
part / --size 3000 --ondisk sda --fstype=ext3
rootpw meego
xconfig --startxonboot
bootloader --timeout=0 --append="quiet"
desktop --autologinuser=meego
user --name meego  --groups audio,video --password meego

repo --name=1.2-oss --baseurl=http://repo.meego.com/MeeGo/builds/1.2.0.90/latest/repos/oss/ia32/packages/ --save --debug --gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-meego

repo --name=1.2-non-oss --baseurl=http://repo.meego.com/MeeGo/builds/1.2.0.90/1.2.0.90.12.20110809.2/repos/non-oss/ia32/packages/ --save --debug --gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-meego

repo --name=kde-testing-1.2 --baseurl=http://repo.pub.meego.com/Project:/KDE:/Trunk:/Testing/MeeGo_1.2_OSS/ --save --debuginfo

# Add peregrine repository
repo --name=peregrine --baseurl=http://repo.pub.meego.com/home:/mdfe:/peregrine/Project_KDE_Trunk_Testing_MeeGo_1.2_OSS/ --save --debuginfo

# Add basyskom qml demos repository
repo --name=basyskom-qml-demos --baseurl=http://repo.pub.meego.com/home:/sbinner:/basyskom-qml-demos/Project_KDE_Trunk_Testing_MeeGo_1.2_OSS/ --save --debuginfo

%packages
@MeeGo Core
@MeeGo X Window System
#@MeeGo Tablet
#@MeeGo Tablet Applications
@X for Netbooks
@MeeGo Base Development
@Development Tools


# debugging stuff
# gdb
# kdelibs-debuginfo
# qt-debuginfo
# plasma-mobile-debuginfo
nepomukshell

# Needed devel tools
#qt-devel-tools
synergy

# Add lost font packages
liberation-mono-fonts
fontpackages-filesystem
cjkuni-fonts
droid-serif-fonts
droid-sans-mono-fonts
droid-sans-fonts
liberation-serif-fonts
liberation-sans-fonts
liberation-mono-fonts

# add kde-security packages
encfs
fuse
rlog
sysvinit
sysvinit-tools
libblkid
util-linux


# Add work-a-round to get virtualbox running
xorg-x11-drv-fbdev

# Add work-a-round to get sound umuted by alsaunmute tool
alsa-utils

alsa-plugins-pulseaudio

# add more multimedia samples
sample-media

# Add needed apps
#meego-app-browser
#meego-menus - conflicts now with applications.menu provided by kdelibs-data
# contains directory structure/index.theme
hicolor-icon-theme
# for general icons (eg xterm)
meego-handset-icon-theme

# Add contour stuff
# The contour package activates the recommondations
contour
# contour-demo

startactive
plasma-active-config-blacklist
apper
bangarang
contour-intro
dolphin
plasma-active
plasma-addons
declarative-plasmoids
plasma-mobile-mouse
kde-wallpapers
kde-runtime-desktoptheme
kde-runtime-emoticons
kde-runtime-nepomuk
kde-runtime-newstuff
kde-runtime-netattach
kde-runtime-newstuff
kde-runtime-plasma
kde-runtime-solid
kde-runtime-sounds
kde-runtime-thumbnail-plugins
kde-runtime-wallet
kdelibs-data
kdelibs-imageio-plugins
kdelibs-plasma-runtime
iodbc
#iodbc-admin
virtuoso
virtuoso-drivers
virtuoso-server
kdepim-strigi-plugins
kmix

#prevent conflicts
libthreadweaver
libkdecore
libkfile
libsolid
libkparts
libkio

# games
lskat
katomic
bovo
kfourinline
knetwalk
kshisen
kmahjongg
kpat
kreversi

# required by installdbgsymbols.sh
kdialog
konsole
ksnapshot

# add some simple testing tools
simple-tests

# apps for opening demo files
gwenview
okular
calligra-active
#kate
kwrite
kontact-touch

#calligra-words
#calligra-tables
#calligra-stage
#calligra-karbon
#calligra-krita
#calligra-kexi
#calligra-kthesaurus

# pulls in strigidaemon
#kdepim-runtime-strigifeeder

kernel-adaptation-pinetrail

installer
sensorfw-pegatron
-dsme
-libdsme

# Just needed and available on meego
meego-ux-settings-libsettings
meego-ux-components

# Add some basyskom demos
patientcare
peregrine-tablet-common
smarthome

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

# Add work-a-round to get virtualbox running
chmod u+s /usr/bin/Xorg

# verify link of flash plugin
if [ -f /usr/lib/flash-plugin/setup ]; then
    sh /usr/lib/flash-plugin/setup install
    rm -f /root/oldflashplugins.tar.gz
fi

echo "DISPLAYMANAGER=\"uxlaunch\"" >> /etc/sysconfig/desktop
echo "session=/usr/bin/startactive" >> /etc/sysconfig/uxlaunch
# cursor not needed with plasma-mobile-mouse package installed
echo "xopts=-nocursor" >> /etc/sysconfig/uxlaunch


echo "10-pegatron" > /etc/boardname-override
echo "10-pegatron" > /etc/boardname
cp /etc/sensorfw/sensord.conf.d/* /etc/sensorfw/

# kde-security: load the fuse module
echo "modprobe fuse" >> /etc/rc.local

# Work around for eGalax Touchscreen
cp /etc/X11/xorg.conf.d/60-cando-mtev.conf /etc/X11/xorg.conf.d/60-egalax-mtev.conf
sed -i s/"Cando Multi Touch Panel"/"eGalax Touchscreen"/ /etc/X11/xorg.conf.d/60-egalax-mtev.conf
sed -i s/Cando/eGalax/ /etc/X11/xorg.conf.d/60-egalax-mtev.conf

# Copy boot and shutdown images
cp /usr/share/themes/1024-600-10/images/system/boot-screen.png /usr/share/plymouth/splash.png
cp /usr/share/themes/1024-600-10/images/system/shutdown-screen.png /usr/share/plymouth/shutdown-1024x600.png
# work around for maemo6 sensor crash
rm /usr/lib/qt4/plugins/sensors/libqtsensors_meego.so

# Work around for camera
rm /usr/lib/gstreamer-0.10/libgstcamerabin.so

echo "2012-04-23-16-57-basyskom-plasma-active-testing-meego-usb-live" >> /etc/image-release
echo "" >> /etc/image-release
echo "Initial Packages:" >> /etc/image-release
rpm -qa | sort >> /etc/image-release


%end

%post --nochroot
if [ -n "" ]; then
    echo "BUILD: " >> /etc/meego-release
fi

%end
