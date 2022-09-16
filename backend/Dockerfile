FROM node:16 AS node-build
WORKDIR /node-app
COPY package.json .
COPY src ./src
RUN npm install --only=prod

# Reduce container size by use node-slim (smaller version without npm)
FROM node:16-slim AS node-run
WORKDIR /node-app
COPY --from=node-build /node-app .
ENV PORT=3000 NODE_ENV=production TEST_TOKEN=tranvanviet
EXPOSE 3000
CMD ["node", "src/index.js"]
