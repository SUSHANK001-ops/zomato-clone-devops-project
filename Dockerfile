# Use Node 16 which is natively compatible with older react-scripts
FROM node:16-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json first
COPY package*.json ./

# Use legacy-peer-deps to prevent strict npm version conflicts
RUN npm install --legacy-peer-deps

# Copy the rest of the application source code
COPY . .

# Build the React app (Node 16 won't throw OpenSSL or ESLint export errors)
RUN npm run build

# ---- Production Stage ----
FROM node:16-alpine

# Set the working directory
WORKDIR /app

# Copy the built React app from the builder stage
COPY --from=builder /app .

# Expose the port the app runs on
EXPOSE 3000

# Start the application
CMD ["npm", "start"]