#!/bin/bash
###########################################################################################
#	            Script to Fix MacOS Catalina Storage issue  	  		  #
#   			    Authored by jaiupadh					  #
#		          Created on 20th OCT 2020                                        #
#                             Version: 1.0        			                  #
###########################################################################################

clearcore(){
  coresize=$(du -s /cores/ | cut -f 1)
  if [[ $coresize > 0 ]]; then
    sudo rm -rf /cores/*
  else
    echo "Please contact the Tier 3 Mac Admin Team for further troubleshooting"
    exit 1
  fi
}
clearcore
exit 0