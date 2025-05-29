#!/bin/sh

# Get the port from environment variable, default to 80 if not set
PORT=${PORT:-80}

# Test if nginx is responding on the specified port
curl -f http://localhost:$PORT/ || exit 1
