#!/usr/bin/env bash
litecli -e '.mode psql_unicode; source base_query.sql' cars.db > results.txt
# nvimpager results.txt
