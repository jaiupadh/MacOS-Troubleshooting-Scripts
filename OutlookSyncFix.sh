#!/bin/sh
###########################################################################################
#		Script to fix Outlook sync issues		  			  #
#   			Authored by jaiupadh					          #
#		      Created on 25th Jul 2020                                            #
#                           Version: 2.1             			                  #
###########################################################################################

CheckOutlookStatus(){
Outlooklaunched=$(osascript -e 'set appName to "Microsoft Outlook"
set AppCond to false
tell application "System Events"
	if (exists process appName) then
		set AppCond to true
	else
		set AppCond to false
	end if
end tell')
if [ $Outlooklaunched == "true" ]; then
  echo "Outlook is active"
  Outlookstat="true"
else
  echo "Outlook is inactive"
  Outlookstat="false"
fi
}
CheckNetwork(){
  host="outlook.office365.com"
  ping -c1 "$host" &> /dev/null
  if [ $? -eq 0 ]; then
    # connection is UP
    ConnectionStat="true"
		echo "Network connection is UP"
  else
    ConnectionStat="False"
    # connection is DOWN
		echo "Network connection is DOWN"
  fi
}
RunSync(){
osascript -e 'tell application "Microsoft Outlook"
	sync inbox
	sync calendars
end tell'
SyncStat=$?
if [ $SyncStat == 0 ]; then
	echo "Sync Complete"
else
	echo "Sync Failed"
fi
}
while true
do
CheckOutlookStatus
CheckNetwork
if [ $Outlookstat == "true" ] && [ $ConnectionStat == "true" ]
then
echo "Initiating Sync"
RunSync
else
  echo "Either the Outlook is not launched or not connected to the network"
fi
echo "Sleeping for 2 minutes"
sleep 120s
done
exit 0
