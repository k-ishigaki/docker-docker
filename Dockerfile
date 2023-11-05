FROM alpine:3.18 as downloader

RUN apk --no-cache add curl~=8.4

ARG DOCKER_VERSION=24.0.7
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN curl https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_VERSION.tgz \
    | tar -xz -C /usr/bin --strip=1 docker/docker


WORKDIR /usr/local/lib/docker/cli-plugins

ARG DOCKER_COMPOSE_VERSION=2.22.0
RUN curl -L https://github.com/docker/compose/releases/download/v$DOCKER_COMPOSE_VERSION/docker-compose-linux-x86_64 -o docker-compose && \
    chmod +x docker-compose

ARG DOCKER_BUILDX_VERSION=0.11.2
RUN curl -L https://github.com/docker/buildx/releases/download/v0.11.2/buildx-v$DOCKER_BUILDX_VERSION.linux-amd64 -o docker-buildx && \
    chmod +x docker-buildx

FROM alpine:3.18

COPY --from=downloader /usr/bin/docker /usr/bin/docker
COPY --from=downloader /usr/local/lib/docker/cli-plugins/docker-compose /usr/local/lib/docker/cli-plugins/docker-compose
COPY --from=downloader /usr/local/lib/docker/cli-plugins/docker-buildx /usr/local/lib/docker/cli-plugins/docker-buildx

# Change the permissions so that any user can run
RUN chown root:root "$(which docker)" && \
    chmod u+s "$(which docker)"
