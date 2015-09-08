FROM     ubuntu:14.04
RUN      apt-get -y update
RUN      apt-get -y upgrade


# ---------------- #
#   Installation   #
# ---------------- #

# Install all prerequisites
RUN     apt-get -y install software-properties-common
RUN     add-apt-repository -y ppa:chris-lea/node.js
RUN     apt-get -y update
RUN     apt-get -y install python-django-tagging python-simplejson python-memcache python-ldap python-cairo python-pysqlite2 python-support \
                           python-pip gunicorn supervisor nginx-light nodejs git wget curl openjdk-7-jre build-essential python-dev

# Install Elasticsearch
RUN     cd ~ && wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.3.2.deb
RUN     cd ~ && dpkg -i elasticsearch-1.3.2.deb && rm elasticsearch-1.3.2.deb

# Install Whisper, Carbon and Graphite-Web
RUN     pip install Twisted==11.1.0
RUN     pip install Django==1.5
RUN     pip install whisper==0.9.12
RUN     pip install --install-option="--prefix=/var/lib/graphite" --install-option="--install-lib=/var/lib/graphite/lib" carbon==0.9.12
RUN     pip install --install-option="--prefix=/var/lib/graphite" --install-option="--install-lib=/var/lib/graphite/webapp" graphite-web==0.9.12

ADD     ./patches/add-maxDataPoints/webapp/graphite/render/attime.py /var/lib/graphite/webapp/graphite/render/attime.py 
ADD     ./patches/add-maxDataPoints/webapp/graphite/render/views.py /var/lib/graphite/webapp/graphite/render/views.py 

# Install & Patch Grafana
RUN     mkdir -p /src/grafana                                                                                                              
RUN     git clone https://github.com/grafana/grafana.git /src/grafana                                                                   &&\
        cd /src/grafana                                                                                                                 &&\
        git checkout v1.9.1																												&&\
        npm install                                                                                                                     &&\
        npm install -g grunt-cli                                                                                                        &&\
        grunt build 

# Install confd
RUN curl -o /root/confd-bin -L https://github.com/kelseyhightower/confd/releases/download/v0.9.0/confd-0.9.0-linux-amd64
RUN mv /root/confd-bin /usr/local/bin/confd
RUN chmod +x /usr/local/bin/confd

# Create directories
RUN mkdir -p /etc/confd/conf.d
RUN mkdir -p /etc/confd/templates


# ----------------- #
#   Configuration   #
# ----------------- #

# Configure Elasticsearch
ADD     ./elasticsearch/run /usr/local/bin/run_elasticsearch
RUN     chown -R elasticsearch:elasticsearch /var/lib/elasticsearch
RUN     mkdir -p /tmp/elasticsearch && chown elasticsearch:elasticsearch /tmp/elasticsearch

# Configure Whisper, Carbon and Graphite-Web
ADD     ./initial_data.json /var/lib/graphite/webapp/graphite/initial_data.json
RUN     mkdir -p /var/lib/graphite/storage/whisper
RUN     touch /var/lib/graphite/storage/graphite.db /var/lib/graphite/storage/index
RUN     chown -R www-data /var/lib/graphite/storage
RUN     chmod 0775 /var/lib/graphite/storage /var/lib/graphite/storage/whisper
RUN     chmod 0664 /var/lib/graphite/storage/graphite.db
RUN     cd /var/lib/graphite/webapp/graphite && python manage.py syncdb --noinput

# Configure Grafana
ADD     ./grafana/config.js /src/grafana/dist/config.js
ADD     ./grafana/default-dashboard.json /src/grafana/dist/app/dashboards/default.json

# Configure nginx and supervisord
ADD     ./nginx/nginx.conf /etc/nginx/nginx.conf
ADD     ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Elastic search data dir
VOLUME ["/var/lib/elasticsearch"]

# Whisper (graphite) data dir
VOLUME ["/var/lib/graphite/storage/whisper"]

EXPOSE  80
EXPOSE 8080

ADD ./confd                   /etc/confd
ADD ./bin/boot.sh             /boot.sh
RUN chmod +x /boot.sh

CMD /boot.sh                