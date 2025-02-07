# Use Node.js with Alpine for dependencies (more stable than alpine:latest)
FROM node:16-alpine AS dependencies

RUN apk add --no-cache python3 make g++

WORKDIR /app

COPY package.json ./

RUN rm -rf node_modules

RUN npm install --production

COPY . .

# Create final runtime container
FROM node:16-alpine

# Labels for metadata
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.docker.cmd="docker run -d -p 3000:3000 --name alpine_timeoff"

WORKDIR /app

RUN adduser --system app --home /app
USER app

# Copy application files
COPY --from=dependencies /app /app

EXPOSE 3000

CMD ["npm", "start"]
