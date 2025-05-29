FROM nginx:alpine

# Install envsubst and curl for health checks
RUN apk add --no-cache gettext curl

# Create non-root user for security
RUN addgroup -g 1001 -S nginx-user && \
    adduser -S -D -H -u 1001 -h /var/cache/nginx -s /sbin/nologin -G nginx-user -g nginx-user nginx-user

# Copy static content
COPY index.html /usr/share/nginx/html/
COPY css/ /usr/share/nginx/html/css/
COPY js/ /usr/share/nginx/html/js/

# Copy nginx config template
COPY nginx.conf /etc/nginx/conf.d/default.conf.template

# Copy startup and health check scripts
COPY start.sh /start.sh
COPY healthcheck.sh /healthcheck.sh
RUN chmod +x /start.sh /healthcheck.sh

# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Set proper permissions for nginx directories
RUN chown -R nginx-user:nginx-user /var/cache/nginx /var/log/nginx /etc/nginx/conf.d /usr/share/nginx/html && \
    mkdir -p /tmp/nginx && \
    chown -R nginx-user:nginx-user /tmp/nginx

# Don't switch to non-root user yet - nginx needs root to bind to ports and manage processes
# USER nginx-user

# Remove static EXPOSE - ECS will handle dynamic port assignment
# EXPOSE directive not needed for dynamic ports

# Add health check that uses the dynamic port
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD ["/healthcheck.sh"]

# Use startup script instead of direct nginx command
CMD ["/start.sh"]