FROM centos:7

#https://github.com/tronprotocol/TronDeployment

# Install Git, WGet
RUN set -o errexit -o nounset \
 &&	yum install git wget -y
 
WORKDIR /tmp 

# Install JDK (oracle 1.8)
RUN set -o errexit -o nounset \
 && cd /tmp \
 && wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jdk-8u181-linux-x64.rpm" \
 && yum localinstall jdk-8u181-linux-x64.rpm -y \
 && rm -rf ~/jdk-8u181-linux-x64.rpm

ENV JAVA_HOME "/usr/java/latest/"
ENV PATH "$PATH:/usr/java/latest/"
 
 
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
 
 
CMD rm -rf output/* \
 && cp -r FullNode/FullNode.jar output/FullNode.jar