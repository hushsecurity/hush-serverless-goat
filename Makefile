.PHONY: build run

build:
	@mkdir -p build lambda/package
	@pip install -r lambda/requirements.txt -t lambda/package
	@cp lambda/lambda_function.py lambda/package/
	@cd lambda/package && zip -r ../../build/lambda.zip .
	@rm -rf lambda/package

run: build
	@echo "Initializing Terraform..."
	@terraform init
	@echo "Planning Terraform deployment..."
	@terraform plan
	@echo "Applying Terraform configuration..."
	@terraform apply
