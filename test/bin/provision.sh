#!/bin/bash

set -e

mkdir -p /.ssh
ssh-keygen -t rsa -b 2048 -C "kurl" -q -f /.ssh/id_rsa -N ""

cd /e2e/gcp
instance_id=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c4 | tr '[:upper:]' '[:lower:]')
terraform apply -input=false -var "id=$instance_id"
