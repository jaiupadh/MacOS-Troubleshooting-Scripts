#!/bin/bash
###########################################################################################
#		Script to Fix Network related issues                                      #
#                     Authored by jaiupadh						  #
#		    Created on 19th Jul 2020						  #
#		          Version: 2.0						          #
###########################################################################################

##----------------------------------------------------------------------------------------##
##  -  DEFINING THE SCRIP TITILE AND DEFINING OTHER IMPORTANT VARIABLES  -		  ##
##----------------------------------------------------------------------------------------##
# Get current logged-in user
currentUser=$(python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')
# Get logged-in user's home folder, just in case it's different...
homeFolder=$(dscl . read "/Users/$currentUser" NFSHomeDirectory | cut -d: -f 2 | sed "s/^ *//"| tr -d "\n")
MacName=$(scutil --get HostName)
##----------------------------------------------------------------------------------------##
##  -  DEFINING THE FUNTIONS/Arrays TO PERFORM VARIOUS TASKS  -				  ##
##----------------------------------------------------------------------------------------##
#Defining Array to delete the Keychain Entries
EntriestoDelete=(
"Network"
"blizzard"
"Blizzard"
"Blizzard-legacy"
"blizzard-legacy"
"Default"
)
#Function to delete keychain Entries from the Mac.
FlushKeychainEntries(){
for EachEntry in ${EntriestoDelete[@]}; do
security find-generic-password -l "$EachEntry"
Result=$?
if [[ $Result == 0 ]]; then
echo "Keychain entry $EachEntry found. Deleting the Keychain entry"
while [[ ! -z $(security delete-generic-password -l "$EachEntry") ]]
do
security delete-generic-password -l "$EachEntry"
DeleteResult=$?
if [[ $DeleteResult == 0 ]]; then
echo "Keychain entry $EachEntry successfully Deleted"
else
echo "Keychain entry $EachEntry not found"
fi
done
else
echo "Keychain entry $EachEntry not found"
fi
done
}
#Defining Array to delete the .plist files
FilesToDelete=(
"/Library/Preferences/SystemConfiguration/preferences.plist"
"/Library/Preferences/SystemConfiguration/NetworkInterfaces.plist"
"/Library/Preferences/SystemConfiguration/com.apple.wifi.message-tracer.plist"
"/Library/Preferences/SystemConfiguration/com.apple.network.eapolclient.configuration.plist"
"/Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist"
"/Library/Preferences/SystemConfiguration/preferences.plist.old"
"/Library/Preferences/SystemConfiguration/com.apple.eapolclient.plist"
"/Library/Preferences/SystemConfiguration/com.apple.captive.probe.plist"
"/Library/Preferences/SystemConfiguration/CaptiveNetworkSupport"
)
#Function to delete the .plist files
Flushreqfiles(){
for EachFile in ${FilesToDelete[@]}; do
if [[ -e "$EachFile" ]]
then
echo "Deleting the Plist file $EachFile"
rm -r -f "$EachFile"
else
echo "Plist file $EachFile not found"
fi
done
}
AlertUser(){
  title="Self Service Alert"
  message="Network Preferences on this Mac have been successfully reset.

  Your Mac will automatically restart in 3 minutes. Please make sure you have saved all your documents.

  Please connect to WiFi or LAN Network after restarting the Mac."
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
#Function to delete the Keychain entries from Mac
FlushKeychainEntries
#Function to delete .plits files from the Mac.
Flushreqfiles
#Commands to rename the Mac post deleting the plist
scutil --set HostName $MacName
scutil --set LocalHostName $MacName
scutil --set ComputerName $MacName
AlertUser
exit 0