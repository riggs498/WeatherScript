#!/bin/bash
#
# wx_config.sh - allstar wxscripts
#
#  by w0anm
#
# This script configures the wx scripts and creates a wx_scripts.conf file
#
######################
# $Id: wx_config.sh 27 2015-05-11 02:07:28Z w0anm $

###
# Add wx_script.conf info on metric/press/percp

WEATHER=/usr/local/etc/wx
MODULE_INS=no

IFS=$(echo -en "\n\b")

# functions
# ckyorn function with defaults
ckyorn () {
    return=0
    if [ "$1" = "y" ] ; then
        def="y"
        sec="n"
    else
        def="n"
        sec="y"
    fi

    while [ $return -eq 0 ]
    do
        read -e -p "([$def],$sec): ? " answer
        case "$answer" in
                "" )    # default
                        printf "$def"
                        return=1 ;;
        [Yy])   # yes
                        printf "y"
                        return=1
                        ;;
        [Nn] )   # no
                        printf "n"
                        return=1
                        ;;
                   *)   printf "    ERROR: Please enter y, n or return.  " >&2
                        printf ""
                        return=0 ;;
        esac
    done

}

###################################################


wxAlertSetup () {

    clear
    cat << _EOF
----------------------------------------------------------------------
Weather Alert Setup

You will need to have the NWS County number information to setup the Weather
Alerts.  Refer to the following URL:

    http://www.weather.gov/alerts

Select the "Warnings By State" under "Active Alerts". Select the County List
listed by the desired state.  You will see the "County Code", now pick from the
various State Counties displayed and write this "County Code" down for reference.

For example, under Minnesota you will find - Wright. The County Code for
this county is  MNC171. If you want to be alerted on multiple areas, make a
note of those counties and you can re-execute the script and enter the
additional counties.

_EOF

    # enter NWS County number
    echo
    echo    "Please enter the National Weather Service County for your area"
    echo -n "  (for example, MNC171): "
    read var_tmp
    NWS_COUNTY="`echo \$var_tmp | tr '[:lower:]' '[:upper:]'`"



    echo
    echo -n "Entry your county name: "
    read COUNTY_NAME

    # save old cron file

    # setup crontab entry for new entry
    #check if entry is present, if so, skip.

    echo
    echo "     Checking/Adding crontab entry for user root..."
    echo
    if ( ! crontab -l | grep $NWS_COUNTY ) ; then

        echo "    Adding crontab entry..."

        # create crontab enties
        cat  > crontab_entry << _EOF
# NWS Alert for $NWS_COUNTY in $COUNTY_NAME
2,16,30,44 * * * * (/usr/local/bin/getWxAlert $NWS_COUNTY "$COUNTY_NAME" &> /dev/null 2>&1)

_EOF

        # append entry to cron
        # now append this file to the crontab entry
        crontab -l -u root | cat - crontab_entry  > new_cron
        crontab -u root new_cron
        # cleanup
        rm -f crontab_entry new_cron
        echo "    Entry Added..."
        echo
        WX_ALERT=yes
        MODULE_INS=yes
    else
        echo
        echo "Crontab already has entry for ${NWS_COUNTY}.. (see above)"
        echo
        WX_ALERT=no
    fi

    echo "--------"
    echo -n "Press any key to continue..."
    read ANS

}

wxReportSetup () {

    clear
    cat << _EOF
----------------------------------------------------------------------
Weather Underground Report Setup

You will need to have the Underground Weather station ID information prior
to running this script. Refer to the URL below:
    http://www.wunderground.com/wundermap/

Browse the map for your local area. You will see the Station ID's of various
weather stations. Once you select one on the map, you will find the station ID.
This will be begin K, then two letter state abbreviation, and location. For
example:
example:

      KMNROGER1

When selecting the desired station and review the captured information to make
sure that this has all of the values you want to capture. For example, some
stations do not include precipitation. I prefer the “rapid fire” stations
since they update most frequently. You will use the “Station ID” for the
configuration file.

For more information, refer to:
    http://www.w0anm.com/dokuwiki/doku.php?id=irlp:wx_scripts_doc

_EOF


    echo    "Please enter the Underground Weather Station ID"
    echo -n "  (for example, KMNROGER1): "
    read var_tmp

    UG_STN_N="`echo \$var_tmp | tr '[:lower:]' '[:upper:]'`"

    #check if entry is present, if so, skip.

    echo
    echo "     Checking/Adding crontab entry for user root..."
    echo
    if ( ! crontab -l | grep $UG_STN_N ) ; then

        echo "    Adding crontab entry..."

        # create crontab enties
        cat  > crontab_entry << _EOF
# Underground Weather for station: $UG_STN_N
3,18,31,48 * * * * (/usr/local/bin/getWxRpt_ug $UG_STN_N &> /dev/null 2>&1)

# Underground Weather (pressure trends) for station: $UG_STN_N
0 */6 * * * (/usr/local/bin/trend $UG_STN_N &> /dev/null 2>&1)

_EOF

        # now append this file to the crontab entry
        crontab -l -u root | cat - crontab_entry  > new_cron
        crontab -u root new_cron
        # cleanup
        rm -f crontab_entry new_cron
        echo "    Entry Added..."
        echo
        WX_REPORT=yes
        MODULE_INS=yes
    else
        echo
        echo "Crontab already has entry for ${UG_STN_N}.. (see above)"
        echo
        WX_REPORT=no
    fi

    echo "--------"
    echo -n "Press any key to continue..."
    read ANS
}


wxForecastSetup () {
    clear
    cat << _EOF
----------------------------------------------------------------------
Weather Forecast Setup

You will need to have the NWS Weather Zone ID information prior to running this script.

Refer to the following URL:

    http://www.weather.gov/alerts

Select the "Warnings By State" under "Active Alerts". Select the "Zone List"
listed by the desired state.  You will see the "Zone Code", now pick from the
various State Counties displayed and write this Zone Code down for reference.

For example, Under Minnesota you will find - Wright. The Zone Code for
this county is  MNZ059. If you want to to have forecast for other areas,
make a note of those counties and you can re-execute the script and enter the
additional counties.

_EOF


    echo
    echo    "Please enter the NWS Zone forecast ID "
    echo -n "  (for example, MNZ059): "
    read var_tmp
    NWS_ZONE="`echo \$var_tmp | tr '[:lower:]' '[:upper:]'`"

    #check if entry is present, if so, skip.

    echo
    echo "     Checking/Adding crontab entry for user root..."
    echo
    if ( ! crontab -l | grep $NWS_ZONE ) ; then

        echo "    Adding crontab entry..."

        # create crontab enties
        cat  > crontab_entry << _EOF
# National Wx Service Forecast based on Zone: $NWS_ZONE
5,21,41 * * * * (/usr/local/bin/getWxFor $NWS_ZONE &> /dev/null 2>&1)

_EOF

        # now append this file to the crontab entry
        crontab -l -u root | cat - crontab_entry  > new_cron
        crontab -u root new_cron
        # cleanup
        rm -f crontab_entry new_cron
        echo "    Entry Added..."
        echo
        WX_FORECAST=yes
        MODULE_INS=yes
    else
        echo
        echo "Crontab already has entry for ${NWS_ZONE}.. (see above)"
        echo
        WX_FORECAST=no
    fi

    echo "--------"
    echo -n "Press any key to continue..."
    read ANS
}

dtmf_sequence () {
    dtmf_type=$1

    if [ "$RPT_STANZA" = "DIRECT" ] ; then
        RPT_FILE=/etc/asterisk/rpt.conf
    else
        RPT_FILE=/usr/local/etc/asterisk_tpl/rpt.conf_tpl
    fi

    OK=1
    while [ "$OK" = "1" ] ; do
        echo -n "Input dtmf sequence for $dtmf_type :"
        read DTMF_SEQ
        if (grep "^${DTMF_SEQ}" ${RPT_FILE}) ; then
            echo "sequence already used..."
            OK=1
        else
            #echo "${DTMF_SEQ}"
            OK=0
        fi
    done
}



## end of functions
########################################################################
## main

clear
cat << _EOF
    Weather configuration script...

 ============================================================================
|                            IMPORTANT NOTICE!                               |
|                                                                            |
| No matter what the Weather Alerts are  indicating, the information         |
| gathered and presented here may NOT be accurate. You MUST use your own     |
| judgement to determine your best course of action in any given             |
| circumstance! The are many reasons WHY the data here may not be accurate,  |
| including, but not limited to, software problems, network problems, and or |
| hardware problems. The Weather Alerts and other Weather information should |
| NOT be used to make any determination of actual current conditions, it is  |
| merely an indication of what the software is seeing as a result of it's    |
| attempts to read publicly available data sources.  These data sources may  |
| be unavailable, unreachable, or inaccurate. Please check other sources to |
| verify any information presented here.                                     |
 ============================================================================

_EOF

echo -n "Do you understand and acknowledge the above notice " ; ANS=$(ckyorn n)
if [ "$ANS" = "n" ] ; then
    exit 0
fi

# select the scripts to be installed
clear
cat  << _EOF
----------------------------------------------------------------------
Weather Scripts

This program will configure your node to gather weather information base upon
the NWS and Weather Underground web sites.  You can configure Weather Alerts,
Weather Forecasts, and current local Weather Underground weather station
reports. You can select all of these options or just the ones you want to use.

You will be prompted for entering various information that the Weather Scripts
use to gather information.  You can run this script as many times as you wish
to setup alerts, forecasts, and local weather reporting.

----------------------------------------------------------------------
_EOF
echo "Do you wish to setup, reconfigure, or add additional reporting area's for"
echo -n "the weather scripts (answering 'n' will exit script): "

ANS=$(ckyorn y)
if [ "$ANS" = "n" ] ; then
    exit 0
fi

clear
cat  << _EOF
----------------------------------------------------------------------
Weather Alert Scripts

These scripts will allow you to get short alert messages via your node audio.
Various Alert criteria can be specified such as Winter Advisories, Tornado
Warnings, etc. Please refer to documentation for further information.

----------------------------------------------------------------------
_EOF

echo "Do you wish to add or add additional county weather alerts to your"
echo -n "node: " ; ANS=$(ckyorn n)

if [ "$ANS" = "y" ] ; then wxAlertSetup ; fi

# do you want weather reports?
clear
cat  << _EOF
----------------------------------------------------------------------
Underground Weather Report Scripts

These scripts will to get current weather conditions based upon downloaded
Weather Underground station information. This information is then available
to you by entering a DTMF sequence to announce the weather conditions via
your node audio.

----------------------------------------------------------------------
_EOF

echo -n "Do you wish to add or add additional weather reports: " ; ANS=$(ckyorn n)
if [ "$ANS" = "y" ] ; then wxReportSetup ; fi

# do you want weather forecasts?
clear
cat << _EOF
----------------------------------------------------------------------
Weather Forecast Scripts

This script will allow you to get your NWS weather forecast messages based
upon downloaded NWS zone information. This information then is available
to you by entering a DTMF sequence to announce the weather forecast via
your node audio.

----------------------------------------------------------------------
Do you wish to add or add additional weather forecasts:
_EOF

ANS=$(ckyorn n)
if [ "$ANS" = "y" ] ; then wxForecastSetup ; fi

# verify the selections and information

if [ -f $WEATHER/wx_scripts.conf ] ; then

   clear
   cat << _EOF
----------------------------------------------------------------------
Script Configuration

   The scripts have already been configured. If you choose, you can change
   your weather configurations. this selection allows you to change the
   audio volue, weather units of measure (metric/us), and email (Gmail)
   support.

----------------------------------------------------------------------
_EOF

    echo -n "Do you want to reconfigure the weather scripts " ; ANS=$(ckyorn n)
    echo
    if [ "$ANS" = "n" ]  ; then
        RECONF=no
    else
        RECONF=yes
        cp $WEATHER/wx_scripts.conf $WEATHER/wx_scripts.conf_SAVE
    fi
else
   clear
   cat << _EOF
----------------------------------------------------------------------
Script Configuration

   The wx scripts will need to configure your node settings such as units
   of meassure, audio volume, email support.

----------------------------------------------------------------------
_EOF

    RECONF=yes
fi

# setup the wx_configuration script, if needed.
if [ "$RECONF" = yes ] ; then

    if [ -f $WEATHER/wx_scripts.conf ] ; then
        source $WEATHER/wx_scripts.conf
    else
        WXVOL="3"
        UNITS=US
        PRES_UNITS=IN
        RAIN_UNITS=IN
    fi

    # make working copy
    cp $WEATHER/wx_scripts.conf_tpl /tmp/wx_scripts.tmp

    CUR_VOL=$WXVOL

    echo -n "Enter the volume setting for ulaw files [$CUR_VOL] :"
    read ANS
    if [ -z "$ANS" ]; then
        WXVOL=$CUR_VOL
    else
        WXVOL=$ANS
    fi

    # Vol, change the WXVOL in the wx_scripts.tmp file
    sed "s/_WXVOL_/${WXVOL}/g" /tmp/wx_scripts.tmp > /tmp/wx_scripts.tmp1
    mv /tmp/wx_scripts.tmp1 /tmp/wx_scripts.tmp

    # Configure wx_config.conf file
    # (wxalert beacon, report output - metric or US units)

    # check if configured by looking at cron entries. if not, skip
    if ( crontab -l | grep getWxAlert &> /dev/null) ; then
       # Alert Beacon
       echo
       echo -n "Do you want to enable over the air weather alerts " ; ANS=$(ckyorn y)

       if [ "$ANS" = "n" ] ; then
           sed 's/_WXALERT_BEACON_/N/g' /tmp/wx_scripts.tmp > /tmp/wx_scripts.tmp1
       else
           sed 's/_WXALERT_BEACON_/Y/g' /tmp/wx_scripts.tmp > /tmp/wx_scripts.tmp1
       fi
       mv /tmp/wx_scripts.tmp1 /tmp/wx_scripts.tmp

       # Email Setup/Change
       clear
       cat << _EOF
Optionally, you can send alert information to your cell phone or email account, using a Gmail account.  This will provide further information about the alert
and can be sent to several email accounts.

This will require a Gmail account with known account name and password.

_EOF

       echo -n "Do you wish to setup email alerts with Gmail "
       ANS=$(ckyorn n)
       if [ "$ANS" = "y" ] ; then
           # prompt for Gmail account, password, and email addresses for
           # wx alerts.
           VAL=1
           while [ "$VAL" = "1" ] ; do
               echo
               echo -n "Enter Gmail Account User's email (acctname@gmail.com): "
               read user
               echo
               echo -n "Enter Gmail Account Password: "
               read password
               echo
               echo -n "Enter the email address that the alerts are to be sent: "
               read Email
               echo
               echo "    Gmail Acount User: $user"
               echo "    Gmail Account Password:  $password"
               echo "    Email Address for Alerts:  $Email"
               echo
               echo -n "Is the information above correct: " ; ANS=$(ckyorn n)
               if [ "$ANS" = "y" ] ; then
                   # break out.
                   VAL=0
               fi
           done
           cat  > /usr/local/etc/.sendmail.cfg << _EOF
[gmail_send]
user = $user
password = $password
from = $user
_EOF

# cjk
           # now modify the EMAIL entry in the wx_scripts.conf file
           sed "s/#EMAIL=\"_EMAIL_\"/EMAIL=\"${Email}\"/g" /tmp/wx_scripts.tmp > /tmp/wx_scripts.tmp1
           mv /tmp/wx_scripts.tmp1 /tmp/wx_scripts.tmp

       fi  # gmail account

    fi # Weather Alert end


    clear
    # Weather Reports
    # check crontab if user is using ug_wx_reports.
    # if so, prompt for units, if not, skip
    if ( crontab -l | grep getWxRpt_ug &> /dev/null) ; then
        # Units
        if [ "$UNITS" = "US" ] ; then
            DEF=y
        else
            DEF=n
        fi
        echo
        echo "For weather reports, do you want to use US units"
        echo -n "       (Answer 'n' for Metric): ";  ANS=$(ckyorn $DEF)

        # USE METRIC for metric or US
        if [ "$ANS" = "y" ] ; then
            UNITS=US
            PRES_UNITS=IN
            RAIN_UNITS=IN
        else
            UNITS=METRIC
        fi

        if [ "$UNITS" = "METRIC" ] ; then
            # need pressure units
            echo " 1 - Pressure in Hectopascals"
            echo " 2 - Pressure in Inches of Mercury"
            echo " 3 - Pressure in Millibars of Mercury"
            echo
            echo -n "Select number for selection (1-3): "
            VAL=1
            while [ "$VAL" = "1" ] ; do
                read ANS
                case "$ANS" in
                  1) PRES_UNITS=HPA
                    VAL=0
                    ;;
                  2) PRES_UNITS=IN
                    VAL=0
                    ;;
                  3) PRES_UNITS=MB
                    VAL=0
                    ;;
                  *) echo "Invalid selection, enter 1,2,or 3"
                    VAL=1
                    ;;
                 esac
            done

            # need Rain units
            echo " 1 - Precipitation in Inches"
            echo " 2 - Precipitation in Centimeters"
            echo " 3 - Precipitation in Millimeters"
            echo
            echo -n "Select number for selection (1-3): "
            VAL=1
            while [ "$VAL" = "1" ] ; do
                read ANS
                case "$ANS" in
                  1) RAIN_UNITS=IN
                    VAL=0
                    ;;
                  2) RAIN_UNITS=CM
                    VAL=0
                    ;;
                  3) RAIN_UNITS=MM
                    VAL=0
                    ;;
                  *) echo "Invalid Selection, enter 1,2,or 4"
                    VAL=1
                    ;;
                 esac
            done
        fi


        # Units
        sed "s/_UNITS_/${UNITS}/g" /tmp/wx_scripts.tmp > /tmp/wx_scripts.tmp1
        mv /tmp/wx_scripts.tmp1 /tmp/wx_scripts.tmp

        # Pressure
        sed "s/_PRES_/${PRES_UNITS}/g" /tmp/wx_scripts.tmp > /tmp/wx_scripts.tmp1
        mv /tmp/wx_scripts.tmp1 /tmp/wx_scripts.tmp

        # Rain
        sed "s/_RAIN_/${RAIN_UNITS}/g" /tmp/wx_scripts.tmp > /tmp/wx_scripts.tmp1
        mv /tmp/wx_scripts.tmp1 /tmp/wx_scripts.tmp


    fi ; # end of wx report config changes


    # save old cron file

    # Move to final resting place
    mv /tmp/wx_scripts.tmp $WEATHER/wx_scripts.conf

fi ; # end of config

###############################################################
#  Stanza Modification
# /etc/asterisk/rpt.conf info
if [ "$MODULE_INS" = yes ] ; then

    clear
    cat << _EOF
----------------------------------------
Stanza Modification
   You will need to edit the /etc/asterisk/rpt.conf file to include the
   localplay entries under your node's functions stanza. This can be done
   a number of ways. You can manually edit the /etc/asterisk/rpt.conf file,
   you can automatically updated the asterisk templates or automatically
   modify the /etc/asterisk/rpt.conf file.  If you are using the
   node-config.sh script and you would like to continue the automation
   which that script provides, it is recommend that you use automatically
   update the templates.

_EOF
# '
    VAL=1
    while [ "$VAL" = "1" ] ; do
        echo "1)   Manually Edit"
        echo "2)   Automatically update the asterisk template file"
        echo "3)   Automatically update the /etc/asterisk/rpt.conf file"
        echo
        echo -n "Select number (1,2,or 3): "
        read ANS
        case "$ANS" in
          1)  RPT_STANZA=MANUAL
              VAL=0
              ;;
          2)  RPT_STANZA=TEMPLATE
              VAL=0
              ;;
          3)  RPT_STANZA=DIRECT
              VAL=0
              ;;
          *)  echo "Invalid selection, enter 1,2,or 3"
              VAL=1
              ;;
        esac
    done

    # Enter the DTMF Sequences and crate the temp file. This will be used to add to the rpt.conf,
    # template, or just print out as an example depending on the RPT_STANZA variable.

    if [ "$WX_ALERT" = "yes" ] ; then
        dtmf_sequence "${NWS_COUNTY} alert announcement"
        # wx alert
cat << _EOF >> /tmp/rpt_config.tmp

; Play local wx alert, *${DTMF_SEQ}
${DTMF_SEQ}=localplay,/tmp/wx/alert/${NWS_COUNTY}/alert_short
_EOF
    fi

    if [ "$WX_REPORT" = "yes" ] ; then
        dtmf_sequence "${UG_STN_N} report announcement"
        # wx report
cat << _EOF >> /tmp/rpt_config.tmp

; Play local wx report, *${DTMF_SEQ}
${DTMF_SEQ}=localplay,/tmp/wx/wxreport_ug/${UG_STN_N}/cur_WxRpt_ug
_EOF
    fi

    if [ "$WX_FORECAST" = "yes" ] ; then
        dtmf_sequence "${NWS_ZONE} forecast announcement"
        # wx forecast
cat << _EOF >> /tmp/rpt_config.tmp

; Play local wx forecast, *${DTMF_SEQ}
${DTMF_SEQ}=localplay,/tmp/wx/forecast/${NWS_ZONE}/wx_forecast
_EOF
    fi

    # Manual Edit
    if [ "$RPT_STANZA" = "MANUAL" ] ; then
        clear
        cat << _EOF
----------------------------------------
Manually Editing /etc/asterisk/rpt.conf
    You will need to edit the /etc/asterisk/rpt.conf file to include the
    localplay entries under your node's functions stanza.

    Please manually update the /etc/asterisk/rpt.conf file under the stanza
    [functions] as shown below:

_EOF

        cat /tmp/rpt_config.tmp
    echo
    echo
    echo "----------------------------------------"
    echo -n "Press any key to continue..." ; read ANS

    fi

    # update template file
    if [ "$RPT_STANZA" = "TEMPLATE" ] ; then
        RPT_FILE=/usr/local/etc/asterisk_tpl/rpt.conf_tpl
        echo "Update template file..."
        sed -e '/^; Weather Script Functions/r /tmp/rpt_config.tmp' ${RPT_FILE} > /tmp/rpt.conf_new
        mv /tmp/rpt.conf_new ${RPT_FILE}
        clear
        cat << _EOF
----------------------------------------
Updating Templates
    The node-config.sh script will now be executed, please answer the default
    values except for the first prompt.  This will update the rpt.conf file
    during  execution.

_EOF
        echo -n "Do you which to execute the node-config.sh now :" ; ANS=$(ckyorn n)
        if [ "$ANS" = "y" ] ; then
            /usr/local/sbin/node-config.sh
        else
            echo "You will need to execute the node-config.sh script manually to update"
            echo "the rpt.conf file"
        fi
        echo
        echo -n "Press any key to continue..."; read ANS
    fi ; # end of template update

    # update actual rpt.conf file
    if [ "$RPT_STANZA" = "DIRECT" ] ; then
        RPT_FILE=/etc/asterisk/rpt.conf
        sed -e '/^; Weather Script Functions/r /tmp/rpt_config.tmp' ${RPT_FILE} > /tmp/rpt.conf_new
        mv /tmp/rpt.conf_new ${RPT_FILE}
    fi

    echo "rpt.conf edit is completed..."

    # Do you use asterisk_tmpl (node-config.sh scripts)?
    #    if yes, modify the templates, then run node-config.sh
    #    else, backup rtp.conf and edit (sed) rtp.conf.
    # Need to get DTMF codes for each of the modules installed.


fi ; # end of module edits

# clean up...

rm  -f /tmp/rpt_config.tmp

clear
cat << _EOF


                -----------------NOTE-------------------

  You can run this script multiple times to add additional weather stations
  to your crontab or features.

  The weather information will not be available until the cron jobs have
  downloaded the weather information from the websites.  This can take up
  20 minutes.

               ----------------------------------------
                       Setup/Update Completed
               ----------------------------------------
_EOF

exit
