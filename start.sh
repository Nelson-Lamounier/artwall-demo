#!/bin/sh

# Set default port if not provided
PORT=${PORT:-80}

# Create temporary directory for nginx PID file that nginx-user can write to
mkdir -p /tmp/nginx
chown nginx-user:nginx-user /tmp/nginx

# Substitute the PORT variable in nginx.conf
envsubst '${PORT}' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

# Start nginx in non-daemon mode (remove duplicate pid directive)
exec nginx -g "daemon off;"