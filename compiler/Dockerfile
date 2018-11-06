FROM centos:7

#https://github.com/tronprotocol/TronDeployment

ENV TRON_VERSION "Odyssey-v3.1.3"
ENV TRON_APP "FullNode"
ENV JAVA_VERSION_MAJOR=8 \
    JAVA_VERSION_MINOR=191 \
    JAVA_VERSION_BUILD=12\
    JAVA_URL_HASH=2787e4a523244c269598db4e85c51e0c

# Install Git, WGet
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
