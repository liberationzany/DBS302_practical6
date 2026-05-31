# Practical 6a: Securing Redis and MongoDB

This folder contains a complete runnable lab for Redis and MongoDB security:

- Redis authentication with ACL users.
- Redis TLS-only connections.
- MongoDB authentication and RBAC.
- MongoDB TLS-only connections.
- Audit commands and a report template with screenshot points.

## Requirements

- Docker Desktop or Docker Engine.
- WSL Ubuntu, Git Bash, or another Bash shell for `scripts/*.sh`.
- `openssl` available in the shell used to generate certificates.

## Run the Lab

From this folder in PowerShell:

```powershell
.\scripts\generate-certs.ps1
docker compose up -d
```

Or from Bash on Linux/WSL:

```bash
chmod +x scripts/*.sh
./scripts/generate-certs.sh
docker compose up -d
```

Wait until MongoDB finishes first-time initialization:

```bash
docker compose logs -f mongo
```

When the logs show MongoDB is waiting for connections, run the tests:

```powershell
.\scripts\test-redis.ps1
.\scripts\test-mongo.ps1
```

Or from Bash:

```bash
./scripts/test-redis.sh
./scripts/test-mongo.sh
```

## Reset the Lab

If you change MongoDB init users/roles, reset the named volume:

```bash
docker compose down -v
docker compose up -d
```

## Stop Services

```bash
docker compose down
```

## Main Files

- `redis/redis.conf`: Redis TLS and ACL configuration.
- `mongo/mongod.conf`: MongoDB TLS and authorization configuration.
- `mongo/init/01-security.js`: MongoDB app role and app user setup.
- `scripts/test-redis.sh`: Redis security audit commands.
- `scripts/test-mongo.sh`: MongoDB security audit commands.
- `REPORT.md`: Lab report draft.
- `SCREENSHOTS.md`: Screenshot checklist.
