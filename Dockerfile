FROM gradle:7.6-jdk8 as builder

WORKDIR /app

COPY build.gradle settings.gradle ./

COPY src ./src

RUN gradle clean build -x test --no-daemon

FROM eclipse-temurin:8-jre

WORKDIR /app

COPY --from=builder /app/build/libs/*-SNAPSHOT.jar app.jar

ENV JAVA_OPTS="-Xmx512m -Xms256m"

EXPOSE 8080

ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]