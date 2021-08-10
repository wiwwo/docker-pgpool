#!/bin/bash

if [ "$1" == "NEW_MASTER" ]; then
  echo "### STARTING NEW MASTER"
  NEW_MASTER=$2
  rm -rf ${PGDATA}/*
else
  NEW_MASTER=pg_red
fi

if [ ! -s "$PGDATA/PG_VERSION" ]; then
	echo "*:*:*:$PG_REP_USER:$PG_REP_PASSWORD" > ~/.pgpass
	chmod 0600 ~/.pgpass
	until ping -c 1 -W 1 ${NEW_MASTER}
	do
		echo "Waiting for master ${NEW_MASTER} to ping..."
		sleep 1s
	done
  echo Executing: pg_basebackup -h ${NEW_MASTER} -D ${PGDATA} -U ${PG_REP_USER} -vP -W
	until pg_basebackup -h ${NEW_MASTER} -D ${PGDATA} -U ${PG_REP_USER} -vP -W
	do
		echo "Waiting for master to connect..."
		sleep 1s
	done
	echo "host replication all 0.0.0.0/0 md5" >> "$PGDATA/pg_hba.conf"
	set -e
	cat > ${PGDATA}/recovery.conf <<EOF
	standby_mode = on
	primary_conninfo = 'host=$NEW_MASTER port=5432 user=$PG_REP_USER password=$PG_REP_PASSWORD'
	trigger_file = '/tmp/touch_me_to_promote_to_me_master_$WHOISTHIS'
EOF
	chown postgres. ${PGDATA} -R
	chmod 700 ${PGDATA} -R
fi
sed -i 's/wal_level = hot_standby/wal_level = replica/g' ${PGDATA}/postgresql.conf

if [ "$1" != "NEW_MASTER" ]; then
  exec "$@"
fi