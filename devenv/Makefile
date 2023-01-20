all: build

.PHONY: build
build:
	@echo -n "Build devenv image"
	@docker build . -t devenv
	@docker images devenv

.PHONY: update
update:
	@./dependencies.sh
