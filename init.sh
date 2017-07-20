#!/bin/bash
set -e

# Wait for mysql to start up
echo "Waiting for mysql"
until mysql -h"$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" &> /dev/null
do
        >&2 echo -n "."
        sleep 1
done
>&2 echo "MySQL is started."

# Check installed
if [ -d '/opt/sos-berlin.com/jobscheduler' ]; then
    /opt/sos-berlin.com/jobscheduler/scheduler/bin/jobscheduler.sh start
else
    sed -ie "s/{{DB_NAME}}/$MYSQL_DATABASE/g" /usr/local/src/jobscheduler/install.xml
    sed -ie "s/{{DB_USER}}/$MYSQL_USER/g" /usr/local/src/jobscheduler/install.xml
    sed -ie "s/{{DB_PASS}}/$MYSQL_PASSWORD/g" /usr/local/src/jobscheduler/install.xml

    sed -ie "s/{{DB_HOST}}/$MYSQL_HOST/g" /usr/local/src/jobscheduler/install.xml
    sed -ie "s/{{DB_PORT}}/$MYSQL_PORT/g" /usr/local/src/jobscheduler/install.xml

    /usr/local/src/jobscheduler/setup.sh -u /usr/local/src/jobscheduler/install.xml
fi

sleep infinity
