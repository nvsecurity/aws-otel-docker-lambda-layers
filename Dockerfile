# Use a slim Python image as the base
FROM python:3.11-slim

# Install dependencies: curl and unzip
RUN apt-get update && apt-get install -y \
    unzip \
    && apt-get clean

# Create the /opt directory where the files will be extracted
RUN mkdir -p /opt

# Set environment variables for AWS region
ENV AWS_REGION=us-east-1

# Create the /opt directory where the files will be extracted
RUN mkdir -p /opt

# Copy the locally downloaded ZIP file into the container
COPY aws-otel-python-amd64-ver-*.zip /opt/

# Unzip the file and remove the ZIP
RUN unzip /opt/aws-otel-python-amd64-ver-*.zip -d /opt && \
    rm /opt/aws-otel-python-amd64-ver-*.zip

# Set /opt as the working directory
WORKDIR /opt

# Verify the content of /opt
RUN ls -l /opt
