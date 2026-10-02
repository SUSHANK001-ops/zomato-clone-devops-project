# Use an official Node.js image as the base (LTS version for stability)
FROM node:18-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json first (Leverage Docker cache)
COPY package*.json ./

# Install ALL dependencies in a clean environment (React needs build tools)
RUN npm ci

# Copy the rest of the application source code
COPY . .

# Bypass the Create React App eslint version conflict
ENV SKIP_PREFLIGHT_CHECK=true

# Disable the built-in ESLint to prevent the package path export crash
ENV DISABLE_ESLINT_PLUGIN=true

# Fix OpenSSL 3.0 hash conflict with legacy React Webpack
ENV NODE_OPTIONS=--openssl-legacy-provider

# Build the React app
RUN npm run build

# ---- Production Stage ----
FROM node:18-alpine

# Set the working directory
WORKDIR /app

# Copy the built React app from the builder stage
COPY --from=builder /app .

# Expose the port the app runs on
EXPOSE 3000

# Start the application
CMD ["npm", "start"]