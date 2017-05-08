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

RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

ENV DOCKERIZE_VERSION=0.4.0
RUN wget -nv -O - "https://github.com/jwilder/dockerize/releases/download/v${DOCKERIZE_VERSION}/dockerize-linux-amd64-v${DOCKERIZE_VERSION}.tar.gz" | tar -xz -C /usr/local/bin/ -f -

ENV NODE_VERSION=4.4.2
RUN wget -nv -O - "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz" | tar -Jx -C /opt/ -f -
RUN ln -s "/opt/node-v${NODE_VERSION}-linux-x64/bin/node" /usr/local/bin/
RUN ln -s "/opt/node-v${NODE_VERSION}-linux-x64/bin/npm" /usr/local/bin/

# pip >=9.0 tries to uninstall from the system `site-packages` directory when
# installing a conflicting package into the userbase directory.
# See: https://github.com/pypa/pip/issues/4337
ENV PYTHON_PIP_VERSION=8.1.2
RUN wget -nv -O - https://bootstrap.pypa.io/get-pip.py | python - "pip==${PYTHON_PIP_VERSION}"
ENV PIP_DISABLE_PIP_VERSION_CHECK=on
ENV PIP_SRC=/opt

# For some reason pip allows us to install sdist packages, but not editable
# packages, when this directory doesn't exist, even when installing into the
# userbase directory. So make sure it does.
RUN mkdir -p /usr/lib/python2.7/site-packages

ENV TINI_VERSION=0.14.0
RUN wget -nv -O /usr/local/bin/tini "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static"
RUN chmod +x /usr/local/bin/tini

WORKDIR /opt/git-secret/
ENV GIT_SECRET_VERSION=0.2.1
RUN git clone https://github.com/sobolevn/git-secret.git /opt/git-secret/
RUN git checkout "v$GIT_SECRET_VERSION"
RUN make build
RUN PREFIX=/usr/local make install

WORKDIR /opt/django-icekit/project_template/

COPY project_template/package.json /opt/django-icekit/project_template/
RUN npm install && rm -rf /root/.npm
RUN md5sum package.json > package.json.md5
ENV PATH="/opt/django-icekit/project_template/node_modules/.bin:$PATH"

COPY project_template/bower.json /opt/django-icekit/project_template/
RUN bower install --allow-root && rm -rf /root/.cache/bower
RUN md5sum bower.json > bower.json.md5

COPY project_template/requirements.txt /opt/django-icekit/project_template/
COPY README.rst setup.py /opt/django-icekit/
RUN bash -c 'pip install --exists i --no-cache-dir --no-deps -e .. -r <(grep -v setuptools requirements.txt)'  # Unpin setuptools dependencies. See: https://github.com/pypa/pip/issues/4264
RUN md5sum requirements.txt > requirements.txt.md5

ENV DJANGO_SETTINGS_MODULE=icekit.project.settings
ENV ELASTICSEARCH_ADDRESS=elasticsearch:9200
ENV ICEKIT_DIR=/opt/django-icekit/icekit
ENV PGHOST=postgres
ENV PGUSER=postgres
ENV PROJECT_DIR=/opt/django-icekit/project_template
ENV REDIS_ADDRESS=redis:6379

VOLUME /root

ENTRYPOINT ["tini", "--", "entrypoint.sh"]
CMD ["bash.sh"]

WORKDIR /opt/django-icekit/
COPY . /opt/django-icekit/

RUN manage.py collectstatic --noinput --verbosity=0
RUN manage.py compress --verbosity=0
