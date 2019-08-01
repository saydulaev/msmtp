#!/bin/bash -
#title          :msmtp.sh
#description    :This script can be used to send a mail notification.
#author         :Ruslan Saydulaev
#email          :saydulaev.rb@gmail.com
#date           :20190731
#version        :-
#usage          :./msmtp.sh "First subject theme" "body text message" "recipient_mailbox@gmail.com"
#notes          :Install and configure <msmtp> app to use this script.
#=========================================================================================================


subject="$1"
body="$2"
mail_to="$3"

# Path to config file msmtp.
# Let script to read and look for accounts in config file.

conf_path="/etc/msmtprc"

# Change to <true> to enable debug.

verbosity=false


# Route recipients by accounts.
# Define which transport (account setting)  will be used.
# Transport defined from recipients email endings.
# like "gmail.com", "yandex.ru" etc.

transport=`echo "$mail_to" | cut -d "@" -f2`

# Set shortened variables for email domain's for 'case' variants.

gmail="gmail.com"
ya="yandex.ru"
itb="inform-tb.ru"


# If case comparison not found a tranport,
# script will use default rule *)
# Primarily check if variable "default_transport" was setted. If it was setted it will be used as mail_from.
# If "default_transport" was not setted, then read a config file "conf_path" to looking for defined accounts.
# This is a first not commented account string find out in "$conf_path".

default_transport="inform-tb"

case "$transport" in
    "$gmail")
        mail_from=`echo "$transport" | cut -d "." -f1`
        ;;
    "$ya")
        mail_from=`echo "$transport" | cut -d "." -f1`
        ;;
    "$itb")
        mail_from=`echo "$transport" | cut -d "." -f1`
        ;;
    *)
        if [ ! -z "default_transport" ]
        then
            mail_from="$default_transport"
        elif [ ! -z "$conf_path" ]
        then
            mail_from=`cat "$conf_path" | grep account | grep -ve "#" | awk 'NR==1{print $2}'`
        else
            continue
            # mail_from="gmail"
        fi
        ;;
esac


if [ "$verbosity" = true ]
then
    echo -e "Subject: ${subject}\r\n\r\n${body}\n" | msmtp --debug -a "$mail_from" -t "$mail_to"
else
    echo -e "Subject: ${subject}\r\n\r\n${body}\n" | msmtp -a "$mail_from" -t "$mail_to"
fi

