#!/bin/bash
###########################################################################################
#	     Script to Uninstall Cisco WebEx Teams application	  		          #
#   			Authored by jaiupadh & ssurkhi					  #
#		          Created on 19th Jul 2020                                        #
#                             Version: 2.0        			                  #
###########################################################################################

# Get current logged-in user
currentUser=$(python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')
# Get logged-in user's home folder, just in case it's different...
homeFolder=$(dscl . read "/Users/$currentUser" NFSHomeDirectory | cut -d: -f 2 | sed "s/^ *//"| tr -d "\n")
##----------------------------------------------------------------------------------------##
##  -  DEFINING THE FUNTIONS/Arrays TO PERFORM VARIOUS TASKS  -				  ##
##----------------------------------------------------------------------------------------##
#Function to force quit Webex teams and remove it from Login Items
ForceQuitApp(){
#Calling Apple Script to quit Cisco Webex Teams
pkill "Webex Teams"
#Resetting CoreServices
/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r
killall -kill cfprefsd
#Removing Cisco Webex Meetings from Login Items.
osascript -e 'tell application "System Events" to delete login item "Webex Teams"'
}
#Function to delete application related files from the Mac.
FilesToDelete(){
rm -rf "/Applications/Webex\ Teams.app"
rm -rf "/Applications/Cisco\ Spark.app"
rm -rf "/Library/Caches/Cisco-Systems.Spark"
rm -rf "/Library/Preferences/Cisco-Systems.Spark.plist"
rm -rf "$homeFolder/Library/Applications\ Support/Cisco Spark"
rm -rf "$homeFolder/Library/Applications\ Support/Cisco-Systems.Spark"
rm -rf "$homeFolder/Library/Caches/*"
rm -rf "$homeFolder/Library/Cookies/*"
rm -rf "$homeFolder/Library/Saved\ Application\ State/Cisco-Systems.Spark.savedState"
rm -rf "$homeFolder/Library/Webkit/Cisco-Systems.Spark"
rm -rf ~/Library/Caches/com.plausiblelabs.crashreporter.data
pkgutil --forget mc.mac.webex.com
}
#Funtion to Alert the user about the restart and to download the application from Self Service application
AlertUser(){
	title="Self Service Alert"
	message="Uninstallation Completed.

	Your Mac will automatically restart in 3 minutes. Please make sure you have saved all your documents.

	Please install the Cisco Teams application from Self Service application after restarting the Mac."
	close="Okay"
	# Multiple actions can be used to create a drop menu, but should probably be done in-line...
	action="Verify"
	timeOut=30
	icon="/Users/$currentUser/Library/Application\ Support/com.jamfsoftware.selfservice.mac/Documents/Images/brandingimage.png"
	/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -icon "$icon" -title "$title" -description "$message" -button1 "$close" -defaultButton 1 -timeout $timeOut -lockHUD -startlaunchd
}
##----------------------------------------------------------------------------------------##
##  -  CALLING THE FUNTIONS TO PERFORM RESPECTIVE TASKS  -				  ##
##----------------------------------------------------------------------------------------##
ForceQuitApp
#Function to delete Webex meeting center related files from the Mac.
FilesToDelete
#Funtion to create a shell script to run post restart
AlertUser
exit 0