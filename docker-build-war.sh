#!/bin/bash
set -e

# Clean up previous build container if it exists
docker rm -f clinic-war-build 2>/dev/null || true

# Build a temporary build container
docker build \
  --target build-env \
  -t clinic-war-builder:latest .

# Create a container from it
docker create --name clinic-war-build clinic-war-builder:latest

# Make sure deploy/artifacts exists
mkdir -p ./deploy/artifacts

# Copy the WAR out
docker cp clinic-war-build:/usr/app/target/ROOT.war ./deploy/artifacts/

# Clean up build container
docker rm clinic-war-build

echo "✅ WAR build complete: deploy/artifacts/ROOT.war"
