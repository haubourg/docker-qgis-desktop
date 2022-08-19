ARG DISTRIBUTION_CODENAME=jammy

FROM ubuntu:${DISTRIBUTION_CODENAME}
LABEL org.opencontainers.image.authors="regis.haubourg@gmail.com"

# change key here if you get GPG error: http://qgis.org/ubuntu-nightly
# the new key is available at https://www.qgis.org/fr/site/forusers/alldownloads.html#debian-ubuntu
ARG QGIS_REPO_KEY=2D7E3441A707FDB3E7059441D155B8E6A419C5BE

ARG DISTRIBUTION_CODENAME
ENV LANG C.UTF-8
ARG DEBIAN_FRONTEND=noninteractive
# debug traces for QT 
ARG QT_DEBUG_PLUGINS=1
# force update for nightly
ARG FORCE_UPDATE=yes
RUN apt -y update
RUN apt install -y gnupg apt-transport-https ca-certificates

# Add qgis.org repo
RUN echo "deb http://qgis.org/ubuntu-nightly ""$DISTRIBUTION_CODENAME"" main" >> /etc/apt/sources.list
RUN gpg --keyserver keyserver.ubuntu.com --recv ${QGIS_REPO_KEY}
RUN gpg --export --armor ${QGIS_REPO_KEY} | apt-key add -

# install QGIS
RUN apt update && \
    apt install -y qgis qgis-plugin-grass \
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
