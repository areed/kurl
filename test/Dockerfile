FROM ubuntu:18.04

RUN apt update && apt install -y \
	curl \
	keychain

RUN curl -fsS https://releases.hashicorp.com/terraform/0.12.9/terraform_0.12.9_linux_amd64.zip | gunzip >terraform && chmod +x terraform && mv terraform /usr/local/bin

RUN mkdir /e2e
COPY gcp /e2e/gcp

RUN cd /e2e/gcp && terraform init

WORKDIR /e2e
