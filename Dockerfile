# Inspired by https://github.com/mumoshu/dcind
FROM alpine:3.10
LABEL maintainer="Dmitry Matrosov <amidos@amidos.me>"

ENV DOCKER_VERSION=18.09.8 \
    DOCKER_COMPOSE_VERSION=1.24.1

# Install Docker and Docker Compose
RUN apk --no-cache add bash curl util-linux device-mapper py-pip python-dev libffi-dev openssl-dev gcc libc-dev make iptables && \
    curl https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz | tar zx && \
    mv /docker/* /bin/ && \
    chmod +x /bin/docker* && \
    pip install docker-compose==${DOCKER_COMPOSE_VERSION} && \
    rm -rf /root/.cache


RUN apk add libc6-compat && \
    curl -sSL -o /tmp/kubectl "https://dl.k8s.io/release/v1.26.0/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 /tmp/kubectl /usr/local/bin/kubectl && \
    rm /tmp/kubectl && \
    curl -sSL -o /tmp/minikube https://storage.googleapis.com/minikube/releases/v1.28.0/minikube-linux-amd64 && \
    install /tmp/minikube /usr/local/bin/minikube && \
    rm /tmp/minikube

# Include functions to start/stop docker daemon
COPY docker-lib.sh /docker-lib.sh
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
