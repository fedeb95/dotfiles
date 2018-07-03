#!/bin/bash
STATUS=`nmcli networking connectivity`
if [ $STATUS == "pieno" ]; then
    nmcli networking off;
else
    nmcli networking on;
fi;
