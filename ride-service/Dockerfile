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
    mvn -B dependency:go-offline -pl ride-service -am

COPY ride-service/src ride-service/src

RUN mvn -B clean package -DskipTests -pl ride-service -am

# =========================
# Stage 2: Runtime
# =========================
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

COPY --from=builder /app/ride-service/target/ride-service-1.0.0.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]