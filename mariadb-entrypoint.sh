#!/usr/bin/env bash
#
# run-time config for mariadb. populate the db migrations folder and run mysql
#

# encrypting pw doesn't work. dol encrypts it after first login
if [[ -f 'z-create-admin-account.sql' ]]; then
    echo 'populating env vars in account creation sql script...'
    envsubst < 'z-create-admin-account.sql' \
      >> /docker-entrypoint-initdb.d/z-create-admin-account.sql
    rm 'z-create-admin-account.sql'
fi

# shellcheck disable=SC1091
# the default mariadb entrypoint runs migrations/.sql scripts on the first run
source '/docker-entrypoint.sh' "$@"
