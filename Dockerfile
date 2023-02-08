FROM nginx

RUN apt-get update && apt-get install nodejs -y && apt-get install npm -y && apt-get clean

COPY my.conf ./etc/nginx/conf.d/default.conf

WORKDIR /usr/src/app

COPY app/package*.json ./

RUN npm config set registry https://mirrors.tencent.com/npm/ && npm install

COPY app ./

CMD ["sh", "start.sh"]
# https://hub.docker.com/_/node
FROM node:10.10.0-slim

# Create and change to the app directory.
WORKDIR /usr/src/app

# Copy application dependency manifests to the container image.
# A wildcard is used to ensure both package.json AND package-lock.json are copied.
# Copying this separately prevents re-running npm install on every code change.
COPY package*.json ./

# Install production dependencies.
RUN npm install --only=production

RUN npm install -g gulp

# Copy local code to the container image.
COPY . ./

# Run the web service on container startup.
CMD [ "gulp", "mock" ]