$ErrorActionPreference = "Continue"

Set-Location (Resolve-Path (Join-Path $PSScriptRoot ".."))

Write-Host "Admin authentication status:"
docker compose exec mongo mongosh --quiet --host 127.0.0.1 --port 27017 --tls --tlsCAFile /certs/mongo/ca.crt -u rootAdmin -p rootStrongPwd --authenticationDatabase admin --eval "db.runCommand({ connectionStatus: 1 })"

Write-Host "`nappUser6b allowed insert/find on myapp6b.customers:"
docker compose exec mongo mongosh --quiet --host 127.0.0.1 --port 27017 --tls --tlsCAFile /certs/mongo/ca.crt -u appUser6b -p appStrongPwd6b --authenticationDatabase myapp6b --eval "db = db.getSiblingDB('myapp6b'); db.customers.insertOne({ name: 'TLS Test 6b', city: 'Thimphu' }); db.customers.find({}, { _id: 0 }).toArray()"

Write-Host "`nappUser6b denied access to admin.system.users:"
docker compose exec mongo mongosh --quiet --host 127.0.0.1 --port 27017 --tls --tlsCAFile /certs/mongo/ca.crt -u appUser6b -p appStrongPwd6b --authenticationDatabase myapp6b --eval "try { db = db.getSiblingDB('admin'); db.system.users.find().toArray() } catch (e) { print(e.name + ': ' + e.message) }"

Write-Host "`nUnauthenticated access should be denied:"
docker compose exec mongo mongosh --quiet --host 127.0.0.1 --port 27017 --tls --tlsCAFile /certs/mongo/ca.crt --eval "try { db.getSiblingDB('admin').system.users.find().toArray() } catch (e) { print(e.name + ': ' + e.message) }"

Write-Host "`nPlain non-TLS connection should fail:"
docker compose exec mongo mongosh --quiet --host 127.0.0.1 --port 27017 --eval "db.runCommand({ ping: 1 })"
