FROM codercom/enterprise-base:latest

USER root

RUN apt-get update

# utils
RUN apt-get install -y --no-install-recommends \
    zip \
    unzip \
    net-tools \
    inetutils-ping \
    telnet \
    dnsutils \
    tree \
    jq \
    rsync \
    traceroute \
    ncdu \
    xz-utils

# dev tools
RUN apt-get install -y --no-install-recommends \
    build-essential \
    make \
    cmake \
    g++ \
    gcc \
    llvm \
    git

# dev libraries
RUN apt install -y --no-install-recommends \
    libssl-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libsqlite3-dev \
    libreadline-dev \
    libtk8.6 \
    libgdm-dev \
    libdb4o-cil-dev \
    libpcap-dev \
    libbz2-dev \
    libffi-dev \
    liblzma-dev \
    zlib1g-dev \
    tk-dev \
    libpq-dev

# Nodejs
RUN wget -O - https://nodejs.org/dist/v20.10.0/node-v20.10.0-linux-x64.tar.gz | tar xz
RUN mv node* /opt/node
RUN ln -s /opt/node/bin/* /usr/local/bin

# Docker client
RUN wget -O - https://download.docker.com/linux/static/stable/x86_64/docker-25.0.4.tgz | tar zx -C /usr/local/bin --strip-components=1 docker/docker

# Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/download/v2.24.7/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose
RUN mkdir -p /usr/local/lib/docker/cli-plugins && \
    ln -s /usr/local/bin/docker-compose /usr/local/lib/docker/cli-plugins


# kubectl
RUN wget -P /usr/local/bin https://storage.googleapis.com/kubernetes-release/release/v1.19.1/bin/linux/amd64/kubectl
RUN chmod +x /usr/local/bin/kubectl

# Go
COPY --from=golang:1.17 /usr/local/go /usr/local/go
ENV PATH=$PATH:/usr/local/go/bin

# Postgres Client
RUN apt-get install -y --no-install-recommends postgresql

# terraform
RUN wget https://releases.hashicorp.com/terraform/0.15.3/terraform_0.15.3_linux_amd64.zip && \
    unzip *.zip && \
    mv terraform /usr/local/bin && \
    rm *.zip

# k9s
RUN wget -O - https://github.com/derailed/k9s/releases/download/v0.29.1/k9s_Linux_amd64.tar.gz | tar zx && \
    mv k9s /usr/local/bin

# awscli
RUN wget https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip && \
    unzip *.zip && \
    ./aws/install && \
    rm *.zip && \
    rm -rf aws

USER coder
