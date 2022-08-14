#!/bin/bash
###########################################################################################
#		Script to Uninstall Cisco AnyConnect Secure Mobility Client		  #
#   				  Authored by jaiupadh					  #
#				Created on 20th Jul 2020                                  #
#                                     Version: 2.0               			  #
###########################################################################################

# Get current logged-in user
currentUser=$(python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')
# Get logged-in user's home folder, just in case it's different...
homeFolder=$(dscl . read "/Users/$currentUser" NFSHomeDirectory | cut -d: -f 2 | sed "s/^ *//"| tr -d "\n")

##----------------------------------------------------------------------------------------##
##  -  DEFINING THE FUNTIONS/Arrays TO PERFORM VARIOUS TASKS  -				  ##
##----------------------------------------------------------------------------------------##
ForceQuitApp(){
#Force quitting Cisco Anyconnect application
osascript -e 'tell application "Cisco AnyConnect Secure Mobility Client" to quit'
#Resetting CoreServices
/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r
killall -kill cfprefsd
#Removing the application from Login Items
osascript -e 'tell application "System Events" to delete login item "Cisco AnyConnect Secure Mobility Client"'
}
#Functions to delete Cisco AnyConnect Secure Mobility Client related files from the Mac.
ScriptsToRun(){
/bin/bash "/opt/cisco/vpn/bin/dart_uninstall.sh"
/bin/bash "/opt/cisco/vpn/bin/anyconnect_uninstall.sh"
/bin/bash "/opt/cisco/vpn/bin/vpn_uninstall.sh"
/bin/bash "/opt/cisco/anyconnect/bin/umbrella_uninstall.sh"
}
PackageToForget(){
pkgutil --forget "com.cisco.pkg.anyconnect.vpn"
pkgutil --forget "com.cisco.pkg.anyconnect.dart"
pkgutil --forget "com.cisco.pkg.anyconnect.posture"
pkgutil --forget "com.cisco.pkg.anyconnect.umbrella"
}
DeleteFiles(){
rm -rf "/System/Library/StartupItems/CiscoVPN"
rm -rf "/Library/StartupItems/CiscoVPN"
rm -rf "/System/Library/Extensions/CiscoVPN.kext"
rm -rf "/Library/Extensions/CiscoVPN.kext"
rm -rf "/Library/Receipts/vpnclient-kext.pkg"
rm -rf "/Library/Receipts/vpnclient-startup.pkg"
rm -rf "/Cisco VPN Client.mpkg"
rm -rf "/com.nexUmoja.Shimo.plist"
rm -rf "/Library/LaunchDaemons/com.cisco.anyconnect.ciscod64.plist"
rm -rf "/Library/LaunchDaemons/com.cisco.anyconnect.ciscod.plist"
rm -rf "/Profiles"
rm -rf "/Shimo.app"
rm -rf "/Library/Application\ Support/Shimo"
rm -rf "/Library/Frameworks/cisco-vpnclient.framework"
rm -rf "/Library/Extensions/tun.kext"
rm -rf "/Library/Extensions/tap.kext"
rm -rf "/private/opt/cisco-vpnclient"
rm -rf "/opt/cisco/anyconnect"
rm -rf "/opt/cisco/hostscan"
rm -rf "/opt/cisco/vpn"
rm -rf "/Applications/VPNClient.app"
rm -rf "/Applications/Shimo.app"
rm -rf "/private/etc/opt/cisco-vpnclient"
rm -rf "/Library/Receipts/vpnclient-api.pkg"
rm -rf "/Library/Receipts/vpnclient-bin.pkg"
rm -rf "/Library/Receipts/vpnclient-gui.pkg"
rm -rf "/Library/Receipts/vpnclient-profiles.pkg"
rm -rf "$homeFolder/Library/Preferences/com.nexUmoja.Shimo.plist"
rm -rf "$homeFolder/Library/Application\ Support/Shimo"
rm -rf "$homeFolder/Library/Preferences/com.cisco.VPNClient.plist"
rm -rf "$homeFolder/Library/Application\ Support/SyncServices/Local/TFSM/com.nexumoja.Shimo.Profiles"
rm -rf "$homeFolder/Library/Logs/Shimo*"
rm -rf "$homeFolder/Library/Application\ Support/Shimo"
rm -rf "$homeFolder/Library/Application\ Support/Growl/Tickets/Shimo.growlTicket"
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

	Please install the Cisco Anyconnect application from Self Service application after restarting the Mac."
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
ScriptsToRun
PackageToForget
DeleteFiles
FixPermissions
AlertUser
exit 0
