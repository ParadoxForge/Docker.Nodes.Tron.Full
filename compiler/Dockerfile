FROM centos:7

#https://github.com/tronprotocol/TronDeployment

ENV TRON_VERSION "Odyssey-v3.0"
ENV TRON_APP "FullNode"

# Install Git, WGet
RUN yum install wget -y -q

# Install JDK (oracle 1.8)
RUN cd /tmp \
 && wget -q --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jdk-8u181-linux-x64.rpm" \
 && yum localinstall jdk-8u181-linux-x64.rpm -y -q \
 && rm -f jdk-8u181-linux-x64.rpm

ENV JAVA_HOME "/usr/java/latest/"
 
WORKDIR /tron 
 
# Checkout latest Tron Java code
RUN wget https://github.com/tronprotocol/java-tron/archive/${TRON_VERSION}.tar.gz -O tron.tar.gz \
 && tar -xzf tron.tar.gz \
 && rm -f tron.tar.gz
 
RUN cd java-tron-${TRON_VERSION} && ./gradlew build -x test
RUN cp java-tron-${TRON_VERSION}/build/libs/${TRON_APP}.jar ${TRON_APP}.jar
RUN echo ${TRON_VERSION} > version.txt
RUN rm -rf java-tron-${TRON_VERSION}

CMD bash
