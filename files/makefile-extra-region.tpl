### Add the following lines to the Makefile header:
ECR_URL_OTHER_DEV:=${ecr_url}
### End of Terraform-generated header


### Add the following lines to the docker build command in the dist-dev command
	    -t $(ECR_URL_OTHER_DEV):latest \
		-t $(ECR_URL_OTHER_DEV):`git describe --always` \


### Add the following lines to the publish-dev command:
publish-dev: dist-dev ## Build, tag and push (intended for developer-based manual publish)
	docker login -u AWS -p $$(aws ecr get-login-password --region ${region}) $(ECR_URL_OTHER_DEV)
	docker push $(ECR_URL_OTHER_DEV):latest
	docker push $(ECR_URL_OTHER_DEV):`git describe --always`


### Add the following line to the update-lambda-dev command if this is a Lambda Function
#	aws lambda update-function-code --region ${region} --function-name $(FUNCTION_DEV) --image-uri $(ECR_URL_OTHER_DEV):latest
