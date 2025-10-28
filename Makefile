.PHONY: all deps

ENV_VAR_FILE := "./terraform/environments/$(ENVIRONMENT)/terraform.tfvars"
BACKEND_CONF := "./terraform/environments/$(ENVIRONMENT)/backend.conf"

# Default target
all: plan

# Install pipenv and the required dependencies for the backend (prod/dev)
install-deps:
	@echo "[INFO] Installing pipenv and dependencies in the backend"
	@cd backend && python -m pip install --no-input pipenv && python -m pipenv install

# Install the development dependencies for the backend
install-dev-deps:
	@echo "[INFO] Installing pipenv and development dependencies in the backend"
	@cd backend && python -m pip install --no-input pipenv && python -m pipenv install --dev

build-lambda-layer:
	@echo "Building Lambda layer..."
	mkdir -p terraform/build
	rm -f terraform/build/lambda_layer.zip
	mkdir -p python
	pip install -r requirements.txt -t python/
	cd python && zip -q -r ../terraform/build/lambda_layer.zip .
	rm -rf python
	@echo "Lambda layer built at terraform/build/lambda_layer.zip"

terraform-init:
	@echo "[INFO] Initialiasing terraform with config $(BACKEND_CONF), environment file $(ENV_VAR_FILE)"
	@cd terraform/aws-common-infra && terraform init -reconfigure -backend-config=../environments/$(ENVIRONMENT)/backend.conf -no-color
	
terraform-plan:
	@cd terraform/aws-common-infra && terraform plan -no-color -var-file=../environments/$(ENVIRONMENT)/terraform.tfvars -out=plan.out

terraform-apply:
	@cd terraform/aws-common-infra && terraform apply -no-color -auto-approve plan.out

terraform-destroy:
	@echo "[INFO] Destroying the environment using config $(BACKEND_CONF)"
	@cd terraform/aws-common-infra && terraform destroy -no-color -auto-approve -var-file=terraform.tfvars -var-file=../environments/$(ENVIRONMENT)/terraform.tfvars

terraform-validate:
	@echo "[INFO] Validating terraform code."
	@cd terraform/aws-common-infra && terraform validate -no-color -var-file=../environments/$(ENVIRONMENT)/terraform.tfvars