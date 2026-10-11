# =========================
# Stage 1: Build
# =========================
FROM eclipse-temurin:21-jdk-alpine AS builder

WORKDIR /app

COPY pom.xml .
COPY api-gateway/pom.xml api-gateway/
COPY service-registry/pom.xml service-registry/
COPY ride-service/pom.xml ride-service/
COPY driver-service/pom.xml driver-service/
COPY location-service/pom.xml location-service/
COPY matching-service/pom.xml matching-service/

RUN apk add --no-cache maven && \
    mvn -B dependency:go-offline -pl matching-service -am

COPY matching-service/src matching-service/src

RUN mvn -B clean package -DskipTests -pl matching-service -am

# =========================
# Stage 2: Runtime
# =========================
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

COPY --from=builder /app/matching-service/target/matching-service-1.0.0.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]