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

.PHONY: redisup
redisup:
	@docker-compose -f docker-compose.yml -f resources/docker-compose-redis.yml up -d

.PHONY: redisdown
redisdown:
	@docker-compose -f docker-compose.yml -f resources/docker-compose-redis.yml down

.PHONY: redisps
redisps:
	@docker-compose -f docker-compose.yml -f resources/docker-compose-redis.yml ps