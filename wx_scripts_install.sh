#!/bin/bash
#
# Install script for Weather scripts for BeagleBone Black
# (for distribution release)
# BBB v0.3
# $Id: wx_scripts_install.sh 23 2015-03-19 03:28:03Z w0anm $

# Dependencies -- Required Packages
PKG_REQ="curl python2 python2-pycurl bc mpg123 sox"

cat << _EOF

This software will be installed under  /usr/local/bin and /usr/local/etc/wx
Additonal directory with sound files will be added to:
    /tmp/wx

This install script is to install the software dependencies, the Text
to Speach Software, and finally the weather scripts. 

This script does not configure the weather scripts.

Do you wish to continue? Control-C to Abort.

_EOF

read dummy
# install missing packages

# sync package repositories
echo "Sync'ing package respositories..."
pacman -Sy
echo


for PKG in $PKG_REQ ; do
    echo "checking for $PKG package..."
    if ! (pacman -Qi $PKG &> /dev/null 2>&1) ; then
        echo "Installing $PKG Package..."
        pacman -S $PKG
    else
        echo "$PKG package is installed..."
        echo "Checking for updates"
        pacman -S --needed $PKG
    fi
    echo

done

if [ ! -d /usr/local/bin ] ; then
    mkdir  -p /usr/local/bin
fi

if [ ! -d /usr/local/bin ] ; then
    mkdir  -p /usr/local/bin
fi

if [ ! -d /usr/local/etc/wx ] ; then
    mkdir  -p /usr/local/etc/wx
fi

if [ ! -d /usr/local/share/doc ] ; then
    mkdir -p /usr/local/share/doc
fi

# remove old directory, just in case
if [ -d /usr/local/bin/Weather ] ; then
    rm -rf /usr/local/bin/Weather
fi

# copying files
echo
echo "Copying Weather scripts to /usr/local/bin..."

# wx alert
cp src/wx_alert/getWxAlert /usr/local/bin/.
cp src/wx_alert/clearWxAlerts /usr/local/bin/.
cp src/wx_alert/enable_wx_alertmsg /usr/local/bin/.
cp src/wx_alert/disable_wx_alertmsg /usr/local/bin/.
cp src/wx_alert/playWxAlertBg /usr/local/bin/.
cp src/wx_alert/sendmail-gm.py /usr/local/bin/.
cp src/wx_alert/sendmail.cfg /usr/local/etc/.sendmail.cfg
cp src/wx_alert/wxtext_conv.sed /usr/local/etc/wx/.
cp src/wx_alert/wx_alert_product.txt /usr/local/etc/wx/.
cp src/wx_alert/wx_critical_alerts.txt /usr/local/etc/wx/.
cp src/wx_alert/wx_normal_alerts.txt /usr/local/etc/wx/.

# wx forecast
cp src/wx_forecast/getWxFor /usr/local/bin/.

# wx report
cp src/wx_report/getWxRpt_ug /usr/local/bin/.
cp src/wx_report/trend /usr/local/bin/.
cp src/wx_report/parsing_list.txt /usr/local/etc/wx/.

# wx config
cp src/wx_config/wx_config.sh /usr/local/bin/.
cp src/wx_config/wx_scripts.conf_tpl /usr/local/etc/wx/.

# remove old file if necessary
if [ -f /usr/local/etc/wx/wx_scripts.conf_NEW ] ; then
    rm -f /usr/local/etc/wx/wx_scripts.conf_NEW
fi

# tts files
cp src/tts/google_tts.py /usr/local/bin/.
cp src/tts/tts_audio.sh /usr/local/bin/.
cp src/tts/tts_info.txt /usr/local/share/doc/.

echo
echo "Please review the README.txt file in this directory for configruation"
echo "setup."
echo

echo "Distribution Installation completed..."
echo

exit 

