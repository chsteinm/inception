FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y nginx openssl \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /etc/nginx/ssl \
    && openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=FR/ST=Paris/L=Lyon/O=42/OU=42Lyon/CN=localhost" \
    && chown www-data:www-data /etc/nginx/ssl/nginx.* \
    && chmod 777 /etc/nginx/ssl/nginx.*
    

COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]