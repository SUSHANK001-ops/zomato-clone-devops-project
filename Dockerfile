# ==========================================
# Stage 1: Build Stage using Node.js 20 LTS
# ==========================================
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package specifications
COPY package*.json ./

# Install dependencies
RUN npm install --legacy-peer-deps

# Copy application source code
COPY . .

# Build production bundle
RUN npm run build

# ==========================================
# Stage 2: Production Stage using Nginx Alpine
# ==========================================
FROM nginx:alpine

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy production build artifacts from builder stage
COPY --from=builder /app/build /usr/share/nginx/html

# Expose standard HTTP port
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]