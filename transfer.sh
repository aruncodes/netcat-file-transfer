#!/bin/bash
# 
#	Script to send files between Linux machines in LAN using `nc` or `netcat` command
# 
# 	Note: A receiver should be waiting to receive the file before senders sends.
#	Note: IP show only works on 192.168.X.X private series, however functionality may work in others.
# 
#	Author: Arun Babu 	
#	Date: 11-Sept-2012
#	
#	Use `chmod +x transfer.sh` to get execute permissions
#	Execute as `./transfer.sh`
# 

echo "------------------------------------"
echo "A file transfer script by Arun Babu."
echo "------------------------------------"

CMD="nc"
PORT="5000"

IP=`ifconfig | grep -E 192.168.\([0-9]\+.\?\)\{2} -o | head -n1`
if [ -z $IP ]; then
	IP="not found,may not be connected."
fi
ACTION=`zenity --list --title="Select an action" --text="Select an action to preform, your IP is $IP" --hide-header --column "Choose" --column "Action" --radiolist TRUE "Send a file" FALSE "Receive a file"`
echo $ACTION

if [ "$ACTION" = "Send a file" ]; then
	
	# echo " will send"
	SENDFILE=`zenity --file-selection --confirm-overwrite --title="Select a file to send"`
	echo $SENDFILE
	IPADD=`zenity --entry --title "Enter the IP address" --text="IP Address:" --entry-text="$IP"`
	echo $IPADD;
	
	echo "$CMD $IPADD $PORT < $SENDFILE"
	echo "Sending file.."
	RES=`$CMD $IPADD $PORT < "$SENDFILE"`
	if [ -z $RES ]; then
		zenity --info --title "Finished" --text "File send.. :) "
	fi
	
elif [ "$ACTION" = "Receive a file" ]; then

	# echo " will receive"
	DESTFILE=`zenity --file-selection --save --confirm-overwrite --title="Select a file name to save the received file"`
	echo $DESTFILE
	
	echo "$CMD -l $PORT >> $DESTFILE"
	echo "Waiting to receive file.. Your IP address is $IP"
	RES=`$CMD -l $PORT >> "$DESTFILE"`
	if [ -z $RES ]; then
		zenity --info --title "Finished" --text "File received.. :) "
	fi
fi

echo "Thank you for using this.. See you soon.."
