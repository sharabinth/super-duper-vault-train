#!/usr/bin/env bash

  ##  Usage Example: 
  ##      ./ldaplogin.sh 'MyPassIsTooSimple$#@#)GOOALZ' 'rronaldo'

AD_PASSPHRASE="${1}"
AD_GROUP_NAME="${2}"

echo "${VAULT_ADDR}/v1/auth/ldap/login/${AD_GROUP_NAME}"

curl -sk -d "{\"password\": \"${AD_PASSPHRASE}\"}" "${VAULT_ADDR}/v1/auth/ldap/login/${AD_GROUP_NAME}" | jq

export VAULT_TOKEN=$(curl -sk -d "{\"password\": \"${AD_PASSPHRASE}\"}" "${VAULT_ADDR}/v1/auth/ldap/login/${AD_GROUP_NAME}" | jq '.auth.client_token' | cut -d'"' -f 2)


echo ${VAULT_TOKEN:0:5}

curl -sk --header "X-Vault-Token: ${VAULT_TOKEN}" --request GET ${VAULT_ADDR}/v1/auth/token/lookup-self | jq '.data.id'
