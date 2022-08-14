#!/bin/sh
###########################################################################################
#		Script to fix MSFT Outlook Sync Issues 		  			  #
#   			Authored by jaiupadh					          #
#		      Created on 20th Jul 2020                                            #
#                           Version: 1.0               			                  #
###########################################################################################

my_dir=`dirname $0`
mkdir -p /Library/CiscoIT/Scripts/OutlookSync
sudo cp $my_dir/OutlookSyncFix.sh /Library/CiscoIT/Scripts/OutlookSync
sudo cp $my_dir/com.cisco.Outlook365sync.plist /Library/LaunchDaemons
launchctl load /Library/LaunchDaemons/com.cisco.Outlook365sync.plist
