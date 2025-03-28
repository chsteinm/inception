FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y nginx openssl \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /etc/nginx/ssl \
    && openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=FR/ST=Paris/L=Lyon/O=42/OU=42Lyon/CN=localhost"

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]