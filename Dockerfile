FROM nginx:alpine

# Copy static content
# Copy only public-facing files
COPY index.html /usr/share/nginx/html/
COPY css/ /usr/share/nginx/html/css/
COPY js/ /usr/share/nginx/html/js/

# Overwrite Nginx default config with our custom one
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose the correct port
EXPOSE 3001

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]