all: build

.PHONY: build
build:
	@echo -n "Build devenv image"
	@docker build . -t reenjii/devenv
	@docker images reenjii/devenv

.PHONY: update
update:
	@./dependencies.sh
