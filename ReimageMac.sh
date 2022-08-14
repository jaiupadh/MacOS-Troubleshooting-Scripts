#!/bin/bash
###########################################################################################
#		       Script to Reimage Mac OS		  			          #
#   			Authored by jaiupadh					          #
#		      Created on 19th Jul 2020                                            #
#                           Version: 2.0        			                  #
###########################################################################################

my_dir=`dirname $0`
sudo $my_dir/Install\ macOS.app/Contents/Resources/startosinstall --eraseinstall --agreetolicense &> /dev/null
statusA=$?
if [[ $statusA == 0 ]]; then
echo "Mac reimage complete"
else
  osascript -e 'display dialog "Could not re-image the Mac.

Please contact the Cisco IT Support / Helpdesk Team for further assistance" buttons {"Quit"} cancel button "Quit" with title "MacOS Bootable USB Creator" with icon stop'
  exit 1
fi
exit 0
