#!/usr/bin/env bash
mongo admin  --eval "db.createUser({user: 'pushmedia', pwd: '12345678', roles: [{role: 'userAdminAnyDatabase', db: 'admin'}]});"
exit
