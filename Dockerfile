FROM centos:7

#https://github.com/tronprotocol/TronDeployment

ENV NETWORK "main"
ENV TRON_VERSION "Odyssey-v3.0"

RUN yum install wget -y -q

# Install JDK (oracle 1.8)
RUN cd /tmp \
 && wget -q --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jdk-8u181-linux-x64.rpm" \
 && yum localinstall jdk-8u181-linux-x64.rpm -y -q \
 && rm -rf jdk-8u181-linux-x64.rpm

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
