#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REDIS_DIR="$ROOT_DIR/certs/redis"
MONGO_DIR="$ROOT_DIR/certs/mongo"

mkdir -p "$REDIS_DIR" "$MONGO_DIR"

generate_service_cert() {
  local service="$1"
  local out_dir="$2"
  local ca_ext="$out_dir/ca.ext"
  local cert_ext="$out_dir/$service.ext"

  cat > "$ca_ext" <<EOF_CA
basicConstraints=critical,CA:TRUE
keyUsage=critical,keyCertSign,cRLSign
subjectKeyIdentifier=hash
EOF_CA

  cat > "$cert_ext" <<EOF_CERT
basicConstraints=CA:FALSE
keyUsage=digitalSignature,keyEncipherment
extendedKeyUsage=serverAuth
subjectAltName=DNS:localhost,IP:127.0.0.1
EOF_CERT

  openssl genrsa -out "$out_dir/ca.key" 4096
  openssl req -x509 -new -nodes -key "$out_dir/ca.key" -sha256 -days 365 \
    -out "$out_dir/ca.crt" \
    -subj "/C=BT/ST=Chukha/L=Phuntsholing/O=DBS302/OU=Lab/CN=$service-lab-ca" \
    -addext "basicConstraints=critical,CA:TRUE" \
    -addext "keyUsage=critical,keyCertSign,cRLSign" \
    -addext "subjectKeyIdentifier=hash"

  openssl genrsa -out "$out_dir/$service.key" 4096
  openssl req -new -key "$out_dir/$service.key" -out "$out_dir/$service.csr" \
    -subj "/C=BT/ST=Chukha/L=Phuntsholing/O=DBS302/OU=Lab/CN=localhost"
  openssl x509 -req -in "$out_dir/$service.csr" -CA "$out_dir/ca.crt" -CAkey "$out_dir/ca.key" \
    -CAcreateserial -out "$out_dir/$service.crt" -days 365 -sha256 -extfile "$cert_ext"
}

generate_service_cert "redis" "$REDIS_DIR"
generate_service_cert "mongo" "$MONGO_DIR"
cat "$MONGO_DIR/mongo.key" "$MONGO_DIR/mongo.crt" > "$MONGO_DIR/mongo.pem"

# Lab files are mounted read-only into non-root containers. They must be readable
# by the Redis and MongoDB service users inside Docker.
chmod 644 "$REDIS_DIR"/*.key "$MONGO_DIR"/*.key "$MONGO_DIR/mongo.pem"
echo "Certificates generated under $ROOT_DIR/certs"
