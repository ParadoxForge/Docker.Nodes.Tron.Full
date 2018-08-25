FROM centos:7

#https://github.com/tronprotocol/TronDeployment

ENV NETWORK "main"

# Install Git, WGet, Go
RUN set -o errexit -o nounset \
 &&	yum install git wget go -y
 
WORKDIR /tmp 

# Install JDK (oracle 1.8)
RUN set -o errexit -o nounset \
 && cd /tmp \
 && wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jdk-8u181-linux-x64.rpm" \
 && yum localinstall jdk-8u181-linux-x64.rpm -y \
 && rm -rf jdk-8u181-linux-x64.rpm

ENV JAVA_HOME "/usr/java/latest/"
ENV PATH "$PATH:/usr/java/latest/"
ENV GOPATH "/root"
ENV PATH "$PATH:/root/bin"
 
WORKDIR /tron

# Build and Deploy the GRPC gateway
RUN set -o errexit -o nounset \
 && go get -u github.com/tronprotocol/grpc-gateway
 
COPY ./compiled/ /tron/


RUN echo "cd $GOPATH/src/github.com/tronprotocol/grpc-gateway" >> /tron/start.sh  \
 && echo "nohup go run tron_http/main.go -listen 50052 >> start_grpc_gateway.log 2>&1 &" >> /tron/start.sh  \
 && echo "cd /tron" >> /tron/start.sh  \
 && echo "java -jar "FullNode.jar" -c /tron/net_config.conf" >> /tron/start.sh  \
 && chmod -R 777 /tron/start.sh

CMD echo "Network : $NETWORK" \
 && wget "https://raw.githubusercontent.com/tronprotocol/TronDeployment/master/$(echo $NETWORK)_net_config.conf" -O /tron/net_config.conf \
 && /tron/start.sh
 
STOPSIGNAL SIGTERM

# RPC Port
EXPOSE 18888
# Full Node
EXPOSE 50051
# GRPC Gateway
EXPOSE 50052
