#!/bin/bash

set -e

cd /e2e/gcp
terraform destroy -auto-approve
