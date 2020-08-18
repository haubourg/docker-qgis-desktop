FROM ubuntu:bionic
MAINTAINER Julien ANCELIN

ENV LANG C.UTF-8
ARG DEBIAN_FRONTEND=noninteractive
# debug traces for QT 
ARG QT_DEBUG_PLUGINS=1


# LAYER 1

RUN apt-get -y update
RUN apt-get install -y gnupg apt-transport-https ca-certificates

# Add ubuntugis unstable repo
RUN echo "deb http://ppa.launchpad.net/ubuntugis/ubuntugis-unstable/ubuntu bionic main" >> /etc/apt/sources.list
RUN gpg --keyserver keyserver.ubuntu.com --recv 6B827C12C2D425E227EDCA75089EBE08314DF160
RUN gpg --export --armor 6B827C12C2D425E227EDCA75089EBE08314DF160 | apt-key add -

# Add qgis.org repo
RUN echo "deb http://qgis.org/ubuntugis-ltr bionic main" >> /etc/apt/sources.list
RUN gpg --keyserver keyserver.ubuntu.com --recv F7E06F06199EF2F2
RUN gpg --export --armor F7E06F06199EF2F2 | apt-key add -

# install QGIS
RUN apt-get update && \
    apt-get install -y qgis qgis-plugin-grass python3-pandas\
    locales locales-all && \
    rm -rf /var/lib/apt/lists/*
#--no-install-recommends

#locales
ENV LC_ALL fr_FR.UTF-8
ENV LANG fr_FR.UTF-8
ENV LANGUAGE fr_FR.UTF-8

# # Called when the Docker image is started in the container
# this version with entry point allows to pass parameters to QGIS (like profiles_path or project, etc..)
COPY ./start.sh /
ENTRYPOINT ["/start.sh"]
CMD []
RUN chmod 0755 /start.sh
