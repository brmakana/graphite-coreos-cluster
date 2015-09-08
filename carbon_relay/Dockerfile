FROM     ubuntu:14.04

# ---------------- #
#   Installation   #
# ---------------- #

# Install all prerequisites
RUN     apt-get -y install software-properties-common
RUN     apt-get -y update && apt-get -y upgrade
RUN     apt-get -y install python-django-tagging python-simplejson python-memcache python-ldap python-cairo python-support \
                        python-pysqlite2 python-pip gunicorn supervisor wget curl build-essential python-dev
                        
# Install Whisper and Carbon
RUN     pip install Twisted==11.1.0
RUN     pip install Django==1.5
RUN     pip install whisper==0.9.12
RUN     pip install --install-option="--prefix=/var/lib/graphite" --install-option="--install-lib=/var/lib/graphite/lib" carbon==0.9.12
                
# Install confd
RUN curl -o /root/confd-bin -L https://github.com/kelseyhightower/confd/releases/download/v0.9.0/confd-0.9.0-linux-amd64
RUN mv /root/confd-bin /usr/local/bin/confd
RUN chmod +x /usr/local/bin/confd
                
                
# ----------------- #
#   Configuration   #
# ----------------- #

ADD     ./storage-schemas.conf /var/lib/graphite/conf/storage-schemas.conf
ADD     ./storage-aggregation.conf /var/lib/graphite/conf/storage-aggregation.conf
RUN     mkdir -p /var/lib/graphite/storage/whisper
RUN     touch /var/lib/graphite/storage/graphite.db /var/lib/graphite/storage/index
RUN     chown -R www-data /var/lib/graphite/storage
RUN     chmod 0775 /var/lib/graphite/storage /var/lib/graphite/storage/whisper
RUN     chmod 0664 /var/lib/graphite/storage/graphite.db

# Create directories
RUN mkdir -p /etc/confd/conf.d
RUN mkdir -p /etc/confd/templates

# Add files
ADD ./confd                   /etc/confd
ADD ./bin/boot.sh             /boot.sh
RUN chmod +x /boot.sh

# ---------------- #
#   Expose Ports   #
# ---------------- #

EXPOSE 2003
EXPOSE 2004
EXPOSE 7002

# -------- #
#   Run!   #
# -------- #

CMD /boot.sh                