## About the application
This Node.js/Typescript application implements a simple health check endpoint (`/health`) using the [Fastify framework](https://github.com/fastify/fastify). Upon receiving a GET request, it returns an HTTP 200 status code with a JSON response: `{"message": "healthy"}`.

![Health Endpoint](assets/images/health-endpoint.png)

## About the base Docker image
A small **151MB** Node.js/Typescript image, using [NPM](https://github.com/npm/cli) as the package manager, multi-stage build to decrease the final image size and running in a [distroless image with debian 12](https://github.com/GoogleContainerTools/distroless?tab=readme-ov-file#debian-12).

![Tiny Golang Docker Image](assets/images/final-image-size.png)

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
[http://localhost:8080/health](http://localhost:8080/health)

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
> With a size of 120MB, the Node.js binary represents a significant portion, approximately 80%, of the 151MB total image size.

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

> SlimToolkit reduced the image size from 151MB to 134MB, a reduction of approximately 11%.

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
![Node image Security Scan](assets/images/node-image-security-scan.png)

> A Trivy scan of the tiny-node-docker-image (Debian 12) base image showed zero vulnerabilities. This is due to the image's highly minimized nature, containing only the Node.js binary and essential OS files.

### Security scan to the minified image to find known vulnerabilities (CVEs) and sensitive information and secrets using [Trivy](https://github.com/aquasecurity/trivy)
```bash
make sec-min
```
![Node image Security Scan](assets/images/node-min-image-security-scan.png)

> A Trivy scan of minified image showed zero vulnerabilities as expected based on the previous base image scan.

### Perform a software catalog scan to generate a Software Bill of Materials (SBOM) of the docker image, utilizing the [Syft](https://github.com/anchore/syft) tool

### SBOM of the base image
```bash
make sbom
```
![SBOM of the base image](assets/images/sbom-base-image.png)

### SBOM of the minified image
```bash
make sbom-min
```
![SBOM of the minified image](assets/images/sbom-minified-image.png)
> The minified image achieves a 93% reduction in resources compared to the base image, effectively eliminating unnecessary OS packages, files and binaries.

| Category      | Base Image        | Minified Image | Difference | Percentage Reduction |
|---------------|-------------------|----------------|------------|----------------------|
| Packages      | 58 packages       | 49 packages    | 9          | 15.52%%              |
| File Digests  | 1,306 files       | 49 files       | 1,257      | 96%                  |
| Executables   | 283 executables   | 11 executables | 272        | 96%                  |
| **Total**     | 4,218             | 173            | **1,538**  | **93%**              |