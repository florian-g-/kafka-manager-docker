# Kafka Manager Dockerfile
[Kafka Manager](https://github.com/yahoo/kafka-manager) is a tool from Yahoo Inc. for managing [Apache Kafka](http://kafka.apache.org).

**NOTE:**
This fork is a draft and work in progress. Doing fine on Linux, is lightweight and can easily be upgraded to the current KM version via env ``KM_GIT_TAG``.

## Base Docker Image ##
* [anapsix/alpine-java:8_jdk](https://hub.docker.com/r/anapsix/alpine-java/)

## Howto
### Quick Start
Either
```
docker-compose up -d
```
or start a zookeeper (e.g. port 2181) and
``` 
docker run --name kafkamanager --network=host -d -e ZK_HOSTS=localhost:2181 fgr206/kafkamanager
```