KURL E2E Tests
=============

This directory holds a docker image with utilities for spinning up test instances with terraform.
Then use `make image shell` to run it.
In the shell use `bin/provision.sh` to spin up test instances and run the kurl installer on them.
Use `bin/destroy.sh` to destroy them afterwards.
All terraform state is local to the container; if the container exits before `bin/destroy.sh` completes you'll need to clean up those instances with `gcloud`.
