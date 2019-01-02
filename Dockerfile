FROM tronprotocol/centos7-jdk8

ENV TRON_NETWORK "main"
ENV TRON_VERSION "Odyssey-v3.2.3"

WORKDIR /tron

RUN set -o errexit -o nounset \
 && echo "Downloading Pre-Built JAR [${TRON_VERSION}]" \
 && curl -L -o FullNode.jar "https://github.com/tronprotocol/java-tron/releases/download/${TRON_VERSION}/FullNode.jar"
	
CMD echo "Downloading Network Config [${TRON_NETWORK}]" \
 && curl -L -o net_config.conf "https://raw.githubusercontent.com/tronprotocol/TronDeployment/master/${TRON_NETWORK}_net_config.conf" \
 && echo "Running Node" \
 && java -jar "FullNode.jar" -c net_config.conf

STOPSIGNAL SIGTERM

EXPOSE 18888
EXPOSE 50051
