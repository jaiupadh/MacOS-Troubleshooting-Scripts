#!/bin/bash
###########################################################################################
#		Script to Fix Printer issues on MacOS		  			  #
#   			Authored by jaiupadh					          #
#		      Created on 25th Jul 2020                                            #
#                           Version: 1.0           			                  #
###########################################################################################

scriptTitle="FixPrinter"
# Defining the Folder where the log files will be stored
logFolder="/var/tmp/"
#Defining the log file name using the script title
logFile="$logFolder"/"$scriptTitle.log"
#Defining function to get the Home Directory
grabConsoleUserAndHome(){
currentUser=$(stat -f %Su "/dev/console")
homeFolder=$(dscl . read "/Users/$currentUser" NFSHomeDirectory | cut -d: -f 2 | sed "s/^ *//"| tr -d "\n")
case "$homeFolder" in
   **)
         homeFolder=$(printf %q "$homeFolder")
        ;;
     *)
         ;;
esac
}
#Calling function to get the Home Directory
grabConsoleUserAndHome

onTrackLog(){ echo "[$(date "+%D %T")] [$scriptTitle][$currentUser] $1 $2 $3" | tee -a $logFile;eventID="$1"; }
[[ -d $logFolder ]] || mkdir -p -m 775 "$logFolder"
[[ $logSize -ge $maxSize ]] && rm -rf "$logFile"

open $logFolder"/"$scriptTitle.log
ReplaceCups(){
my_dir=`dirname $0`
  onTrackLog "[0001]" "[Informational]" "[Replacing the Cups Folder]";
sudo cp -R $my_dir/untitled\ folder/cups /usr/libexec &> /dev/null
 onTrackLog "[0002]" "[Informational]" "[Cups Folder replaced...]";
}
ResetPrintSystem(){
  onTrackLog "[0003]" "[Informational]" "[Resetting the Printing system]";
  sudo launchctl stop org.cups.cupsd
  sudo rm /etc/cups/cupsd.conf
  sudo cp /etc/cups/cupsd.conf.default /etc/cups/cupsd.conf
  sudo rm /etc/cups/printers.conf
  sudo launchctl start org.cups.cupsd
  onTrackLog "[0004]" "[Informational]" "[Printing System successfully reset]";
}
ReplaceCups
ResetPrintSystem
exit 0