FROM node:20-alpine
RUN apk add --no-cache openssl

EXPOSE 3000

WORKDIR /app

ENV NODE_ENV=production

COPY package.json package-lock.json* ./

# Use npm install to avoid failing when lockfile isn't present in build context
RUN npm install --omit=dev && npm cache clean --force
# Remove CLI packages since we don't need them in production by default.
# Remove this line if you want to run CLI commands in your container.
RUN npm remove @shopify/cli

COPY . .

# Generate Prisma client before building
RUN npx prisma generate && npm run build

CMD ["npm", "run", "docker-start"]
