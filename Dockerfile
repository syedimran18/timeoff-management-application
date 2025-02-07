# Use Node.js with Alpine for dependencies (more stable than alpine:latest)
FROM node:16-alpine AS dependencies

# Install required build dependencies
RUN apk add --no-cache python3 make g++

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json first for better caching
COPY package.json ./

# Remove any outdated node_modules (in case of rebuilds)
RUN rm -rf node_modules

# Install dependencies
RUN npm install --production

# Copy source files (excluding node_modules to avoid overwrites)
COPY . .

# Create final runtime container
FROM node:16-alpine

# Labels for metadata
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.docker.cmd="docker run -d -p 3000:3000 --name alpine_timeoff"

# Set working directory
WORKDIR /app

# Create a system user for security
RUN adduser --system app --home /app
USER app

# Copy application files
COPY --from=dependencies /app /app

# Expose the application port
EXPOSE 3000

# Default command to start the app
CMD ["npm", "start"]
