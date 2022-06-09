### This is the Terraform-generated header for ${ecr_name} ###
ECR_NAME_STAGE:=${ecr_name}
ECR_URL_STAGE:=${ecr_url}
### End of Terraform-generated header ###

### Terraform-generated Developer Deploy Commands for Dev environment ###
dist-stage: ## Build docker container (intended for developer-based manual build)
	docker build --platform linux/amd64 \
	    -t $(ECR_URL_STAGE):latest \
		-t $(ECR_URL_STAGE):`git describe --always` \
		-t $(ECR_NAME_STAGE):latest .

publish-stage: dist-stage ## Build, tag and push (intended for developer-based manual publish)
	docker login -u AWS -p $$(aws ecr get-login-password --region us-east-1) $(ECR_URL_STAGE)
	docker push $(ECR_URL_STAGE):latest
	docker push $(ECR_URL_STAGE):`git describe --always`
