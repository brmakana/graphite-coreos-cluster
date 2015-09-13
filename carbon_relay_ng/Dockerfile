FROM     ubuntu:14.04

RUN     apt-get -y update && apt-get -y upgrade
RUN     apt-get -y install git curl make supervisor
RUN		curl -o /root/go1.4.2.linux-amd64.tar.gz https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz
RUN 	tar -C /usr/local -xzf /root/go1.4.2.linux-amd64.tar.gz

RUN		mkdir -p /opt/go
RUN		export GOPATH=/opt/go && \
		export PATH="$PATH:/usr/local/go/bin:$GOPATH/bin" && \
		cd $GOPATH && \
		go get -d github.com/graphite-ng/carbon-relay-ng && \
		go get github.com/jteeuwen/go-bindata/... && \
		cd "$GOPATH/src/github.com/graphite-ng/carbon-relay-ng" && \
		make           
RUN		ln -s /opt/go/src/github.com/graphite-ng/carbon-relay-ng/carbon-relay-ng /usr/local/bin

ADD		carbon-relay-ng.ini /etc/carbon-relay-ng.ini
ADD     ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf		             

EXPOSE 2003 2004 8081

CMD     ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]