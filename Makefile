.PHONY: help     # Generate list of targets with descriptions
help:
	@echo "\n"
	@grep '^.PHONY: .* #' Makefile | sed 's/\.PHONY: \(.*\) # \(.*\)/\1 \2/' | expand -t20

.PHONY: push_to_ecr
push2ecr:
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 680032936053.dkr.ecr.us-east-1.amazonaws.com
	docker tag alpine:latest 680032936053.dkr.ecr.us-east-1.amazonaws.com/alpine:v1.0
	docker push 680032936053.dkr.ecr.us-east-1.amazonaws.com/alpine:v1.0

