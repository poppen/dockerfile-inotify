FROM alpine:latest

COPY entrypoint.sh /
COPY inotify.d/ /inotify.d/

# hadolint ignore=DL3018
RUN apk --no-cache add \
        tini \
        inotify-tools && \
    chmod 0755 /entrypoint.sh /inotify.d/*

ENTRYPOINT ["tini", "--", "/entrypoint.sh"]
