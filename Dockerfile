FROM openjdk:8-alpine
LABEL maintainer="Fábio Luciano"

ADD files/libs/liquibase-3.5.5-bin.tar.gz /opt/liquibase-bin
ADD files/libs/mysql-connector-java-5.1.45-bin.jar /opt/liquibase-bin/lib
ADD files/libs/ojdbc8.jar /opt/liquibase-bin/lib
ADD files/libs/postgresql-42.1.4.jar /opt/liquibase-bin/lib

ADD files/scripts/* /usr/local/bin/

WORKDIR /opt/

RUN apk add --no-cache bash git \
    && ln -s /opt/liquibase-bin/liquibase /usr/local/bin \
    && chmod +x -R /usr/local/bin/

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]