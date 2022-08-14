#!/bin/sh
###########################################################################################
#		       MSFT Outlook SendRecieve		  	                          #
#   			Authored by jaiupadh					          #
#		      Created on 20th Jul 2020                                            #
#                           Version: 1.0               			                  #
###########################################################################################
osascript -e 'activate application "Microsoft Outlook"
tell application "System Events"
	keystroke "k" using command down
	activate me
end tell'
exit 0
