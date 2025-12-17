.PHONY: build run

build/lambda.zip:
	@mkdir -p build lambda/package
	@pip install -r lambda/requirements.txt -t lambda/package
	@cp lambda/lambda_function.py lambda/package/
	@cd lambda/package && zip -r ../../build/lambda.zip .
	@rm -rf lambda/package

run: build/lambda.zip
	@terraform init
	@terraform apply

clean:
	@rm -rf build

trigger:
	@aws --region us-east-1 lambda invoke --function-name hush_goat_lambda out.json
	@cat out.json
	@rm out.json
