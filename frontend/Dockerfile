# Build stage: Use .env.production during npm run build
FROM node:22-alpine AS builder

WORKDIR /app

# Copy package files first for caching
COPY package*.json ./

# Install all deps (including dev for build)
RUN npm ci

# Copy source code
COPY . .

# Build with production env vars (static/private vars baked in)
RUN --mount=type=bind,source=.env.production,target=.env.production \
    npm run build

# Prune to production deps only
RUN npm ci --omit=dev --ignore-scripts

# Runtime stage: Lean production image
FROM node:22-alpine AS runner

WORKDIR /app

# Copy built app and prod node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./

# Production settings
ENV NODE_ENV=production
ENV VITE_PORT=80
ENV VITE_HOST=0.0.0.0
EXPOSE $VITE_PORT

CMD ["npm", "run", "preview"]
