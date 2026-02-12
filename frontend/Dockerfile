FROM node:16-bullseye-slim

LABEL maintainer="Opstree Solutions"

WORKDIR /app

# copy app code
COPY . .

# install git (if needed) + clean apt cache
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# install dependencies + build
RUN npm install
RUN npm run build

# serve build
RUN npm install -g serve

EXPOSE 5000
CMD ["serve", "-s", "build", "-l", "5000"]

