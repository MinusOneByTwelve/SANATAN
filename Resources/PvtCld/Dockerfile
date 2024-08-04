FROM nextcloud:latest

RUN rm -rf /var/www/html/core/skeleton/* /usr/src/nextcloud/core/skeleton/*

RUN apt-get update && apt-get install -y \
  gosu \
  nano \
  default-mysql-client && \
  rm -rf /var/lib/apt/lists/*

