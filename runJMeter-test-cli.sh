#!/bin/sh

if [ $# -eq 0 ] ; then
    echo 'Usage: runJMeter-test-cli.sh canvas-course-activity-load-test.jmx'
    exit 0
fi

cwd=$(pwd)
java -Xms1024m -Xmx2048m -jar "$cwd/apache-jmeter-2.9/bin/ApacheJMeter.jar" -n -j /tmp/jmeter.log -t "$cwd/$1" &