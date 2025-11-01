ENV ?= develop
BACKEND_FILE := environments/$(ENV).backend.hcl
TFVARS_FILE := environments/$(ENV).tfvars

.PHONY: init init-reconfigure plan apply destroy validate fmt

init:
	terraform init -backend-config=$(BACKEND_FILE)

init-reconfigure:
	terraform init -reconfigure -backend-config=$(BACKEND_FILE)

plan:
	terraform plan -var-file=$(TFVARS_FILE)

apply:
	terraform apply -var-file=$(TFVARS_FILE)

destroy:
	terraform destroy -var-file=$(TFVARS_FILE)

validate:
	terraform validate

fmt:
	terraform fmt -recursive
