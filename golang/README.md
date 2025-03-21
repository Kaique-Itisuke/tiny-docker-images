## About the application
This Golang application implements a simple health check endpoint (`/health`) using the [GoFiber web framework](https://github.com/gofiber/fiber). Upon receiving a GET request, it returns an HTTP 200 status code with a JSON response: `{"message": "healthy"}`.

![Health Endpoint](assets/images/health-endpoint.png)

## About the base Docker image
This highly optimized Go application is packaged as a compact, **6.48MB** single binary. Built with a multi-stage Docker build and deployed in a scratch container, it achieves a minimal footprint and zero known vulnerabilities.

![Base Golang Docker Image](assets/images/base-image-size.png)

## About the final Docker image compressing the GO binary
A highly optimized **2MB** Go image, statically linked and [UPX-compressed](https://github.com/upx/upx) for minimal size. Built with a multi-stage Docker process and deployed in a `scratch` (distroless) container, it delivers a secure, zero-vulnerability runtime.

![Final Golang Docker Image](assets/images/final-image-size.png)

## Usage

### Makefile Help

This project's Makefile provides a suite of commands to streamline Docker image management, including building, running, inspecting, analyzing, minifying, and checking for vulnerabilities.

To view a detailed list of available commands and their descriptions, run:

```bash
make help
```

![Makefile help command](../assets/images/makefile-help.png)

### Build the image and run the container
```bash
make up
```
![Running Container](assets/images/running-container.png)

### Access the health endpoint
[http://localhost:3000/health](http://localhost:3000/health)

![Health Endpoint](assets/images/health-endpoint.png)

### Show the Docker image size
```bash
make size
```
![Image Size](assets/images/image-size.png)

### Inspect each layer and files inside the Docker image using [Dive](https://github.com/wagoodman/dive) interactive UI
```bash
make inspect
```
![Image Inspect](assets/images/image-inspect.png)

### Check if the Docker image has an acceptable size and wasted space ratio using [Dive](https://github.com/wagoodman/dive) CI mode
```bash
make check
```
![Image Check](assets/images/image-check.png)

### Minify the Docker image using [MinToolkit](https://github.com/mintoolkit/mint) and compare sizes with the original image
```bash
make min
```
![Minified Image](assets/images/minified-image.png)

> SlimToolkit's optimization process did not result in a size reduction. The image's minimal footprint (2MB) is achieved by using scratch (distroless) as the base and directly copying the statically linked Go binary from the builder stage, which already results in a highly optimized image.

### Show the Docker image differences between the original vs minified version using [diffoci](https://github.com/reproducible-containers/diffoci)
#### Requirements
- [Golang 1.21 version or later](https://go.dev/doc/install)

#### Install the [diffoci](https://github.com/reproducible-containers/diffoci) as a global package using Go
```bash
make diff-install
```

#### Generate a text file, `diff-original-vs-minified-image.txt`, containing the differences between the original and minified Docker images [diffoci](https://github.com/reproducible-containers/diffoci)
```bash
make diff
```

![Original vs Minified Image](../assets/images/diff-images-file.png)

### Security scan to the original image to find known vulnerabilities (CVEs) and sensitive information and secrets using [Trivy](https://github.com/aquasecurity/trivy)
```bash
make sec
```
![Security Scan Example](assets/images/security-scan-example.png)

> A Trivy scan of the node:lts-bookworm (Debian 12.9) base image revealed multiple vulnerabilities. In contrast, this project's Golang image, built using a distroless image with only the compiled Go binary, showed zero vulnerabilities as you can see in the print bellow.

![Golang image Security Scan](assets/images/golang-image-security-scan.png)

### Perform a software catalog scan to generate a Software Bill of Materials (SBOM) of the docker image, utilizing the [Syft](https://github.com/anchore/syft) tool

### SBOM of the base image
```bash
make sbom
```
![SBOM of the base image](assets/images/sbom-base-image.png)
> Using the scratch image, both the base and minified images include solely the Go runtime executable, with no additional OS resources or binaries.
