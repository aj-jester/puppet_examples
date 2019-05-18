#!/bin/sh

# Alert state
if [ "$HOSTSTATE" == "DOWN" ]; then
  alert_state=CRITICAL
elif [ "$HOSTSTATE" == "UP" ]; then
  alert_state=OK
else
  alert_state=CRITICAL
fi

template=`cat <<TEMPLATE

Host: $HOSTALIAS
State: $alert_state / $HOSTSTATE
Message: $HOSTOUTPUT

Date/Time: $LONGDATETIME

TEMPLATE
`

/usr/bin/printf "%b" "$template" | mail -s "$alert_state $HOSTALIAS is $HOSTSTATE" $USEREMAIL

