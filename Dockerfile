FROM ubuntu:eoan
MAINTAINER Julien ANCELIN

ENV LANG C.UTF-8
ARG DEBIAN_FRONTEND=noninteractive
# debug traces for QT 
ARG QT_DEBUG_PLUGINS=1
# force update for nightly
ARG FORCE_UPDATE=yes
RUN apt-get -y update
RUN apt-get install -y gnupg apt-transport-https ca-certificates

# Add ubuntugis unstable repo
# RUN echo "deb http://ppa.launchpad.net/ubuntugis/ubuntugis-unstable/ubuntu  focal main" >> /etc/apt/sources.list
# RUN gpg --keyserver keyserver.ubuntu.com --recv 6B827C12C2D425E227EDCA75089EBE08314DF160
# RUN gpg --export --armor 6B827C12C2D425E227EDCA75089EBE08314DF160 | apt-key add -

# Add qgis.org repo
RUN echo "deb http://qgis.org/ubuntu eoan main" >> /etc/apt/sources.list
RUN gpg --keyserver keyserver.ubuntu.com --recv 51F523511C7028C3
RUN gpg --export --armor 51F523511C7028C3 | apt-key add -

# install QGIS
RUN apt-get update && \
    apt-get install -y qgis qgis-plugin-grass \
    locales locales-all && \
    rm -rf /var/lib/apt/lists/*
#--no-install-recommends

#locales
ENV LC_ALL fr_FR.UTF-8
ENV LANG fr_FR.UTF-8
ENV LANGUAGE fr_FR.UTF-8

# # Called when the Docker image is started in the container

COPY ./start.sh /
ENTRYPOINT ["/start.sh"]
CMD []
# ADD start.sh /start.sh
RUN chmod 0755 /start.sh
# CMD /start.sh
