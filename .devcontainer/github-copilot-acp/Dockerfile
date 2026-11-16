FROM mcr.microsoft.com/devcontainers/base:noble

# Docker's supported Ubuntu installation: configure its apt repository and
# install SBX. The docker-in-docker feature supplies the Docker Engine.
RUN curl -fsSL https://get.docker.com -o /tmp/install-docker.sh \
    && REPO_ONLY=1 sh /tmp/install-docker.sh \
    && apt-get update \
    && apt-get install -y --no-install-recommends docker-sbx cpu-checker \
    && groupadd --force kvm \
    && usermod -aG kvm vscode \
    && rm -f /tmp/install-docker.sh \
    && rm -rf /var/lib/apt/lists/*
