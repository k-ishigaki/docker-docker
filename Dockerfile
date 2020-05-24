FROM alpine
LABEL maintainer="Kazuki Ishigaki<k-ishigaki@frontier.hokudai.ac.jp>"

RUN apk --no-cache add docker-cli docker-compose && \
    chmod u+s /usr/bin/docker
