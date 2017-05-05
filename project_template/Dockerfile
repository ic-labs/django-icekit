# IMPORTANT! If you update the version of ICEkit here, you must also update it
# in `requirements-icekit.txt`.

FROM interaction/icekit:local

WORKDIR /opt/project_template/

COPY package.json /opt/project_template/
RUN npm-install.sh && rm -rf /root/.npm
ENV PATH=/opt/project_template/node_modules/.bin:$PATH

COPY bower.json /opt/project_template/
RUN bower-install.sh && rm -rf /root/.cache/bower

COPY requirements.txt /opt/project_template/
RUN bash -c 'pip install --no-cache-dir --no-deps -r <(grep -v setuptools requirements.txt)'  # Unpin setuptools dependencies. See: https://github.com/pypa/pip/issues/4264
RUN md5sum requirements.txt > requirements.txt.md5

ENV PROJECT_DIR=/opt/project_template

COPY . /opt/project_template/

RUN manage.py collectstatic --noinput --verbosity=0
RUN manage.py compress --verbosity=0
