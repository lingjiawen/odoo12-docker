FROM python:3.5
LABEL maintainer="misterling<26476395@qq.com>"

# Generate locale C.UTF-8 for postgres and general locale data
ENV LANG C.UTF-8

ENV FILE_CONFIG=/data/config/prod.conf
ENV ARG_EXT=""

USER root
RUN groupadd -r odoo --gid=919 && useradd -r -g odoo --uid=919 odoo

#ADD lib/sources.list /etc/apt/
ADD lib/gosu /usr/local/bin/gosu
ADD lib/gosu.asc /usr/local/bin/gosu.asc
ADD lib/wkhtmltox.deb /core/wkhtmltox.deb

RUN sed -i "s@http://deb.debian.org@http://mirrors.aliyun.com@g" /etc/apt/sources.list

# add gosu for easy step-down from root
ENV GOSU_VERSION 1.10

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --assume-yes apt-utils

RUN mkdir -p /core/lib && chown -R odoo /core
WORKDIR /core
ADD lib/requirements.txt /core/
ADD lib/* /core/lib/

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN set -x; \
        apt-get update \
        && apt-get install -y --no-install-recommends \
            ca-certificates \
            curl \
            dirmngr \
            fonts-noto-cjk \
            gnupg \
            libssl-dev \
            node-less \
            libsasl2-dev \
            libldap2-dev \
            libxml2-dev \
            libxslt-dev \
        && pip3 install --index-url=http://mirrors.aliyun.com/pypi/simple/ --trusted-host=mirrors.aliyun.com  -r requirements.txt \
        && echo '7e35a63f9db14f93ec7feeb0fce76b30c08f2057 /core/wkhtmltox.deb' | sha1sum -c - \
        && dpkg --force-depends -i /core/wkhtmltox.deb \
        && apt-get -y install -f --no-install-recommends \
        && rm -rf /var/lib/apt/lists/*

# install latest postgresql-client
RUN set -x; \
        echo 'deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main' > /etc/apt/sources.list.d/pgdg.list \
        && export GNUPGHOME="$(mktemp -d)" \
        && repokey='B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8' \
        && gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "${repokey}" \
        && gpg --armor --export "${repokey}" | apt-key add - \
        && gpgconf --kill all \
        && rm -rf "$GNUPGHOME" \
        && apt-get update  \
        && apt-get install -y postgresql-client \
        && rm -rf /var/lib/apt/lists/*

# Install rtlcss (on Debian stretch)
RUN set -x;\
    echo "deb http://deb.nodesource.com/node_8.x stretch main" > /etc/apt/sources.list.d/nodesource.list \
    && export GNUPGHOME="$(mktemp -d)" \
    && repokey='9FD3B784BC1C6FC31A8A0A1C1655A0AB68576280' \
    && gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "${repokey}" \
    && gpg --armor --export "${repokey}" | apt-key add - \
    && gpgconf --kill all \
    && rm -rf "$GNUPGHOME" \
    && apt-get update \
    && apt-get install -y nodejs \
    && npm install -g rtlcss \
    && rm -rf /var/lib/apt/lists/*

# install gosu
RUN set -x; \
    apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates wget \
    && rm -rf /var/lib/apt/lists/* \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
    && apt-get purge -y --auto-remove ca-certificates wget

# Copy entrypoint script and Odoo configuration file
RUN pip3 install num2words xlwt

ADD core /core/core
ADD start.py /core/

# VOLUMES
VOLUME ["/odoo"]
VOLUME ["/core"]
VOLUME ["/data"]
VOLUME ["/app"]
VOLUME ["/log"]

# Expose Odoo services
EXPOSE 8069 8071

# MAKE entrypoint
RUN echo "#!/bin/bash \n set -e \n chown -R odoo:odoo /data \n chown -R odoo:odoo /log \n exec gosu odoo python /core/start.py -c \${FILE_CONFIG} \${ARG_EXT}" > /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# DEFAULT
RUN ln -s usr/local/bin/entrypoint.sh / # backwards compat
ENTRYPOINT ["entrypoint.sh"]