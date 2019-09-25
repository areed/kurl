.PHONY: image shell

image:
	docker build -f Dockerfile -t kurl/e2e .

shell:
	@docker run --rm -it \
		--volume=${PWD}/gcp:/e2e/gcp \
		--volume=${PWD}/bin:/e2e/bin \
		--env='GOOGLE_CREDENTIALS=$(shell cat ~/secrets/replicated-qa.json)' kurl/e2e sh
