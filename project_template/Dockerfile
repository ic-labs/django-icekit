FROM interaction/icekit:local

WORKDIR /opt/project_template/

COPY package.json /opt/project_template/
RUN npm-install.sh && rm -rf /root/.npm
ENV PATH=/opt/project_template/node_modules/.bin:$PATH

COPY bower.json /opt/project_template/
RUN bower-install.sh && rm -rf /root/.cache/bower

COPY requirements.txt /opt/project_template/
RUN pip install --no-cache-dir -r requirements.txt
RUN md5sum requirements.txt > requirements.txt.md5

ENV PROJECT_DIR=/opt/project_template

COPY . /opt/project_template/

RUN manage.py collectstatic --noinput --verbosity=0
RUN manage.py compress --verbosity=0
