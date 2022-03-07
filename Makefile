.PHONY: help     # Generate list of targets with descriptions
help:
	@echo "\n"
	@grep '^.PHONY: .* #' Makefile | sed 's/\.PHONY: \(.*\) # \(.*\)/\1 \2/' | expand -t20

.PHONY: push2hub
push2bub:
	docker push ${Dockerimage}

.PHONY: clairscan
clairscan:
	docker run -d --rm --name db arminc/clair-db
	sleep 15 # wait for db to come up
	docker run --rm -p 6060:6060 --link db:postgres -d --name clair arminc/clair-local-scan
	sleep 10
	DOCKER_GATEWAY=$(docker network inspect bridge --format "{{range .IPAM.Config}}{{.Gateway}}{{end}}")
	wget -qO clair-scanner https://github.com/arminc/clair-scanner/releases/download/v8/clair-scanner_linux_amd64 && chmod +x clair-scanner
	./clair-scanner --ip="$DOCKER_GATEWAY" ${Dockerimage}

.PHONY: push2ecr
push2ecr:
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 680032936053.dkr.ecr.us-east-1.amazonaws.com
	docker tag ${Dockerimage} 680032936053.dkr.ecr.us-east-1.amazonaws.com/${ECR_Reponame}:${TagName}
	docker push 680032936053.dkr.ecr.us-east-1.amazonaws.com/${ECR_Reponame}:${TagName}

.PHONY: deploy_ecs
deploy_ecs:
	aws cloudformation create-stack --stack-name ${Stackname} --template-body file://configs/ecs-config.yml --parameters file://configs/template.json
	aws cloudformation wait stack-create-complete --stack-name ${Stackname}

.PHONY: deletestack
deletestack:
	aws cloudformation delete-stack --stack-name ${Stackname}
	aws cloudformation wait stack-delete-complete --stack-name ${Stackname}
