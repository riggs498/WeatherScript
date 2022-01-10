Weather Scripts 

Wx_Config_Readme.txt
   by w0anm
( $Id: Wx_Config_Readme.txt 9 2014-12-22 23:47:16Z w0anm $)

 ============================================================================
|                            IMPORTANT NOTICE!                               |
|                                                                            |
| No matter what the Weather Alerts are indicating, the information          |
| gathered and presented here may NOT be accurate. You MUST use your own     |
| judgement to determine your best course of action in any given             |
| circumstance! The are many reasons WHY the data here may not be accurate,  |
| including, but not limited to, software problems, network problems, and or |
| hardware problems. The Weather Alerts and other Weather information should |
| NOT be used to make any determination of actual current conditions, it is  |
| merely an indication of what the software is seeing as a result of it's    |
| attempts to read publicly available data sources.  These data sources may  |
| be unavailable, unreachable, or innacurate. Please check other sources to  |
| verify any information presented here.                                     |
 ============================================================================

This document  will explain how to configure the weather scripts.  

Before configuring the weather scripts, you will need some addtional 
information from the National Weather Service (NWS) and Weather Underground 
depending what options you choose during the configuration.

==Alerts==

The weather alert scripts will allow you to get short alert messages via 
your node audio.

You will need to have the NWS County number information to setup the Weather 
Alerts.  Refer to the following URL:

    http://www.weather.gov/alerts

Select the "Warnings By State" under "Active Alerts". Select the County List
listed by the desired state.  You will see the "County Code", now pick from the 
various State Counties displayed and write this "Count Code" down for reference.

For example, under Minnesota you wil find - Wright. The county code for
this county is  MNC171. If you want to be alerted on multiple areas, make a
note of those counties and you can re-execute the script and enter the
additional counties. You will use the “Zone Code” for the configuration script.


==NWS Weather Forecasts==

The weather forecast scripts will allow you to get your NWS weather forecast 
messages by a DTMF sequence and will announce the weather conditions 
via your node audio.

You will need to have the NWS Weather Zone ID information prior to running 
this script.

Finding the Zonde ID is simlar to getting the County Code. This information can be found at:

Refer to the following URL:

    http://www.weather.gov/alerts

Select the "Warnings By State" under "Active Alerts". Select the "Zone List"
listed by the desired state.  You will see the "Zone Code", now pick from the
various State Counties displayed and write this Zone Code down for reference.

For example, Under Minnesota you wil find - Wright. The Zone code for
this county is  MNZ059. If you want to to have forecast for other areas,
make a note of those counties and you can re-execute the script and enter the
additional counties. You will use the “Zone Code” for the configuration script.


==Underground Weather Reports==

The Underground weather report scripts  will allow you to get current weather 
conditions based upon Weather Underground stations by a dtmf sequence and 
will announce the weather conditions via your node audio.

You will need to have the Underground Weather station ID information prior
to running this script. Refer to the URL below:

    http://www.wunderground.com/wundermap/

Browse the map for your local area. You will see the Station ID's of various
weather stations. Once you select one on the map, you will find the station ID.
This will be begin K, then two letter state abbreviation, and location. For
example:

      KMNSTMIC3

When selecting the desired station and review the captured information to make
sure that this has all of the values you want to capture. For example, some 
stations do not include precipitation. I prefer the “rapid fire” stations 
since they update most frequently. You will use the “Station ID” for the 
configuration script.

For more information, refer to:
    http://www.w0anm.com/dokuwiki/doku.php?id=irlp:wx_scripts_doc


===Configuration Script===

The configuration script is called "wx_config.sh" and can be run many times.
This script will allow you to select the desired weather scripts that you want
to use, see above.  It will also prompt you for the required weather codes 
such as County Codes,  Zone Code/ID, and Underground Weather Station ID.

The "wx_config.sh" script is located in /usr/local/bin/Weather.  To 
configure the weather scripts, change directories and execute the script:

    cd /usr/local/bin/Weather
    ./wx_config.sh

 
You will see an Important Notice and you will need to ackowledge this
notice.  

You will then be prompted for which setup scripts you would like to 
setup or update.
   
Each setup area will update "root" cron and add an entry.  In unix, there is 
a background process (or daemon) running  that will execute scripts at a
specified time or times.  This is how the weather scripts get information
from the weather sites. The "wx_config.sh" script will create these entries.

If you add the same code, the script is will check and will not add an entry if
one is already present.

In the last part of the execution of the script, you will be prompted for
your node number and if you want the alerts to be sent over the node 
automatically when they occur.

This can be change by re-executing the script.


===Stanza Modification=== 

Once the "wx_config.sh" script is executed, you will need to modify the 
rpt.conf Stanza to select the desired DTMF sequences to play the Weather 
Forecast, Weather Report, or Alerts. The file that needs to be edited is
"/etc/asterisk/rpt.conf"

Below is an example for my node. Please update dtmf sequence to your 
node/site requriements.

Under Node [functions]:

    [functions]

    ; Play local wx report, *986 
    986=localplay,/tmp/wx/wxreport_ug/KMNROGER1/cur_WxRpt_ug
    ; Play local wx alert, *987
    987=localplay,/tmp/wx/alert/MNC171/alert_short
    ; Play local wx forecast, *988
    988=localplay,/tmp/wx/forecast/MNZ059/wx_forecast


===Operation===

To play a underground weather report, key your transmitter and enter your
dtmf sequence that you selected.  You should hear the report being 
transmitted, for example:

   Weather report for North Ridge ,  Rogers . 
   Last Updated on September 18, 8:45 PM CDT,
   the wind was blowing at a speed of 1.0 miles per hour from south south east
   with wind gusts up to 1.0 miles per hour.  
   The temperature was 65.6 degrees with a dewpoint of 51.3 degrees.
   The pressure was  at 29.92 inches of mercury. 
   The relative humidity was 60 percent.

You can also play from the command line by entering:

  asterisk -rx "rpt fun <node_number> <dtmf_sequence>"

for example:
  
  asterisk -rs "rpt fun 29062 *987"


To play the weather forecast,  key your transmitter and enter your
dtmf sequence that you selected.  You should hear the report being 
transmitted, for example:

   Weather forecast for 
   wright-
   including the cities of. . . monticello
   405 p m  thu sep 18 2014
   . tonight. . . warmer.  partly cloudy.  lows in the upper 50's.  south
   winds 10 to 15 miles per hour .  
   . friday. . . cloudy with a 40 percent chance of showers and
   thunderstorms.  highs in the upper 70's.  south winds 10 to 15 miles per hour
   . friday night. . . partly cloudy with a 30 percent chance of showers
   and thunderstorms.  lows in the lower 60's.  southwest winds 5 to
   10 miles per hour .  
   . saturday. . . partly cloudy.  highs in the upper 70's.  northwest
   winds 10 to 15 miles per hour .  
   . saturday night. . . cooler.  mostly clear.  lows in the lower 50's. 
   northwest winds 5 to 10 miles per hour .  
   . sunday. . . mostly sunny.  highs in the upper 60's.  
   . sunday night. . . clear.  lows in the upper 40's.  
   . monday. . . sunny.  highs in the upper 60's.  
   . monday night. . . clear.  lows in the upper 40's.  
   . tuesday. . . sunny.  highs around 70.  
   . tuesday night. . . mostly clear.  lows around 50.  
   . wednesday. . . mostly sunny.  highs in the upper 60's.  
   . wednesday night. . . partly cloudy.  lows in the mid 50's.  
   . thursday. . . mostly cloudy with a slight chance of showers with
   isolated thunderstorms.  highs around 70.  chance of rain
   20 percent.  

You can also play from the command line by entering:

  asterisk -rx "rpt fun <node_number> <dtmf_sequence>"

for example:
  
  asterisk -rs "rpt fun 29062 *986"

The weather alerts are automatic, if enabled.  They will alert when there
is a weather alert and stop sending when the weather alert is over or expired.



-----------------NOTE-------------------

You can run this script multiple times to add additional weather stations
to your crontab or features.

