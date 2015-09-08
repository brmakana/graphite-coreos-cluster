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
                        
# Install Whisper, Carbon and Graphite-Web
RUN     pip install Twisted==11.1.0
RUN     pip install Django==1.5
RUN     pip install whisper==0.9.12
RUN     pip install --install-option="--prefix=/var/lib/graphite" --install-option="--install-lib=/var/lib/graphite/lib" carbon==0.9.12
RUN     pip install --install-option="--prefix=/var/lib/graphite" --install-option="--install-lib=/var/lib/graphite/webapp" graphite-web==0.9.12

ADD     ./graphite/patches/add-maxDataPoints/webapp/graphite/render/attime.py /var/lib/graphite/webapp/graphite/render/attime.py 
ADD     ./graphite/patches/add-maxDataPoints/webapp/graphite/render/views.py /var/lib/graphite/webapp/graphite/render/views.py 
                
                
# ----------------- #
#   Configuration   #
# ----------------- #

# Configure Whisper, Carbon and Graphite-Web
ADD     ./graphite/initial_data.json /var/lib/graphite/webapp/graphite/initial_data.json
ADD     ./graphite/local_settings.py /var/lib/graphite/webapp/graphite/local_settings.py
ADD     ./graphite/carbon.conf /var/lib/graphite/conf/carbon.conf
ADD     ./graphite/storage-schemas.conf /var/lib/graphite/conf/storage-schemas.conf
ADD     ./graphite/storage-aggregation.conf /var/lib/graphite/conf/storage-aggregation.conf

RUN     mkdir -p /var/lib/graphite/storage/whisper
RUN     touch /var/lib/graphite/storage/graphite.db /var/lib/graphite/storage/index
RUN     chown -R www-data /var/lib/graphite/storage
RUN     chmod 0775 /var/lib/graphite/storage /var/lib/graphite/storage/whisper
RUN     chmod 0664 /var/lib/graphite/storage/graphite.db
RUN     cd /var/lib/graphite/webapp/graphite && python manage.py syncdb --noinput

# Configure nginx and supervisord
ADD     ./nginx/nginx.conf /etc/nginx/nginx.conf
ADD     ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf


# ---------------------------- #
#  Add External Mount Volumes  #
# ---------------------------- #

# Whisper (graphite) data dir
VOLUME ["/var/lib/graphite/storage/whisper"]


# ---------------- #
#   Expose Ports   #
# ---------------- #

EXPOSE 80
EXPOSE 8080
EXPOSE 2003
EXPOSE 2004
EXPOSE 7002




# -------- #
#   Run!   #
# -------- #

CMD     ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
                