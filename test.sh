#!/bin/bash

box server start

curl http://127.0.0.1:12121/tests/runner.cfm\?propertiesSummary\=true\&reporter\=text

box server stop

if ! grep 'test.passed=true' tests/results/TEST.properties
then
	exit 1
else
	exit 0
fi