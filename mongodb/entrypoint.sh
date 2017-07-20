#!/usr/bin/env bash
echo "Creating mongo users..."
docker exec -it mongodb-service /bin/bash
mongo admin  --eval "db.createUser({user: 'pushmedia', pwd: '12345678', roles: [{role: 'userAdminAnyDatabase', db: 'admin'}]});"
echo "Mongo users created."
