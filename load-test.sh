#!/bin/sh -e

echo 'GET http://localhost:8080/' | vegeta attack -duration 60s -rate 20000 -output result.vegeta
vegeta report -inputs result.vegeta | grep -v 'connection reset by peer'
