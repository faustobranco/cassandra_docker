#!/bin/sh

set -e

_sed_in_place() {
  local filename="$1"; shift
  local tempFile
  tempFile="$(mktemp)"
  sed "$@" "$filename" > "$tempFile"
  cat "$tempFile" > "$filename"
  rm "$tempFile"
}

IPV4_ADDRESS=$(hostname -i | awk '{print $1}')
_sed_in_place "${CASSANDRA_CONFIG}/cassandra.yaml" -r 's/(- seeds:).*/\1 '"$IPV4_ADDRESS"'/'
_sed_in_place "${CASSANDRA_CONFIG}/cassandra.yaml" -r 's/^(# )?(listen_address:).*/\2 '"$IPV4_ADDRESS"'/'
_sed_in_place "${CASSANDRA_CONFIG}/cassandra.yaml" -r 's/^(# )?(broadcast_address:).*/\2 '"$IPV4_ADDRESS"'/'
_sed_in_place "${CASSANDRA_CONFIG}/cassandra.yaml" -r 's/^(# )?(rpc_address:).*/\2 0.0.0.0/'
_sed_in_place "${CASSANDRA_CONFIG}/cassandra.yaml" -r 's/^(# )?(broadcast_rpc_address:).*/\2 '"$IPV4_ADDRESS"'/'
_sed_in_place "${CASSANDRA_CONFIG}/cassandra.yaml" -r 's/(authenticator:).*/\1 PasswordAuthenticator/'
_sed_in_place "${CASSANDRA_CONFIG}/cassandra.yaml" -r 's/(authorizer:).*/\1 CassandraAuthorizer/'
_sed_in_place "${CASSANDRA_CONFIG}/cassandra.yaml" -r 's/(cluster_name:).*/\1 '${CASSANDRA_CLUSTER_NAME}'/'

exec "$@"
