#!/bin/bash


cleanup()
{
    echo "SIGTERM received, trying to gracefully shutdown."
    echo "diediedie" | nc localhost 4242
    sleep 2
    /opt/hbase/bin/stop-hbase.sh
}
trap cleanup TERM

if [ ! -f "/etc/opentsdb/opentsdb.conf" ]
then
    echo "OpenTSDB config not imported, using defaults."
    cp /etc/opentsdb/opentsdb.conf.sample /etc/opentsdb/opentsdb.conf
fi

if [ ! -f "/opt/hbase/conf/hbase.xml" ]
then
    echo "HBase config not imported, using defaults."
    cp /opt/hbase/conf/hbase-site.xml.sample /opt/hbase/conf/hbase-site.xml
fi

if [[ -z "$AUTH_USER" ]] || [[ -z "$AUTH_KEY" ]]; then 
echo "AUTHENTICATION ENVIRONMENT VARIABLES ARE NOT PRESENT, ABORTING"
exit 1
fi

# create a password file from environment variables
htpasswd -bc /etc/nginx/.htpasswd "$AUTH_USER" "$AUTH_KEY"
# start nginx as a background process
nginx

WAITSECS=${WAITSECS:-15}
echo "starting hbase and sleeping ${WAITSECS} seconds for hbase to come online"
/opt/bin/start_hbase.sh &
sleep ${WAITSECS}
touch /data/hbase/hbase_started

echo "Starting opentsdb.  It should be available on port 4242 momentarily."
/opt/bin/start_opentsdb.sh &

while [ 1 ]
do
    sleep 1
done
