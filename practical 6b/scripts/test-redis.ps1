$ErrorActionPreference = "Continue"

Set-Location (Resolve-Path (Join-Path $PSScriptRoot ".."))

Write-Host "Redis version:"
docker compose exec redis redis-server --version

Write-Host "`nAdmin login and ACL check:"
docker compose exec redis redis-cli --tls --cacert /certs/redis/ca.crt -u rediss://admin:adminStrongPwd@127.0.0.1:6379 ACL WHOAMI
docker compose exec redis redis-cli --tls --cacert /certs/redis/ca.crt -u rediss://admin:adminStrongPwd@127.0.0.1:6379 SET mykey hello
docker compose exec redis redis-cli --tls --cacert /certs/redis/ca.crt -u rediss://admin:adminStrongPwd@127.0.0.1:6379 GET mykey

Write-Host "`napp_user allowed session key:"
docker compose exec redis redis-cli --tls --cacert /certs/redis/ca.crt -u rediss://app_user:appStrongPwd@127.0.0.1:6379 ACL WHOAMI
docker compose exec redis redis-cli --tls --cacert /certs/redis/ca.crt -u rediss://app_user:appStrongPwd@127.0.0.1:6379 SET session6b:user123 data
docker compose exec redis redis-cli --tls --cacert /certs/redis/ca.crt -u rediss://app_user:appStrongPwd@127.0.0.1:6379 GET session6b:user123

Write-Host "`napp_user denied non-session key:"
docker compose exec redis redis-cli --tls --cacert /certs/redis/ca.crt -u rediss://app_user:appStrongPwd@127.0.0.1:6379 SET otherkey oops

Write-Host "`nmonitoring denied write operation:"
docker compose exec redis redis-cli --tls --cacert /certs/redis/ca.crt -u rediss://monitoring:monitorPwd@127.0.0.1:6379 SET session6b:monitor nope

Write-Host "`nPlain non-TLS connection should fail:"
docker compose exec redis redis-cli -u redis://admin:adminStrongPwd@127.0.0.1:6379 PING
