# aws-otel-python-container-layer

Docker images that contain the /opt/ contents of the AWS OpenTelemetry Lambda Layers. 

AWS does not publish these Lambda Layers as public containers, so we have to pull the layer contents and create them as containers ourselves so our Lambda containers can consume them.

DockerHub: https://hub.docker.com/r/nvsec/aws-otel-python/tags

> [!NOTE]
> For open source viewers: This is a quick adaptation that we needed to make at NightVision and thought could be useful to others. We do not intend on maintaining this; please fork it for yourself if you need to make changes.

# Building

* To build and push this image to DockerHub, do this in a single command:

```bash
make
```

The longer form command (feel free to adjust)

```bash
export VERSION=1-21-0
# This pulls the Lambda layer from the official AWS Lambda Layer ARN: https://aws-otel.github.io/docs/getting-started/lambda/lambda-python
URL=$(aws lambda get-layer-version-by-arn --arn arn:aws:lambda:us-east-1:901920570463:layer:aws-otel-python-amd64-ver-${VERSION}:1 --query Content.Location --output text)
curl $URL -o aws-otel-python-amd64-ver-${VERSION}.zip
docker build --platform linux/amd64 --build-arg OTEL_VERSION=$VERSION -t nvsec/aws-otel-python:$VERSION .
rm aws-otel-python-amd64-ver-${VERSION}.zip
docker push nvsec/aws-otel-python:$VERSION
```

# Usage

You can copy the contents from the /opt/ directory using a multi-stage build in your Dockerfile.

```dockerfile
# Start a multi stage build so you can access the file contents
FROM nvsec/aws-otel-python:1-21-0 AS lambda-layer-opentelemetry

# This is where you build your actual Lambda container
FROM public.ecr.aws/lambda/python:3.11 as build
# Then, copy the contents of the layer into your Lambda container.
COPY --from=lambda-layer-opentelemetry /opt/ /opt/
# Then, copy the rest of your Lambda code and proceed as normal.
```

# References

* AWS Blog on working with Lambda Layers in Container Images: https://aws.amazon.com/blogs/compute/working-with-lambda-layers-and-extensions-in-container-images/
