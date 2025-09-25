FROM node:18 AS build-client
WORKDIR /app/client
COPY client/package*.json ./
RUN npm install
COPY client/ ./
RUN npm run build || echo "Build step skipped (no bundler configured)"

FROM node:18
RUN apt-get update && apt-get install -y ffmpeg && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY server/package*.json ./server/
WORKDIR /app/server
RUN npm install
COPY server/ ./
COPY --from=build-client /app/client/dist ../client/dist
EXPOSE 4000
CMD ["node", "server.js"]
