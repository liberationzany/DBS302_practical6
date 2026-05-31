$ErrorActionPreference = "Continue"

Set-Location (Resolve-Path (Join-Path $PSScriptRoot ".."))

Write-Host "Admin authentication status:"
docker compose exec mongo mongosh --quiet --host 127.0.0.1 --port 27017 --tls --tlsCAFile /certs/mongo/ca.crt -u rootAdmin -p rootStrongPwd --authenticationDatabase admin --eval "db.runCommand({ connectionStatus: 1 })"

Write-Host "`nappUser allowed insert/find on myapp.customers:"
docker compose exec mongo mongosh --quiet --host 127.0.0.1 --port 27017 --tls --tlsCAFile /certs/mongo/ca.crt -u appUser -p appStrongPwd --authenticationDatabase myapp --eval "db = db.getSiblingDB('myapp'); db.customers.insertOne({ name: 'TLS Test', city: 'Thimphu' }); db.customers.find({}, { _id: 0 }).toArray()"

Write-Host "`nappUser denied access to admin.system.users:"
docker compose exec mongo mongosh --quiet --host 127.0.0.1 --port 27017 --tls --tlsCAFile /certs/mongo/ca.crt -u appUser -p appStrongPwd --authenticationDatabase myapp --eval "try { db = db.getSiblingDB('admin'); db.system.users.find().toArray() } catch (e) { print(e.name + ': ' + e.message) }"

Write-Host "`nUnauthenticated access should be denied:"
docker compose exec mongo mongosh --quiet --host 127.0.0.1 --port 27017 --tls --tlsCAFile /certs/mongo/ca.crt --eval "try { db.getSiblingDB('admin').system.users.find().toArray() } catch (e) { print(e.name + ': ' + e.message) }"

Write-Host "`nPlain non-TLS connection should fail:"
docker compose exec mongo mongosh --quiet --host 127.0.0.1 --port 27017 --eval "db.runCommand({ ping: 1 })"
