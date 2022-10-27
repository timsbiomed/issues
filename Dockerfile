FROM maven:3.8-openjdk-17-slim as build-hapi
WORKDIR /tmp/hapi-fhir-jpaserver-starter



# Dockerfile for building a hapi-fhir-jpaserver-starter image
# Java 17
# -- no version spec. in here. It uses what you have in your pom
LABEL maintainer="chris.roeder@cuanschutz.edu"
LABEL version="6.2-SS"
LABEL description="This Dockerfile builds HAPI FHIR, see details here: http://hapifhir.io/, http://hl7.org/fhir/"

## 2022-10-27 18:11:10.702 [http-nio-8080-exec-5] INFO  c.u.f.j.p.TerminologyUploaderProvider 
##    [TerminologyUploaderProvider.java:377] Reading in local file: 
##    /var/folders/23/qym0m8694_10w43smlynw6s80000gp/T/hapi-fhir-cli9732175235774178258.zip


# Java telemetry?
ARG OPENTELEMETRY_JAVA_AGENT_VERSION=1.17.0
RUN curl -LSsO https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v${OPENTELEMETRY_JAVA_AGENT_VERSION}/opentelemetry-javaagent.jar

# Hapi-Fhir
COPY pom.xml .
COPY server.xml .
RUN mvn -ntp dependency:go-offline

COPY src/ /tmp/hapi-fhir-jpaserver-starter/src/
RUN mvn clean install -DskipTests -Djdk.lang.Process.launchMechanism=vfork

FROM build-hapi AS build-distroless
RUN mvn package spring-boot:repackage -Pboot
RUN mkdir /app && cp /tmp/hapi-fhir-jpaserver-starter/target/ROOT.war /app/main.war


# distroless?
FROM gcr.io/distroless/java17-debian11:nonroot as default
# 65532 is the nonroot user's uid
# used here instead of the name to allow Kubernetes to easily detect that the container
# is running as a non-root (uid != 0) user.
USER 65532:65532
WORKDIR /app
COPY --chown=nonroot:nonroot --from=build-distroless /app /app
COPY --chown=nonroot:nonroot --from=build-hapi /tmp/hapi-fhir-jpaserver-starter/opentelemetry-javaagent.jar /app


# Start the server from jshell using the -Pboot image built above
CMD ["/app/main.war"]
