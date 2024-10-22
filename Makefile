# Set the version as an environment variable
VERSION ?= 1-21-0

# Set the URL command
URL_CMD=$(shell aws lambda get-layer-version-by-arn --arn arn:aws:lambda:us-east-1:901920570463:layer:aws-otel-python-amd64-ver-${VERSION}:1 --query Content.Location --output text)

# Define a target to download the ZIP file
download:
	curl "${URL_CMD}" -o aws-otel-python-amd64-ver-${VERSION}.zip

# Define a target to build the Docker image
build: download
	docker build --platform linux/amd64 --build-arg OTEL_VERSION=$(VERSION) -t nvsec/aws-otel-python:$(VERSION) .

# Define a target to remove the ZIP file
clean:
	rm -f aws-otel-python-amd64-ver-$(VERSION).zip

# Define a target to push the Docker image
push: build clean
	docker push nvsec/aws-otel-python:$(VERSION)

# Define a default target to perform the entire process (download, build, clean, push)
all: push
