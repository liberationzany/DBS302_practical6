$ErrorActionPreference = "Stop"

$rootDir = Resolve-Path (Join-Path $PSScriptRoot "..")

docker run --rm `
  -v "${rootDir}:/work" `
  -w /work `
  node:20-alpine `
  sh -lc "apk add --no-cache bash openssl >/dev/null && bash scripts/generate-certs.sh"
