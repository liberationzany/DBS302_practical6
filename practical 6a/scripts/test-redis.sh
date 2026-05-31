#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

echo "Redis version:"
docker compose exec redis redis-server --version

echo
echo "Admin login and ACL check:"
docker compose exec redis redis-cli --tls --cacert /certs/redis/ca.crt \
  -u rediss://admin:adminStrongPwd@127.0.0.1:6379 ACL WHOAMI
docker compose exec redis redis-cli --tls --cacert /certs/redis/ca.crt \
  -u rediss://admin:adminStrongPwd@127.0.0.1:6379 SET mykey hello
docker compose exec redis redis-cli --tls --cacert /certs/redis/ca.crt \
  -u rediss://admin:adminStrongPwd@127.0.0.1:6379 GET mykey

echo
echo "app_user allowed session key:"
docker compose exec redis redis-cli --tls --cacert /certs/redis/ca.crt \
  -u rediss://app_user:appStrongPwd@127.0.0.1:6379 ACL WHOAMI
docker compose exec redis redis-cli --tls --cacert /certs/redis/ca.crt \
  -u rediss://app_user:appStrongPwd@127.0.0.1:6379 SET session:user123 data
docker compose exec redis redis-cli --tls --cacert /certs/redis/ca.crt \
  -u rediss://app_user:appStrongPwd@127.0.0.1:6379 GET session:user123

echo
echo "app_user denied non-session key:"
set +e
docker compose exec redis redis-cli --tls --cacert /certs/redis/ca.crt \
  -u rediss://app_user:appStrongPwd@127.0.0.1:6379 SET otherkey oops
set -e

echo
echo "monitoring denied write operation:"
set +e
docker compose exec redis redis-cli --tls --cacert /certs/redis/ca.crt \
  -u rediss://monitoring:monitorPwd@127.0.0.1:6379 SET session:monitor nope
set -e

echo
echo "Plain non-TLS connection should fail:"
set +e
docker compose exec redis redis-cli -u redis://admin:adminStrongPwd@127.0.0.1:6379 PING
set -e
