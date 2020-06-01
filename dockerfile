# Dockerfile - this is a comment. Delete me if you want.
FROM nginx

ENV HOME=/opt/client-application

# install python, uwsgi, and supervisord
RUN apt-get update && apt-get install -y supervisor uwsgi python3 python3-pip procps vim curl
# iccs cred generation scripts are written in python2.x. For that we need these
# packages to be installed
RUN apt-get install -y python-pip
RUN pip install pyyaml
# Source code file
COPY ./requirements.txt ${HOME}/requirements.txt

# Install required python modules
RUN pip3 install -r ${HOME}/requirements.txt

# Install ssh-keygen
RUN apt-get -y install openssh-client

# Copying source code files
COPY ./src ${HOME}/src

# Copy the configuration file from the current directory and paste
# it inside the container to use it as Nginx's default config.
COPY ./webserver_config/nginx.conf /etc/nginx/nginx.conf

# setup NGINX config
RUN mkdir -p /spool/nginx /run/pid && \
    chmod -R 777 /var/log/nginx /var/cache/nginx /etc/nginx /var/run /run /run/pid /spool/nginx && \
    rm /etc/nginx/conf.d/default.conf

# Copy the base uWSGI ini file to enable default dynamic uwsgi process number
COPY ./webserver_config/uwsgi.ini /etc/uwsgi/apps-available/uwsgi.ini
RUN ln -s /etc/uwsgi/apps-available/uwsgi.ini /etc/uwsgi/apps-enabled/uwsgi.ini

COPY ./webserver_config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN touch /var/log/supervisor/supervisord.log

EXPOSE 80:80

# setup entrypoint
COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# https://github.com/moby/moby/issues/31243#issuecomment-406879017
RUN ln -s /usr/local/bin/docker-entrypoint.sh / && \
    chmod +x /usr/local/bin/docker-entrypoint.sh

# Make folder to temporarily store ssh-keys
RUN mkdir -p ${HOME}/src/keys

# Make folders to temporarily store file logs
RUN mkdir -p /var/log/client-application/kubernetes-cluster
RUN mkdir -p /var/log/client-application/appcenter
RUN mkdir -p /var/log/client-application/mle
RUN mkdir -p /var/log/client-application/querygrid
RUN mkdir -p /var/log/client-application/additionalresources
RUN mkdir -p /var/log/client-application/network_links
RUN mkdir -p /var/log/client-application/mle
RUN mkdir -p /tmp/configfiles

WORKDIR ${HOME}
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["supervisord"]
