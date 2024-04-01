FROM maven:3.8.6 as MAVEN-ENV
COPY . .
RUN mvn package

FROM openjdk:17-alpine
ARG VERSION=1
ENV VERSION=$VERSION
COPY --from=MAVEN-ENV ./target/my-app-1.0.$VERSION.jar .
CMD java -jar my-app-1.0.$VERSION.jar
