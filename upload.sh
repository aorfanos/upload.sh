#!/bin/bash

#USAGE: upload --{file,text} <filename|plaintext> <expiry>

# implement logging
LOG_F="/tmp/f-upload.err"
if [ ! -f $LOG_F ]
then
	touch $LOG_F && chmod 644 $LOG_F
fi

exec 2>$LOG_F

ACTION=${1}
EXPIRY=${3:-1d}

if [ $ACTION == "--file" ]
then
	curl -sF "file=@$2" https://file.io/?expires=$EXPIRY | jq -r '.link'
elif [ $ACTION == "--text" ]
then
	curl -s --data "text=$2" https://file.io/?expires=$EXPIRY | jq -r '.link'
else
	echo -en "Usage:\n\tupload --{file,text} <filename|plaintext> {expiry}\nDefaults:\n\tExpiry=1d\nExpiry options:\n\td(days)\n\tw(weeks)\n\tm(months)\n\ty(years)\n"
fi
