# Stage 1: Building the Next.js application
FROM node:18-alpine AS builder

WORKDIR /app

# Install Yarn and other necessary tools
RUN apk add --no-cache yarn git

# Copy package.json and yarn.lock
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn install --frozen-lockfile

# Copy the rest of the application code
COPY . .

# Set NextAuth secret and URL
ENV NEXTAUTH_SECRET=your_nextauth_secret_here
ENV NEXTAUTH_URL=https://your-production-url.com

# Generate Prisma client
RUN npx prisma generate

# Build the Next.js application
RUN yarn build

# Stage 2: Running the Next.js application
FROM node:18-alpine AS runner

WORKDIR /app

ENV NODE_ENV production
ENV NEXTAUTH_SECRET=your_nextauth_secret_here
ENV NEXTAUTH_URL=https://neoflames.com

# Install Yarn and other necessary tools
RUN apk add --no-cache yarn git

# Add a non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001

# Copy built assets from the builder stage
COPY --from=builder /app/next.config.js ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/yarn.lock ./yarn.lock
COPY --from=builder /app/prisma ./prisma

# Set correct permissions
RUN chown -R nextjs:nodejs /app

# Switch to non-root user
USER nextjs

# Expose the listening port
EXPOSE 3000

# Run the application
CMD ["yarn", "start"]