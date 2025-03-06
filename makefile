.SILENT:
.PHONY: build down run run-min ps size size-min sizes up up-min check check-min inspect inspect-min xray xray-min minify min sec sec-min diff-install diff sbom sbom-min

IMAGE_NAME = "tiny-$(LANG)-docker-image"
MINIFIED_IMAGE_NAME = "tiny-$(LANG)-docker-image.slim"
CONTAINER_NAME = "tiny-$(LANG)-docker-container"
MINIFIED_CONTAINER_NAME = "tiny-$(LANG)-docker-container.slim"

DOCKER_HIT_N_RUN_CMD = docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock
DOCKER_RUN_CMD = docker run -d -p $(PORT):$(PORT)
DOCKER_SIZE_CMD = docker images
DOCKER_PS_CMD = docker ps --filter "name= $(CONTAINER_NAME)" --filter "name= $(MINIFIED_CONTAINER_NAME)"
MINIFY_CMD = $(DOCKER_HIT_N_RUN_CMD) mintoolkit/mint slim --include-workdir --http-probe-fail-on-status-5xx --http-probe-off --http-probe-cmd http:get:/health
CHECK_CMD = $(DOCKER_HIT_N_RUN_CMD) wagoodman/dive --ci
INSPECT_CMD = $(DOCKER_HIT_N_RUN_CMD) wagoodman/dive
XRAY_CMD = $(DOCKER_HIT_N_RUN_CMD) mintoolkit/mint xray
SECURITY_CMD = $(DOCKER_HIT_N_RUN_CMD) aquasec/trivy image --severity HIGH,CRITICAL --exit-code 1 --image-src docker
DIFF_INSTALL_CMD = go install github.com/reproducible-containers/diffoci/cmd/diffoci@latest
DIFF_CMD = diffoci diff --semantic --backend=local
SBOM_CMD = $(DOCKER_HIT_N_RUN_CMD) anchore/syft

help:
	@echo "Makefile Help:"
	@echo "  build         : Builds the Docker image."
	@echo "  down          : Removes running Docker containers."
	@echo "  run           : Runs the Docker image in a container."
	@echo "  run-min       : Runs the minified Docker image in a container."
	@echo "  ps            : Lists running Docker containers."
	@echo "  size          : Shows the size of the Docker image."
	@echo "  size-min      : Shows the size of the minified Docker image."
	@echo "  sizes         : Shows the sizes of both Docker images."
	@echo "  up            : Builds, runs, and shows the size of the Docker image."
	@echo "  up-min        : Runs the minified image and shows its size."
	@echo "  check         : Checks the Docker image's layers with dive (CI mode)."
	@echo "  check-min     : Checks the minified image's layers with dive (CI mode)."
	@echo "  inspect       : Inspects the Docker image's layers with dive."
	@echo "  inspect-min   : Inspects the minified image's layers with dive."
	@echo "  xray          : Performs a basic xray analysis of the Docker image."
	@echo "  xray-min      : Performs a basic xray analysis of the minified Docker image."
	@echo "  minify        : Minifies the Docker image using mintoolkit."
	@echo "  min           : Minifies the image and shows the sizes."
	@echo "  sec           : Performs a security scan of the Docker image using trivy."
	@echo "  sec-min       : Performs a security scan of the minified Docker image using trivy."
	@echo "  diff-install  : Installs diffoci."
	@echo "  diff          : Generates a diff between the original and minified images."
	@echo "  sbom          : Generates a Software Bill of Materials (SBOM) for the Docker image."
	@echo "  sbom-min      : Generates a Software Bill of Materials (SBOM) for the minified Docker image."

build:
	docker build -t $(IMAGE_NAME) .

down:
	docker rm -f "$(CONTAINER_NAME)" "$(MINIFIED_CONTAINER_NAME)" 2>/dev/null

run:
	$(DOCKER_RUN_CMD) --name $(CONTAINER_NAME) $(IMAGE_NAME)

run-min:
	$(DOCKER_RUN_CMD) --name $(MINIFIED_CONTAINER_NAME) $(MINIFIED_IMAGE_NAME)

ps:
	$(DOCKER_PS_CMD)

size:
	$(DOCKER_SIZE_CMD) $(IMAGE_NAME)

size-min:
	$(DOCKER_SIZE_CMD) $(MINIFIED_IMAGE_NAME)

sizes:
	$(DOCKER_SIZE_CMD) | grep -E "$(IMAGE_NAME)|$(MINIFIED_IMAGE_NAME)"

up: build down run ps size

up-min: down run-min ps size-min

check:
	$(CHECK_CMD) $(IMAGE_NAME)

check-min:
	$(CHECK_CMD) $(MINIFIED_IMAGE_NAME)

inspect:
	$(INSPECT_CMD) $(IMAGE_NAME)

inspect-min:
	$(INSPECT_CMD) $(MINIFIED_IMAGE_NAME)

xray:
	$(XRAY_CMD) $(IMAGE_NAME)

xray-min:
	$(XRAY_CMD) $(MINIFIED_IMAGE_NAME)

minify:
	$(MINIFY_CMD) $(IMAGE_NAME)

min: minify sizes

sec:
	$(SECURITY_CMD) $(IMAGE_NAME)

sec-min:
	$(SECURITY_CMD) $(MINIFIED_IMAGE_NAME)

diff-install:
	$(DIFF_INSTALL_CMD)

diff: sizes
	$(DIFF_CMD) docker://$(IMAGE_NAME) docker://$(MINIFIED_IMAGE_NAME) > diff-original-vs-minified-image.txt

sbom:
	$(SBOM_CMD) $(IMAGE_NAME)

sbom-min:
	$(SBOM_CMD) $(MINIFIED_IMAGE_NAME)
