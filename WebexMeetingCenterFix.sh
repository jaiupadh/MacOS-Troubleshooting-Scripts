#!/bin/bash
###########################################################################################
#	     Script to Uninstall Cisco WebEx Meeting Center application	  		  #
#   			    Authored by jaiupadh					  #
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
#Function to force quit Webex Meeting Center app and remove it from Login Items
ForceQuitApp(){
	#Calling Apple Script to quit Cisco Webex Meetings
	osascript -e 'tell application "Cisco Webex Meetings" to quit'
	#Resetting CoreServices
	/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r
	killall -kill cfprefsd
	#Removing Cisco Webex Meetings from Login Items.
	osascript -e 'tell application "System Events" to delete login item "Cisco Webex Meetings"'
}
#Function to delete application related files from the Mac.
FilesToDelete(){
rm -rf "/Applications/WebEx"
rm -rf "/Users/Shared/WebExPlugin"
rm -rf "/Library/Caches/*"
rm -rf "/Library/Cookies/*"
rm -rf "/Library/LaunchAgents/com.webex.pluginagent.plist"
rm -rf "/Library/ScriptingAdditions/WebexScriptAddition.osax"
rm -rf "/Private/tmp/webex*"
rm -rf "/Private/tmp/wbxtra*"
rm -rf "/Library/Internet\ Plug-Ins/WebEx64.plugin"
rm -rf "/Library/LaunchAgents/com.webex.pluginagent.plist"
rm -rf "$homeFolder/Library/Containers/com.cisco.webex.Cisco-WebEx-Start.CWSSafariExtension"
rm -rf "$homeFolder/Library/Caches/*"
rm -rf "$homeFolder/Library/Cookies/*"
rm -rf "$homeFolder/Library/Logs/PT/*"
rm -rf "$homeFolder/Library/LaunchAgents/com.webex.pluginagent.plist"
rm -rf "$homeFolder/Library/Preferences/com.cisco.webex*"
rm -rf "$homeFolder/Library/Preferences/com.webex*"
rm -rf "$homeFolder/Library/WebKit/com.webex.meetingmanager"
rm -rf "$homeFolder/Library/Application\ Support/WebEx\ Folder"
rm -rf "$homeFolder/Library/Application\ Scripts/com.cisco.webex.Cisco-WebEx-Start.CWSSafariExtension"
rm -rf "$homeFolder/Library/Preferences/com.cisco.Cisco\ Webex\ Meetings.plist"
rm -rf "$homeFolder/Library/Saved\ Application\ State/com.cisco.Cisco\ Webex\ Meetings.savedState"
}
#Funtion to fix the permissions on the /tmp/ and user's home directory (ONLY FOR REQUIRED SCRIPTS. PLEASE DELETE IT IF NOT REQUIRED)
FixPermissions(){
  chmod -R 777 /Private/tmp/
  cd /Users/
  chmod -R 755 $homeFolder
}
#Funtion to Alert the user about the restart and to download the application from Self Service application
AlertUser(){
	title="Self Service Alert"
	message="Uninstallation Completed.

	Your Mac will automatically restart in 3 minutes. Please make sure you have saved all your documents.

	Please install the Cisco Webex Meeting application from Self Service application after restarting the Mac."
	close="Okay"
	# Multiple actions can be used to create a drop menu, but should probably be done in-line...
	action="Verify"
	timeOut=30
	icon="/Users/$currentUser/Library/Application\ Support/com.jamfsoftware.selfservice.mac/Documents/Images/brandingimage.png"
	/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -icon "$icon" -title "$title" -description "$message" -button1 "$close" -defaultButton 1 -timeout $timeOut -lockHUD -startlaunchd
}

##----------------------------------------------------------------------------------------##
##  -  CALLING THE FUNTIONSCTO PERFORM RESPECTIVE TASKS  -				  ##
##----------------------------------------------------------------------------------------##

#Function to force quit Webex Meeting Center app and remove it from Login Items
ForceQuitApp
#Function to delete Webex meeting center related files from the Mac.
FilesToDelete
#Defining Array to delete Webex meeting center related files from the Mac.
FixPermissions
AlertUser
exit 0