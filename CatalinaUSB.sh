#!/bin/bash
###################################################################
#		    Script to Burn USBStick            		  #
#		     Authored by jaiupadh			  #
#		      on 19th OCT 2020				  #
#                       Version: 2.0                              #
###################################################################

##----------------------------------------------------------------------------------------##
##  -  DEFINING THE SCRIP TITILE AND DEFINING OTHER IMPORTANT VARIABLES  -		  ##
##----------------------------------------------------------------------------------------##


USBWelcome(){
callButton=$(osascript -e 'display dialog "                                       IMPORTANT!!!

This installer will help you to create a MacOS Bootable USB Drive.

Requirements:

* An USB Drive/Stick with minimum of 16GB Storage and should not have any data as it will be wiped off.
* Make sure that you have backed up all your data before installing Mac OS.


If you have any other external USB storage connected to your Mac, please eject and unplug it from your Mac immediately. Plug in the empty USB Drive/Stick, when you get the pop-up to connect it.


If you wish to continue, please click Next or you may quit the app by clicking Quit" buttons {"Next", "Quit"} default button "Next" with title "MacOS Bootable USB Creator"')
}
USBConnect(){
if [[ $callButton == "button returned:Next" ]]; then
echo "Connect the USB Drive/Stick"
callButtonA=$(osascript -e 'display dialog "Please connect the USB drive/Stick to it make bootable.

Also, disconnect all other USB devices and click Next" buttons {"Next", "Quit"} default button "Next" with title "MacOS Bootable USB Creator"')
else
echo "User opted to quit. Quitting now."
exit 1
fi
}
USBDetect(){
sleep 5
disk=$(ls -t /dev/disk? | head -1)
USBname=$(mount | grep $disk | cut -d ' ' -f 3)
diskutil info $disk | grep "USB"
statusC=$?
if [[ $statusC == 1 ]]; then
Bcaller=$(osascript -e 'display dialog "Bootable USB Thumb Drive has not detected. Please click on Detect button to rescan.

Please contact the helpdesk for further assistance, if you USB Thumb Drive is not detected after multiple tries" buttons {"Quit", "Detect"} default button "Detect" cancel button "Quit" with title "MacOS Bootable USB Creator" with icon stop')
if [[ $Bcaller == "button returned:Detect" ]]; then
USBDetect
else
exit 1
fi
else
if [[ $callButtonA == "button returned:Next" ]]; then
echo "Confirming the USB with User"
callButtonB=$(osascript -e 'display dialog "Are you sure you would like to use the USB '$USBname'?

If Yes, please click Continue.

Else, please disconnect the USB Drive/Stick, connect it back and then click on Retry.
" buttons {"Continue", "Retry", "Quit"} default button "Continue" cancel button "Quit" with title "MacOS Bootable USB Creator"')
if [[ $callButtonB == "button returned:Continue" ]]; then
echo "User selected Continue. Disk Wipe in Progress"
diskutil eraseDisk JHFS+ UntitledUSB $disk
status=$?
if [[ $status == 0 ]]; then
echo "USB Drive/Stick wipe Complete"
else
  osascript -e 'display dialog "Bootable USB Drive/Stick could not be erased.

Please contact the helpdesk for further assistance" buttons {"Quit"} cancel button "Quit" with title "MacOS Bootable USB Creator" with icon stop'
  exit 1
fi
callButtonC=$(osascript -e 'display dialog "The USB Drive/Stick has been renamed to UntitledUSB.

Please click on Continue to make it USB Bootable Device" buttons {"Continue", "Quit"} default button "Continue" with title "MacOS Bootable USB Creator"')
fi
if [[ $callButtonB == "button returned:Retry" ]]; then
echo "User selected Retry"
USBDetect
fi
if [[ $callButtonB == "button returned:Quit" ]]; then
echo "User selected Quit."
exit 1
fi
else
exit
fi
fi
}
USBBurn(){
if [[ $callButtonC == "button returned:Continue" ]]; then
my_dir=`dirname $0`
sudo $my_dir/Install\ macOS\ Catalina.app/Contents/Resources/createinstallmedia --volume /volumes/UntitledUSB --nointeraction
statusA=$?
if [[ $statusA == 0 ]]; then
echo "Bootable USB Drive/Stick successfully Created"
else
  osascript -e 'display dialog "Bootable USB Drive/Stick could not be created.

Please contact the helpdesk for further assistance" buttons {"Quit"} cancel button "Quit" with title "MacOS Bootable USB Creator" with icon stop'
  exit 1
fi
else
echo "User selected to Quit"
exit 1
fi
}

MainWelcome(){
MainButton=$(osascript -e 'display dialog "                                       MacOS Essentials

This installer will help you do the following tasks:

1) Create a Bootable USB
2) Upgrade/Reinstall the macOS (without deleting the data)
3) Reimage the Mac (Wipe all the data from Mac and perform fresh MacOS installation)

Please make you Selection: buttons {"Next", "Quit"} default button "Next" with title "MacOS Bootable USB Creator"')
}

MainWelcome
if [[ $callButton == "button returned:Next" ]]; then
USBWelcome
USBConnect
USBDetect
USBBurn
else
exit 1
fi
exit 0
