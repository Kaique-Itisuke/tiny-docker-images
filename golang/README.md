## Usage
### Build the image and run the container
```bash
make up
```

### Acess the health endpoint
[http://localhost:3000/health](http://localhost:3000/health)

### Show the Docker image size
```bash
make size
```

### Inspect each layer and files inside the Docker image using [Dive](https://github.com/wagoodman/dive) interactive UI
```bash
make inspect
```

### Check if the Docker image has an acceptable size and wasted space ratio using [Dive](https://github.com/wagoodman/dive) CI mode
```bash
make check
```