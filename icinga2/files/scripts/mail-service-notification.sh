#!/bin/sh
template=`cat <<TEMPLATE

Host: $HOSTALIAS
Service: $SERVICEDESC
State: $SERVICESTATE
Message: $SERVICEOUTPUT

Date/Time: $LONGDATETIME

TEMPLATE
`

/usr/bin/printf "%b" "$template" | mail -s "$SERVICESTATE $SERVICEDESC on $HOSTALIAS in $NOTIFICATIONTYPE" $USEREMAIL

