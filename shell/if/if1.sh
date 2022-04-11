#!/bin/bash

if [ ! -d /tmp/abc ]
   then
       mkdir -pv /tmp/abc
       echo "/tmp/abc has been created"
fi
