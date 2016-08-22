FROM interaction/icekit:latest

WORKDIR /opt/icekit-project/

COPY package.json /opt/icekit-project/
RUN npm-install.sh && rm -rf /root/.npm
ENV PATH=/opt/icekit-project/node_modules/.bin:$PATH

COPY bower.json /opt/django-icekit/icekit/
RUN bower-install.sh && rm -rf /root/.cache/bower

COPY requirements.txt /opt/icekit-project/
RUN pip install --no-cache-dir -r requirements.txt
RUN touch requirements-local.txt
RUN md5sum requirements.txt requirements-local.txt > requirements.md5

COPY . /opt/icekit-project/

RUN manage.py collectstatic --noinput --verbosity=0
RUN manage.py compress --verbosity=0
