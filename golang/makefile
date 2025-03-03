.SILENT:
.PHONY: build remove run size up check inspect xray compare-sizes slim minify

IMAGE_NAME = "tiny-go-docker-image"
MINIFIED_IMAGE_NAME = "tiny-go-docker-image.slim"
CONTAINER_NAME = "tiny-go-docker-container"

build:
	docker build -t $(IMAGE_NAME) .

remove:
	docker rm -f $(CONTAINER_NAME) 2>/dev/null

run:
	docker run -d -p 3000:3000 --name $(CONTAINER_NAME) $(IMAGE_NAME)

size:
	docker images $(IMAGE_NAME)

up: build remove run size

check:
	docker run -ti --rm -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive:latest --ci $(IMAGE_NAME)

inspect:
	docker run -ti --rm -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive:latest $(IMAGE_NAME)

xray:
	docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock mintoolkit/mint xray $(IMAGE_NAME)

compare-sizes:
	docker images | grep -E "$(IMAGE_NAME)|$(MINIFIED_IMAGE_NAME)"

slim:
	docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock mintoolkit/mint slim --http-probe-off --http-probe-cmd http:get:/health $(IMAGE_NAME)

minify: slim compare-sizes

security:
	docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image --severity HIGH,CRITICAL --exit-code 1 --image-src docker $(IMAGE_NAME)
