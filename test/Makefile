.PHONY: image shell

image:
	docker build -f Dockerfile -t kurl/e2e .

shell:
	@docker run --rm -it \
		--volume=${PWD}/bin:/e2e/bin \
		--env='GOOGLE_CREDENTIALS=$(shell cat ~/secrets/replicated-qa.json)' kurl/e2e sh
