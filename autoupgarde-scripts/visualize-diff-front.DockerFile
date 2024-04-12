# Use the node image from official Docker Hub
FROM node:20.11.0-alpine as build-stage
# Copy the working directory in the container
COPY visualize-diff-front .
# Install the project dependencies
RUN npm install
# Build the Vue.js application to the production mode to dist folder
RUN npm run build
# Use the lightweight Nginx image from the previous stage for the nginx container
FROM nginx:stable-alpine as production-stage
# Copy the build application from the previous stage to the Nginx container
COPY --from=build-stage ./dist /usr/share/nginx/html
# Copy the nginx configuration file
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
# Expose the port 80
EXPOSE 80
# Start Nginx to serve the applicationa
#CMD ["nginx", "-g", "daemon off;"]
