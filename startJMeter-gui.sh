#!/bin/sh

cwd=$(pwd)
java -Xms1024m -Xmx1024m -jar "$cwd/apache-jmeter-2.9/bin/ApacheJMeter.jar" -j /tmp/jmeter.log &
