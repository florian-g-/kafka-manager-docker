# docker build --no-cache -t fgr206/kafkamanager - < Dockerfile-kafkamanager
# docker run --name kafkamanager --network=host -d -e ZK_HOSTS=localhost:62181 fgr206/fgr206/kafkamanager
# docker run --name kafkamanager --network=host -it --rm --entrypoint="bash" fgr206/kafkamanager
# docker-compose up -d

FROM anapsix/alpine-java:8_jdk

LABEL maintainer='Florian Grote <info@grote-florian.de>'

ENV KM_GIT_TAG="1.3.3.16" \
    ZK_HOSTS="localhost:2181" \
    KM_ARGS="" \
    KM_PORT=9988 \
    KM_CONFIGFILE="conf/application.conf"

RUN apk add --no-cache git wget && \
    cd /tmp && \
    git clone https://github.com/yahoo/kafka-manager && \
    cd /tmp/kafka-manager && \
    git checkout -b v_${KM_GIT_TAG} ${KM_GIT_TAG} && \
    echo 'scalacOptions ++= Seq("-Xmax-classfile-name", "200")' >> build.sbt && \
    ./sbt clean dist && \
    unzip  -d / /tmp/kafka-manager/target/universal/kafka-manager-*.zip && \
    mv /kafka-manager-* /kafka-manager && \
    rm -fr /tmp/* /root/.sbt /root/.ivy2 && \
    printf '#!/bin/sh\nexec ./bin/kafka-manager -Dconfig.file=${KM_CONFIGFILE} -Dhttp.port=${KM_PORT} "${KM_ARGS}" "${@}"\n' > /kafka-manager/km.sh && \
    chmod +x /kafka-manager/km.sh && \
    rm -fr /kafka-manager/share && \
    apk del git wget

WORKDIR /kafka-manager

EXPOSE ${KM_PORT}

ENTRYPOINT ["./km.sh"]