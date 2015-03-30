#!/bin/bash

IPTABLES_TEMPLATE=templates/iptables-ssh-server
BLACKLIST_DIR=blacklist
WORKING_DIR=`mktemp -d /tmp/blacklist.XXXXXX`
BLACKLIST_RULES=${WORKING_DIR}/blacklist-rules
IPTABLES_FINISHED=${WORKING_DIR}/iptables

pushd $BLACKLIST_DIR > /dev/null
for DATAFILE in *; do
  if [ -r "$DATAFILE" ]; then
    for LINE in `grep -E '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' "$DATAFILE"`; do
      echo "-A BLACKLIST -m iprange --src-range" $LINE "-j BLOCKED" >> $BLACKLIST_RULES
    done
  fi
done
popd > /dev/null

sed -e '/### Blacklist Rules ###/ r '$BLACKLIST_RULES $IPTABLES_TEMPLATE > $IPTABLES_FINISHED

echo "Complete. See $IPTABLES_FINISHED"