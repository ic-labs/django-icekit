# * `docker run --rm interaction/icekit -v ~/myproject:/install`
# * Populates ~/myproject with base and sample docker compose and stack files,
#   and directories for media, static files, templates, logs, plugins, etc.
# * `docker-compose up`
# * Access site on `http://icekit.lvh.me`

FROM buildpack-deps:jessie

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        gettext \
        jq \
        nano \
        postgresql-client \
        python \
        python-dev \
        pv \
    && rm -rf /var/lib/apt/lists/*

ENV NODE_VERSION=4.4.2
RUN wget -nv -O - "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz" | tar -Jx -C /opt/ -f -
RUN ln -s "/opt/node-v${NODE_VERSION}-linux-x64/bin/node" /usr/local/bin/
RUN ln -s "/opt/node-v${NODE_VERSION}-linux-x64/bin/npm" /usr/local/bin/

WORKDIR /opt/django-icekit/icekit/

COPY icekit/package.json /opt/django-icekit/icekit/
RUN npm install && rm -rf /root/.npm
RUN md5sum package.json > package.json.md5
ENV PATH=/opt/django-icekit/icekit/node_modules/.bin:$PATH

COPY icekit/bower.json /opt/django-icekit/icekit/
RUN bower install --allow-root && rm -rf /root/.cache/bower
RUN md5sum bower.json > bower.json.md5

WORKDIR /opt/django-icekit/

RUN wget -nv -O - https://bootstrap.pypa.io/get-pip.py | python
ARG PIP_INDEX_URL=https://devpi.ixcsandbox.com/ic/dev/+simple

COPY requirements.txt /opt/django-icekit/
RUN pip install --no-cache-dir -r requirements.txt

COPY bin/ /opt/django-icekit/bin/
COPY setup.py /opt/django-icekit/
RUN pip install --no-cache-dir -e .[api,brightcove,dev,django18,forms,project,search,slideshow,test]

RUN touch requirements-local.txt
RUN md5sum requirements.txt requirements-local.txt > requirements.md5

ENV DOCKERIZE_VERSION=0.2.0
RUN wget -nv -O - "https://github.com/jwilder/dockerize/releases/download/v${DOCKERIZE_VERSION}/dockerize-linux-amd64-v${DOCKERIZE_VERSION}.tar.gz" | tar -xz -C /usr/local/bin/ -f -

ENV TINI_VERSION=0.9.0
RUN wget -nv -O /usr/local/bin/tini "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static"
RUN chmod +x /usr/local/bin/tini

ENV DOCKER_COMMIT=0a214841ace30f8ff67cd1c3a9c2214b62eb4619
RUN cd /usr/local/bin \
    && wget -N -nv "https://raw.githubusercontent.com/ixc/docker/${DOCKER_COMMIT}/bin/transfer.sh" \
    && chmod +x *.sh

# See: https://github.com/codekitchen/dinghy/issues/17#issuecomment-209545602
# RUN echo "int chown() { return 0; }" > preload.c && gcc -shared -o /libpreload.so preload.c && rm preload.c
# ENV LD_PRELOAD=/libpreload.so

ENV CRONLOCK_HOST=redis
ENV ICEKIT_PROJECT_DIR=/opt/django-icekit/icekit-project
ENV PATH=/opt/django-icekit/bin:/opt/django-icekit/venv/bin:$PATH
ENV PIP_INDEX_URL=$PIP_INDEX_URL
ENV PIP_SRC=/opt/django-icekit/venv/src
ENV PYTHONPATH=/opt/django-icekit:$PYTHONPATH
ENV PYTHONUSERBASE=/opt/django-icekit/venv

VOLUME /root

ENTRYPOINT ["tini", "--"]

COPY . /opt/django-icekit/
