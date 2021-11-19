FROM alpine

ARG TOWER_CLI_VERSION="0.4"

# Install Tower CLI
RUN apk add --no-cache curl ca-certificates jq
RUN curl -L https://github.com/seqeralabs/tower-cli/releases/download/v${TOWER_CLI_VERSION}/tw-${TOWER_CLI_VERSION}-linux-x86_64 > tw
RUN chmod +x ./tw
RUN mv tw /usr/local/bin/

# Make action script available
ADD *.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
