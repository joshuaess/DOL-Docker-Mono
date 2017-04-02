#!/usr/bin/env bash
#
# run-time config for the dol mono server
#

# replace placeholders in template with env vars. IE $MYSQL_USER -> dol
envsubst < ~/serverconfig.xml.template > ~/dol/Debug/config/serverconfig.xml

until nc -z -v -w30 "$MYSQL_IP" 3306
do
  echo "Waiting for database connection..."
  # wait for 5 seconds before check again
  sleep 5
done

LANG=en_US.CP1252 mono --debug --gc=sgen --server ~/dol/Debug/DOLServer.exe
