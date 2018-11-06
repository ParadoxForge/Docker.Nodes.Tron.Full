FROM centos:7

#https://github.com/tronprotocol/TronDeployment

ENV NETWORK "main"
ENV TRON_VERSION "Odyssey-v3.1.3"
ENV JAVA_VERSION_MAJOR=8 \
    JAVA_VERSION_MINOR=191 \
    JAVA_VERSION_BUILD=12\
    JAVA_URL_HASH=2787e4a523244c269598db4e85c51e0c

RUN yum install wget -y -q

# Install JDK (oracle 1.8)
RUN cd /tmp \
	&& wget --no-cookies --no-check-certificate \
       --header "Cookie: testSessionCookie=Enabled; oraclelicense=accept-securebackup-cookie" \
       "http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_URL_HASH}/jdk-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.rpm" \
       -O /tmp/jdk.rpm \
	&& yum localinstall jdk.rpm -y -q \
	&& rm -f jdk.rpm

ENV JAVA_HOME "/usr/java/latest/"
ENV PATH "$PATH:/usr/java/latest/"
ENV GOPATH "/root"
ENV PATH "$PATH:/root/bin"
 
WORKDIR /tron
 
COPY ./compiled/ /tron/

CMD echo "Downloading Network Config : $NETWORK net config" \
 && wget -q "https://raw.githubusercontent.com/tronprotocol/TronDeployment/master/$(echo $NETWORK)_net_config.conf" -O /tron/net_config.conf \
 && echo "Running Node" \
 && java -jar "FullNode.jar" -c /tron/net_config.conf

STOPSIGNAL SIGTERM

EXPOSE 18888
EXPOSE 50051
