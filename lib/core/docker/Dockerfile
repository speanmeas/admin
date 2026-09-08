FROM nginx:stable-alpine

# remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# copy flutter web build output (run: cd ../admin && flutter build web)
COPY admin/build/web /usr/share/nginx/html

# copy nginx config
COPY admin/lib/core/docker/nginx.conf /etc/nginx/conf.d/default.conf

# expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]