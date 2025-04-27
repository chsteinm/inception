FROM debian:bullseye

# Update package lists, install Nginx and OpenSSL, and clean up to reduce image size
RUN apt-get update && apt-get install -y nginx openssl \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /etc/nginx/ssl \
    && openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=FR/ST=Paris/L=Lyon/O=42/OU=42Lyon/CN=chrstein.42.fr" \
    && chown www-data:www-data /etc/nginx/ssl/nginx.* \
    && chmod 600 /etc/nginx/ssl/nginx.key \
    && chmod 644 /etc/nginx/ssl/nginx.crt

# Copy the custom Nginx configuration file into the container
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

# Expose port 443 for HTTPS traffic
EXPOSE 443

# Start Nginx in the foreground to keep the container running
CMD ["nginx", "-g", "daemon off;"]