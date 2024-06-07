.DEFAULT_GOAL := info
# https://docs.docker.com/engine/reference/commandline/compose_start/

build:
	#docker build -t pwndocker .
	docker compose up --build -d

despawn:
	docker compose down

shell:
	docker exec -it pwnbox /bin/bash

spawn:
	docker compose up -d
	@#docker run -d --cap-add all --privileged --name pwnbox --mount 'type=volume,src=pwnbox-chals,dst=/chals' pwnbox sleep infinity

start:
	docker compose start

stop:
	docker compose stop

status:
	docker ps -a
