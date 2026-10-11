
FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /workspace

COPY . .

ARG SERVICE_MODULE

RUN mvn -B -pl ${SERVICE_MODULE} -am clean package -DskipTests

RUN mkdir -p /out && \
    JAR=$(find /workspace/${SERVICE_MODULE}/target \
    -maxdepth 1 -type f -name '*.jar' \
    ! -name '*.original' | head -n 1) && \
    test -n "$JAR" && cp "$JAR" /out/app.jar

FROM eclipse-temurin:21-jre

WORKDIR /app

COPY --from=build /out/app.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]
