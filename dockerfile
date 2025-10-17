# Use Node.js LTS
FROM node:20-alpine

# Install PostgreSQL client
RUN apk add --no-cache postgresql-client

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy application code
COPY . .

# Build the application
RUN npm run build

# Expose port (this should match your app's internal port)
EXPOSE 5000

# Set environment variables
ENV NODE_ENV=production
ENV HOST=0.0.0.0
ENV PORT=5000

# Start the application
CMD ["npm", "start"]