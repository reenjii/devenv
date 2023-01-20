all: up

.PHONY: up
up:
	@docker-compose -f docker-compose.yml up -d

.PHONY: down
down:
	@docker-compose -f docker-compose.yml down

.PHONY: ps
ps:
	@docker-compose -f docker-compose.yml ps
