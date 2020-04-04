FROM phpmyadmin/phpmyadmin:4.7

COPY .htpasswd /etc/phpmyadmin/.htpasswd
RUN sed -i "s/server {/server {\nauth_basic           \"Administrator\'s Area\";\nauth_basic_user_file \/etc\/phpmyadmin\/.htpasswd;\n/g" /etc/nginx.conf


