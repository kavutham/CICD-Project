.PHONY: help     # Generate list of targets with descriptions
help:
	@echo "\n"
	@grep '^.PHONY: .* #' Makefile | sed 's/\.PHONY: \(.*\) # \(.*\)/\1 \2/' | expand -t20

.PHONY: push2ecr
push2ecr:
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 680032936053.dkr.ecr.us-east-1.amazonaws.com
	docker tag ${Dockerimage} 680032936053.dkr.ecr.us-east-1.amazonaws.com/${ECR_Reponame}:${TagName}
	docker push 680032936053.dkr.ecr.us-east-1.amazonaws.com/${ECR_Reponame}:${TagName}

.PHONY: deploy_ecs
deploy_ecs:
	aws cloudformation create-stack --stack-name ${Stackname} --template-body file://configs/ecs-config.yml --parameters file://configs/template.json
	aws cloudformation wait stack-create-complete --stack-name ${Stackname}

