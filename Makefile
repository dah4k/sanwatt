# Copyright 2025 dah4k
# SPDX-License-Identifier: EPL-2.0

DOCKER      ?= docker
APP_NAME    ?= $(shell basename $(PWD))
_TAG        := local/$(APP_NAME)-data
_ANSI_NORM  := \033[0m
_ANSI_CYAN  := \033[36m

.PHONY: help usage
help usage:
	@grep -hE '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?##"}; {printf "$(_ANSI_CYAN)%-20s$(_ANSI_NORM) %s\n", $$1, $$2}'

.PHONY: $(_TAG)
$(_TAG): Dockerfile-data
	$(DOCKER) build --tag $(_TAG) --file Dockerfile-data .

.PHONY: all
all: $(_TAG) ## Build container image

.PHONY: test
test: $(_TAG) ## Test run container image
	$(DOCKER) run --rm --name=$(APP_NAME) $(_TAG)

.PHONY: debug
debug: $(_TAG) ## Debug container image
	$(DOCKER) run --interactive --tty --rm --entrypoint=/bin/bash $(_TAG)

.PHONY: clean
clean: ## Remove container image
	$(DOCKER) image remove --force $(_TAG)

.PHONY: distclean
distclean: clean ## Prune all container images
	$(DOCKER) image prune --force
	$(DOCKER) system prune --force
