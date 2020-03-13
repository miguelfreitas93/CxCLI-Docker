FROM openjdk:jre-alpine

LABEL Miguel Freitas <miguel.freitas@checkmarx.com>

# Example of how to include certificate to java certificate store if needed
# By Joao Costa <joao.costa@checkmarx.com>
# Place .crt file in the same folder as your Dockerfile, CA certificate as the example below
#     ARG CACERT="asterisk.crt"
# Copy the certificate to the docker machine
#     COPY $CACERT /opt/workdir/
# Run command to apply the cetificate to java certificate store
#     RUN keytool -importcert -file $CACERT -alias $CACERT -keystore cacerts -storepass changeit -noprompt

#ARG CX_CLI_VERSION="8.60.3"
#ARG CX_CLI_VERSION="8.70.4"
#ARG CX_CLI_VERSION="8.80.2"
ARG CX_CLI_VERSION="8.90.2"

#ARG CX_VERSION="8.6.0"
#ARG CX_VERSION="8.7.0"
#ARG CX_VERSION="8.8.0"
ARG CX_VERSION="8.9.0"
ARG CX_CLI_URL="https://download.checkmarx.com/${CX_VERSION}/Plugins/CxConsolePlugin-${CX_CLI_VERSION}.zip"

RUN apk add --no-cache --update curl python jq bash

WORKDIR /opt

RUN curl ${CX_CLI_URL} -o cli.zip && \
    rm -rf /var/cache/apk/* && \
    unzip cli.zip && \
    rm -rf cli.zip && \
    mv CxConsolePlugin-${CX_CLI_VERSION} cxcli && \
    cd cxcli && \
    rm -rf Examples && \
    chmod +x runCxConsole.sh && \
    chmod +x runCxConsole.cmd

WORKDIR /opt/cxcli

CMD ["sh", "runCxConsole.sh", "Scan"]
