FROM openjdk:14 AS builder
RUN mkdir /application
WORKDIR /application
COPY ./ ./
RUN ./gradlew clean build --no-daemon

FROM alpine:latest
RUN apk add --no-cache wget tar
RUN mkdir /myapp
WORKDIR /myapp
RUN wget https://cdn.azul.com/zulu/bin/zulu14.28.21-ca-jre14.0.1-linux_musl_x64.tar.gz
RUN tar -xvf zulu14.28.21-ca-jre14.0.1-linux_musl_x64.tar.gz
COPY --from=builder /application/build/libs/app.jar .
CMD ["/myapp/zulu14.28.21-ca-jre14.0.1-linux_musl_x64/bin/java","-jar","/myapp/app.jar"]