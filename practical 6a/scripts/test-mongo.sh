#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

echo "Admin authentication status:"
docker compose exec mongo mongosh --quiet \
  --host 127.0.0.1 --port 27017 \
  --tls --tlsCAFile /certs/mongo/ca.crt \
  -u rootAdmin -p rootStrongPwd --authenticationDatabase admin \
  --eval 'db.runCommand({ connectionStatus: 1 })'

echo
echo "appUser allowed insert/find on myapp.customers:"
docker compose exec mongo mongosh --quiet \
  --host 127.0.0.1 --port 27017 \
  --tls --tlsCAFile /certs/mongo/ca.crt \
  -u appUser -p appStrongPwd --authenticationDatabase myapp \
  --eval 'db = db.getSiblingDB("myapp"); db.customers.insertOne({ name: "TLS Test", city: "Thimphu" }); db.customers.find({}, { _id: 0 }).toArray()'

echo
echo "appUser denied access to admin.system.users:"
set +e
docker compose exec mongo mongosh --quiet \
  --host 127.0.0.1 --port 27017 \
  --tls --tlsCAFile /certs/mongo/ca.crt \
  -u appUser -p appStrongPwd --authenticationDatabase myapp \
  --eval 'try { db = db.getSiblingDB("admin"); db.system.users.find().toArray() } catch (e) { print(e.name + ": " + e.message) }'
set -e

echo
echo "Unauthenticated access should be denied:"
set +e
docker compose exec mongo mongosh --quiet \
  --host 127.0.0.1 --port 27017 \
  --tls --tlsCAFile /certs/mongo/ca.crt \
  --eval 'try { db.getSiblingDB("admin").system.users.find().toArray() } catch (e) { print(e.name + ": " + e.message) }'
set -e

echo
echo "Plain non-TLS connection should fail:"
set +e
docker compose exec mongo mongosh --quiet \
  --host 127.0.0.1 --port 27017 \
  --eval 'db.runCommand({ ping: 1 })'
set -e
