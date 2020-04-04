FROM alpine as downloader

# install docker client
RUN apk --no-cache add curl

RUN curl -fsSL "https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz" \
	| tar -xz -C /usr/local/bin --strip=1 docker/docker && \
	chmod o+x /usr/local/bin/docker

FROM scratch
LABEL maintainer="Kazuki Ishigaki<k-ishigaki@frontier.hokudai.ac.jp>"

COPY --from=downloader /usr/local/bin/docker /usr/local/bin/docker

ENTRYPOINT [ "docker" ]
