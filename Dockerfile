ARG DISTRIBUTION_CODENAME=resolute

FROM ubuntu:${DISTRIBUTION_CODENAME}
LABEL org.opencontainers.image.authors="regis.haubourg@gmail.com"

# change key here if you get GPG error: http://qgis.org/ubuntu-nightly
# the new key is available at https://www.qgis.org/fr/site/forusers/alldownloads.html#debian-ubuntu
ARG QGIS_REPO_KEY=2D7E3441A707FDB3E7059441D155B8E6A419C5BE

ARG DISTRIBUTION_CODENAME
ENV LANG=C.UTF-8
ARG DEBIAN_FRONTEND=noninteractive
# debug traces for QT 
ARG QT_DEBUG_PLUGINS=1


# LAYER 1

RUN apt-get -y update
RUN apt-get install -y gnupg apt-transport-https ca-certificates wget software-properties-common libqt5sql5-psql python3-requests python3-urllib3 wget

# add key 
RUN mkdir -m755 -p /etc/apt/keyrin
RUN wget -O /etc/apt/keyrings/qgis-archive-keyring.gpg https://download.qgis.org/downloads/qgis-archive-keyring.gpg


# Add qgis.org repo
RUN echo "deb [signed-by=/etc/apt/keyrings/qgis-archive-keyring.gpg] http://qgis.org/ubuntu-nightly ""${DISTRIBUTION_CODENAME}"" main" | tee /etc/apt/sources.list.d/qgis.list


# install QGIS

RUN apt-get update && \
  apt-get install -y --no-install-recommends --no-install-suggests qgis-dev qgis-plugin-grass python3-pandas\
  locales locales-all && \
  rm -rf /var/lib/apt/lists/*
#--no-install-recommends

#locales
ENV LC_ALL=fr_FR.UTF-8
ENV LANG=fr_FR.UTF-8
ENV LANGUAGE=fr_FR.UTF-8

# # Called when the Docker image is started in the container
# this version with entry point allows to pass parameters to QGIS (like profiles_path or project, etc..)
COPY ./start.sh /
ENTRYPOINT ["/start.sh"]
CMD []
RUN chmod 0755 /start.sh
