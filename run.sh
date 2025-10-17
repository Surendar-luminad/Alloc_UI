#!/bin/bash

# ScraperTrack Deployment Script

echo "Starting ScraperTrack deployment..."

# Build Docker image
echo "Building Docker image..."
docker build -t scrapertrack:latest .

# Stop and remove existing container
echo "Stopping existing container..."
docker stop scrapertrack 2>/dev/null || true
docker rm scrapertrack 2>/dev/null || true

# Run the container
echo "Starting new container..."
docker run -d \
  --name scrapertrack \
  --network="host" \
  -e PORT=20020 \
    -e DATABASE_URL="postgresql://postgres:Welcome123@host.docker.internal:5432/webnexus_db" \
  -e SESSION_SECRET="your-secret-key-here" \
  -e NODE_ENV="development" \
  -e SKIP_DB_CHECK="true" \
  -e ISSUER_URL="https://replit.com/oidc" \
  -e CLIENT_ID="your-client-id" \
  -e CLIENT_SECRET="your-client-secret" \
  --restart unless-stopped \
  scrapertrack:latest

echo "ScraperTrack is running on http://localhost:20020"
echo "Check logs with: docker logs -f scrapertrack"