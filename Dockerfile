FROM ubuntu:xenial
MAINTAINER Julien ANCELIN

ENV LANG C.UTF-8

RUN apt-get -y update
RUN apt-get install -y gnupg apt-transport-https ca-certificates

RUN echo "deb http://qgis.org/debian focal main" >> /etc/apt/sources.list
RUN gpg --keyserver keyserver.ubuntu.com --recv 51F523511C7028C3
RUN gpg --export --armor 51F523511C7028C3 | apt-key add -
RUN apt-get update && \
    apt-get install -y qgis python-qgis qgis-plugin-grass \
    locales locales-all && \
    rm -rf /var/lib/apt/lists/*
#--no-install-recommends

#locales
ENV LC_ALL fr_FR.UTF-8
ENV LANG fr_FR.UTF-8
ENV LANGUAGE fr_FR.UTF-8

# Called when the Docker image is started in the container
ADD start.sh /start.sh
RUN chmod 0755 /start.sh

CMD /start.sh
