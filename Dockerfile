FROM centos:7

#https://github.com/tronprotocol/TronDeployment

# Install Git, WGet, Go
RUN set -o errexit -o nounset \
 &&	yum install git wget go -y
 
WORKDIR /tmp 

# Install JDK (oracle 1.8)
RUN set -o errexit -o nounset \
 && cd /tmp \
 && wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jdk-8u181-linux-x64.rpm" \
 && yum localinstall jdk-8u181-linux-x64.rpm -y \
 && rm -rf ~/jdk-8u181-linux-x64.rpm

ENV JAVA_HOME "/usr/java/latest/"
ENV PATH "$PATH:/usr/java/latest/"
ENV GOPATH "/root"
ENV PATH "$PATH:/root/bin"

#export JAVA_HOME="/usr/java/latest/"
#export PATH="$PATH:/usr/java/latest/"
#export GOPATH="/root"
#export PATH="$PATH:/root/bin"
 
 
# Checkout latest Tron Java code
RUN set -o errexit -o nounset \
 && mkdir /tron/ \
 && cd /tron/ \
 && git clone https://github.com/tronprotocol/java-tron.git \
 && cd java-tron \
 && git checkout -t origin/master
 
WORKDIR /tron/java-tron

# Build and Deploy a Tron Full Node
RUN set -o errexit -o nounset \
 && wget https://raw.githubusercontent.com/tronprotocol/TronDeployment/master/deploy_tron.sh -O deploy_tron.sh \
 && echo "========================" \
 && echo "=> THIS MAY TAKE A WHILE" \
 && echo "========================" \
 && bash deploy_tron.sh --app FullNode --net mainnet
 
# Build and Deploy the GRPC gateway
RUN set -o errexit -o nounset \
 && go get -u github.com/tronprotocol/grpc-gateway
 
 
RUN echo "echo Starting the Full Node" >> /tron/java-tron/start.sh \
 && echo "cd /tron/java-tron" >> /tron/java-tron/start.sh  \
 && echo "bash deploy_tron.sh --app FullNode --net mainnet" >> /tron/java-tron/start.sh  \
 && echo "echo Starting GRPC Gateway" >> /tron/java-tron/start.sh  \
 && echo "cd $GOPATH/src/github.com/tronprotocol/grpc-gateway" >> /tron/java-tron/start.sh  \
 && echo "nohup go run tron_http/main.go -listen 50052 >> start_grpc_gateway.log 2>&1 &" >> /tron/java-tron/start.sh  \
 && echo "cd /tron/java-tron" >> /tron/java-tron/start.sh  \
 && echo "tail -f -q --retry /tron/java-tron/FullNode/logs/tron.log" >> /tron/java-tron/start.sh  \
 && echo "bash" >> /tron/java-tron/start.sh  \
 && echo "kill -s TERM `ps ax | grep FullNode.jar |grep -v grep | awk '{print $1}'`" >> /tron/java-tron/start.sh  \
 && chmod -R 777 /tron/java-tron/start.sh



CMD /tron/java-tron/start.sh


# Not entirely sure port
EXPOSE 18888
# FullNode
EXPOSE 50051
# GRPC Gateway
EXPOSE 50052