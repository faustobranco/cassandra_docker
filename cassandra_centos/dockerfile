ARG FROM_IMAGE
ARG FROM_TAG
FROM ${FROM_IMAGE}:${FROM_TAG}

ARG CASSANDRA_CENTOS_VERSION
ARG CASSANDRA_CENTOS_HOME
ARG MAINTAINER

LABEL MAINTAINER=${MAINTAINER}

USER root

ENV DATA_DIR /cassandra/data
ENV COMMITLOG_DIR /cassandra/commitlog
ENV CASSANDRA_CONFIG $CASSANDRA_CENTOS_HOME/conf

COPY docker-entrypoint.sh /

RUN yum install -y java-1.8.0-openjdk \
    mkdir /work; \
    wget https://archive.apache.org/dist/cassandra/redhat/311x/cassandra-${CASSANDRA_CENTOS_VERSION}-1.noarch.rpm -O /work/cassandra.rpm ; \
    rpm -ivh /work/cassandra.rpm ; \
    wget https://archive.apache.org/dist/cassandra/redhat/311x/cassandra-tools-${CASSANDRA_CENTOS_VERSION}-1.noarch.rpm -O /work/cassandra-tools.rpm ; \
    rpm -ivh /work/cassandra-tools.rpm ; \
    rm -rf /work ; \
    mkdir -p $DATA_DIR $COMMITLOG_DIR; \
    sed -ri 's/^(JVM_PATCH_VERSION)=.*/\1=25/' $CASSANDRA_CONFIG/cassandra-env.sh; \
    sed -i "s|/var/lib/cassandra/data|$DATA_DIR|g" "${CASSANDRA_CONFIG}/cassandra.yaml"; \
    sed -i "s|/var/lib/cassandra/commitlog|$COMMITLOG_DIR|g" "${CASSANDRA_CONFIG}/cassandra.yaml"; \
    cp "${CASSANDRA_CONFIG}/cassandra.yaml" "${CASSANDRA_CONFIG}/cassandra.yaml.bak"; \
    chown -R cassandra:cassandra $DATA_DIR $COMMITLOG_DIR /etc/cassandra /var/lib/cassandra /var/log/cassandra; \
    chmod a+x /docker-entrypoint.sh

VOLUME $DATA_DIR $COMMITLOG_DIR

# 7000: intra-node communication
# 7001: TLS intra-node communication
# 7199: JMX
# 9042: CQL
# 9160: thrift service
EXPOSE 7000 7001 7199 9042 9160

USER cassandra
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["cassandra", "-f"]
