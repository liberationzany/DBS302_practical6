# Practical 6b Screenshot Checklist

Take screenshots at these points and paste them into `REPORT.md`.

## Redis

1. `docker compose up -d` showing services started.
2. `.\scripts\test-redis.ps1` or `./scripts/test-redis.sh` section showing Redis version.
3. Admin ACL test showing `ACL WHOAMI`, `SET mykey hello`, and `GET mykey`.
4. `app_user` test showing successful `SET session6b:user123 data`.
5. `app_user` denied test showing `NOPERM` for `SET otherkey oops`.
6. Monitoring user denied test showing write operation blocked.
7. Plain non-TLS connection test showing connection failure.
8. `redis/redis.conf` showing ACL and TLS configuration.

## MongoDB

1. `mongo/init/01-security.js` showing `myApp6bRole` and `appUser6b`.
2. `mongo/mongod.conf` showing `authorization: "enabled"` and `mode: requireTLS`.
3. `.\scripts\test-mongo.ps1` or `./scripts/test-mongo.sh` admin `connectionStatus` output.
4. `appUser6b` successful insert/find on `myapp6b.customers`.
5. `appUser6b` denied access to `admin.system.users`.
6. Unauthenticated access denied.
7. Plain non-TLS connection failure.

## Final Report

1. Security audit summary table in `REPORT.md`.
2. Conclusion section after you fill in your observed outputs.
