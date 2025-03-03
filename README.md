# About

![Tiny Golang Docker Image](assets/images/tiny-docker-images-background.jpg)

This project provides highly optimized, minimal Docker container images for popular languages (Python, Go, Node.js), focusing on size, security, and runtime efficiency. We leverage a suite of tools to achieve these goals:

* **Image Minification:** [MinToolkit](https://github.com/mintoolkit/mint) for significant size reduction.
* **Vulnerability Scanning:** [Trivy](https://github.com/aquasecurity/trivy) for comprehensive security assessments.
* **Software Bill of Materials (SBOM) Generation:** [Syft](https://github.com/anchore/syft) for detailed component tracking.
* **Image Analysis:** [Dive](https://github.com/wagoodman/dive) for interactive layer inspection and efficiency checks.
* **Image Diffing:** [diffoci](https://github.com/reproducible-containers/diffoci) for detailed comparisons between images.

These tools enable us to create lean, secure, and efficient container images, reducing resource consumption and minimizing potential attack vectors.

**Key Benefits:**

* **Reduced Image Size:** Achieve substantial size reductions through minification.
* **Enhanced Security:** Identify and mitigate vulnerabilities with thorough security scans.
* **Improved Runtime Efficiency:** Eliminate unnecessary components for faster execution.
* **Transparent Component Tracking:** Generate SBOMs for complete visibility into image contents.
* **Detailed Image Analysis:** Understand image composition and optimize for efficiency.

# Requirements
- [Docker](https://www.docker.com/products/docker-desktop/) (Latest version)

# Dockerfile best practices
[Guide for writing production-worthy Docker images.](https://github.com/hexops-graveyard/dockerfile)

# Docker Bench for Security
[A script that checks for dozens of common best-practices around deploying Docker containers in production.](https://github.com/docker/docker-bench-security)