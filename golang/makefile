build:
	docker build -t tiny-go-docker-image .

remove:
	docker rm -f my-tiny-go-container 2>/dev/null

run:
	docker run -d -p 3000:3000 --name my-tiny-go-container tiny-go-docker-image

size:
	docker images tiny-go-docker-image

up: build remove run size

check:
	docker run -ti --rm -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive:latest --ci tiny-go-docker-image

inspect:
	docker run -ti --rm -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive:latest tiny-go-docker-image
