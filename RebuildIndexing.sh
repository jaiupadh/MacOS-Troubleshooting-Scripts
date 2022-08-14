#!/bin/sh
###########################################################################################
#		Script to rebuild indexing on MacOS		  			  #
#   			Authored by jaiupadh					          #
#		      Created on 20th Jul 2020                                            #
#                           Version: 1.0           			                  #
###########################################################################################

DeleteIndex(){
sudo mdutil -i off /
StatusOff=$?
if [[ $StatusOff == 0 ]]; then
  echo "Indexing Turned Off successfully"
else
  echo "Indexing not turned off"
  exit 1
fi
sudo rm -rf ./Spotlight-V100
StatusDel=$?
if [[ $StatusDel == 0 ]]; then
  echo "Deleted ./Spotlight-V100 file"
else
  echo "./Spotlight-V100 file was not deleted"
  exit 1
fi
}
OnIndex(){
sudo mdutil -i on /
StatusOn=$?
if [[ $StatusOn == 0 ]]; then
  echo "Indexing Turned On successfully"
else
  echo "Couldnt turn On Indexing"
  exit 1
fi
sudo mdutil -E /
StatusReset=$?
if [[ $StatusReset == 0 ]]; then
  echo "Indexing reset successfully"
else
  echo "Couldnt reset Indexing"
  exit 1
fi
}
PointIndex(){
sudo mdutil -i on /
sudo mdutil -i on /Applications/
StatusOnApp=$?
if [[ $StatusOnApp == 0 ]]; then
  echo "Indexing successfully pointed at /Applications/ folder"
else
  echo "Couldnt point at /Applications/"
  exit 1
fi
sudo mdutil -i on /Users/
StatusOnUsers=$?
if [[ $StatusOnUsers == 0 ]]; then
  echo "Indexing successfully pointed at /Users/ folder"
else
  echo "Couldnt point at /Users/"
  exit 1
fi
}
DeleteIndex
OnIndex
PointIndex
exit 0