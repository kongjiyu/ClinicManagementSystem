#!/usr/bin/env pwsh
# Stop on error
$ErrorActionPreference = 'Stop'

# Clean up previous build container if it exists
docker rm -f clinic-war-build -ErrorAction SilentlyContinue

# Build a temporary build container
docker build `
  --target build-env `
  -t clinic-war-builder:latest .

# Create a container from it
$containerId = docker create --name clinic-war-build clinic-war-builder:latest

# Make sure deploy/artifacts exists
New-Item -ItemType Directory -Path ".\deploy\artifacts" -Force | Out-Null

# Copy the WAR out
docker cp "$($containerId):/usr/app/target/ROOT.war" ".\deploy\artifacts\"

# Clean up build container
docker rm $containerId

Write-Host "✅ WAR build complete: deploy/artifacts/ROOT.war"
