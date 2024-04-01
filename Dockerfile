ROM maven:3.8.6 as maven
COPY . .
RUN mvn package

FROM openjdk:17-alpine
ARG VERSION=1
ENV VERSION=$VERSION
COPY --from=maven ./target/my-app-1.0.$VERSION.jar .
CMD java -jar my-app-1.0.$VERSION.jar
