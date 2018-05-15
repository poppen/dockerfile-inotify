FROM alpine:latest

COPY entrypoint.sh /
COPY run.d/ /run.d/

# hadolint ignore=DL3018
RUN apk --no-cache add \
        tini \
        inotify-tools && \
    chmod 0755 /entrypoint.sh /run.d/*

ENTRYPOINT ["tini", "--", "/entrypoint.sh"]
