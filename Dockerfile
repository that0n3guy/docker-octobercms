FROM that0n3guy/baseimage-nginx-phpfpm

#ADD . /app/

RUN composer self-update
RUN composer -n create-project october/october /app dev-master
RUN chown -R www-data:www-data

# copy all our setup files into the container
ADD .docker /build/.docker
RUN rm /app/Dockerfile && mv /app/.docker /build/

RUN chmod +x /build/.docker/*.sh && chmod +x /build/.docker/*/*.sh

# Give web server permissions to access app folder
RUN chown -R www-data:www-data /app

# run our uploads setup script
RUN bash /build/.docker/after-boot-actions/setup.sh

# run our uploads setup script
RUN bash /build/.docker/uploads/setup.sh

# nginx setup script for october
RUN bash /build/.docker/nginx/setup.sh


# secure it by removing default keys.
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh