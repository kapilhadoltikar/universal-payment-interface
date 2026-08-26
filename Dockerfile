# --- Stage 1: Build Stage ---
FROM maven:3.9-eclipse-temurin-21-alpine AS builder
WORKDIR /build

# Copy the entire project context into the container
COPY . .

# Accept the service name as a build argument (e.g., api-gateway, auth-service)
ARG SERVICE_NAME

# Build only the requested service and its internal dependencies (-am)
RUN mvn clean package -pl ${SERVICE_NAME} -am -DskipTests


# --- Stage 2: Runtime Stage ---
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Accept the service name again in the runtime stage
ARG SERVICE_NAME

# Copy the built jar file from the builder stage
# (This assumes standard Maven target folder output structures)
COPY --from=builder /build/${SERVICE_NAME}/target/*.jar app.jar

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
