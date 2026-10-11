# =========================
# Stage 1: Build
# =========================
FROM eclipse-temurin:21-jdk-alpine AS builder

WORKDIR /app

# Copy parent pom and all modules (needed for multi-module)
COPY pom.xml .
COPY api-gateway/pom.xml api-gateway/
COPY service-registry/pom.xml service-registry/
COPY ride-service/pom.xml ride-service/
COPY driver-service/pom.xml driver-service/
COPY location-service/pom.xml location-service/
COPY matching-service/pom.xml matching-service/

# Download dependencies first (better caching)
RUN apk add --no-cache maven && \
    mvn -B dependency:go-offline -pl api-gateway -am

# Copy source code
COPY api-gateway/src api-gateway/src

# Build only api-gateway module
RUN mvn -B clean package -DskipTests -pl api-gateway -am

# =========================
# Stage 2: Runtime
# =========================
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Create non-root user
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

# Copy the built jar
COPY --from=builder /app/api-gateway/target/api-gateway-1.0.0.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]