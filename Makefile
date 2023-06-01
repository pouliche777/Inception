.PHONY: build up down

# Variable pour suivre l'état de construction des images
BUILD_FLAG := .buildflag

build: $(BUILD_FLAG)

all: build up

$(BUILD_FLAG):
	docker-compose -f src/docker-compose.yml build
	@touch $(BUILD_FLAG)

up: build
	docker-compose -f src/docker-compose.yml up -d

down:
	docker-compose -f src/docker-compose.yml down
	@rm -f $(BUILD_FLAG)

