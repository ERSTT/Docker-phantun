FROM alpine

ARG VERSION
ARG TARGETARCH

WORKDIR /app

RUN apk add --no-cache wget curl jq unzip && \
    if [ -z "$VERSION" ]; then \
        VERSION=$(curl -s https://api.github.com/repos/dndx/phantun/releases/latest | jq -r .tag_name); \
    fi && \
    if [ "$TARGETARCH" = "amd64" ]; then \
        ARCH_STR="x86_64-unknown-linux-musl"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        ARCH_STR="aarch64-unknown-linux-musl"; \
    else \
        echo "Unsupported architecture: $TARGETARCH" && exit 1; \
    fi && \
    FILE_NAME="phantun_${ARCH_STR}.zip" && \
    wget "https://github.com/dndx/phantun/releases/download/${VERSION}/${FILE_NAME}" -O /app/phantun.zip && \
    unzip /app/phantun.zip -d /app && \
    rm /app/phantun.zip && \
    chmod +x /app/phantun_client /app/phantun_server

ENV PATH="/app:${PATH}"

ENTRYPOINT ["phantun_client"]
