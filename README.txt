README.txt 

README.txt v0.1
( wx_scripts - release v0.3)

 ============================================================================
|                            IMPORTANT NOTICE!                               |
|                                                                            |
| No matter what the Weather Alerts are indicating, the information         |
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


==Distribution Installation==
These instructions are for the Allstar BBB distribution to install the Weather
scripts in the the "/usr/local/bin/Weather" directories. It will also install 
any dependencies required by using the "pacman" software install utility.

=Installation=

Install using the compressed tar file. Copy the tar file over to
/root (as root) and extract the files:
    cd /root
    tar zxf wxscripts-<version>.tgz

Then change directories to the extracted directory and run the installation 
script:
    cd /wx_scripts-<version>
    ./wx_scripts_install.sh

This will install any dependency packages, setup the distribution directories, 
and copy the scripts to the appropriate locations.

This script will not setup any cron entries or configuration files.

The user will need to configure the rest.


<  $Id $  >
