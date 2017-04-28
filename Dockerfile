FROM buildpack-deps:xenial

RUN apt-get update \
    && apt-get upgrade -y --no-install-recommends \
    && apt-get install -y --no-install-recommends \
        apt-utils \
        gettext \
        gnupg2 \
        jq \
        locales \
        nano \
        nginx \
        postgresql-client \
        python-dev \
        pv \
        vim-tiny \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/git-secret/

ENV GIT_SECRET_VERSION=0.2.1
RUN git clone https://github.com/sobolevn/git-secret.git /opt/git-secret/ \
    && git checkout "v$GIT_SECRET_VERSION" \
    && make build \
    && PREFIX=/usr/local make install

ENV NODE_VERSION=4.4.2
RUN wget -nv -O - "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz" | tar -Jx -C /opt/ -f -
RUN ln -s "/opt/node-v${NODE_VERSION}-linux-x64/bin/node" /usr/local/bin/
RUN ln -s "/opt/node-v${NODE_VERSION}-linux-x64/bin/npm" /usr/local/bin/

WORKDIR /opt/django-icekit/project_template/

COPY project_template/package.json /opt/django-icekit/project_template/
RUN npm install && rm -rf /root/.npm
RUN md5sum package.json > package.json.md5
ENV PATH=/opt/django-icekit/project_template/node_modules/.bin:$PATH

COPY project_template/bower.json /opt/django-icekit/project_template/
RUN bower install --allow-root && rm -rf /root/.cache/bower
RUN md5sum bower.json > bower.json.md5

WORKDIR /opt/django-icekit/

RUN wget -nv -O - https://bootstrap.pypa.io/get-pip.py | python
ENV PIP_SRC=/opt

COPY requirements.txt setup.py /opt/django-icekit/
RUN pip install --no-cache-dir -r requirements.txt -U
RUN md5sum requirements.txt > requirements.txt.md5

ENV DOCKERIZE_VERSION=0.4.0
RUN wget -nv -O - "https://github.com/jwilder/dockerize/releases/download/v${DOCKERIZE_VERSION}/dockerize-linux-amd64-v${DOCKERIZE_VERSION}.tar.gz" | tar -xz -C /usr/local/bin/ -f -

ENV TINI_VERSION=0.14.0
RUN wget -nv -O /usr/local/bin/tini "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static"
RUN chmod +x /usr/local/bin/tini

ENV DOCKER_COMMIT=0a214841ace30f8ff67cd1c3a9c2214b62eb4619
RUN cd /usr/local/bin \
    && wget -N -nv "https://raw.githubusercontent.com/ixc/docker/${DOCKER_COMMIT}/bin/transfer.sh" \
    && chmod +x *.sh

# See: https://github.com/codekitchen/dinghy/issues/17#issuecomment-209545602
# RUN echo "int chown() { return 0; }" > preload.c && gcc -shared -o /libpreload.so preload.c && rm preload.c
# ENV LD_PRELOAD=/libpreload.so

RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
RUN locale-gen
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

ENV CRONLOCK_HOST=redis
ENV DOCKER=1
ENV ELASTICSEARCH_ADDRESS=elasticsearch:9200
ENV ICEKIT_DIR=/opt/django-icekit/icekit
ENV ICEKIT_PROJECT_DIR=/opt/django-icekit/project_template
ENV PATH=/opt/django-icekit/icekit/bin:$PATH
ENV PGHOST=postgres
ENV PGUSER=postgres
ENV PIP_DISABLE_PIP_VERSION_CHECK=on
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONHASHSEED=random
ENV PYTHONWARNINGS=ignore
ENV REDIS_ADDRESS=redis:6379
ENV SUPERVISORD_CONFIG_INCLUDE=supervisord-django.conf
ENV WAITLOCK_ENABLE=1

VOLUME /root

ENTRYPOINT ["tini", "--", "entrypoint.sh"]

COPY . /opt/django-icekit/

RUN manage.py collectstatic --noinput --verbosity=0
RUN manage.py compress --verbosity=0
