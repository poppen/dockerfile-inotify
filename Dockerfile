FROM alpine:latest

# hadolint ignore=DL3018
RUN apk --no-cache add \
        tini \
        inotify-tools
COPY entrypoint.sh /
RUN chmod 0755 /entrypoint.sh

ENTRYPOINT ["tini", "--", "/entrypoint.sh"]
