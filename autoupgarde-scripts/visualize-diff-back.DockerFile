# Use the node image from official Docker Hub
FROM node:20.11.0-alpine

COPY visualize-diff-back/package*.json .
COPY visualize-diff-back/server.js .
# Install the project dependencies
RUN npm install
# Build the Vue.js application to the production mode to dist folder
ENTRYPOINT node server.js
