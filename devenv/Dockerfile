# builder image
FROM debian:bullseye as builder

# install builder tools
RUN apt-get update && \
    apt-get upgrade -y
RUN apt-get install -y \
    curl \
    wget

ARG GO_VERSION=1.19.5

# Golang
RUN curl https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz | \
    tar -C /usr/local -xzf -
ENV GOROOT /usr/local/go
ENV GOPATH /root/go

# go tools
RUN $GOROOT/bin/go install github.com/rakyll/gotest@latest
RUN $GOROOT/bin/go install golang.org/x/tools/cmd/goimports@latest

# golangci-lint
ARG GOLANGCI_LINT_VERSION=1.50.1
RUN wget https://github.com/golangci/golangci-lint/releases/download/v${GOLANGCI_LINT_VERSION}/golangci-lint-${GOLANGCI_LINT_VERSION}-linux-amd64.tar.gz -O - | \
    tar -C /usr/local/bin/ -xzf - --strip-components=1 golangci-lint-${GOLANGCI_LINT_VERSION}-linux-amd64/golangci-lint

# shfmt
ARG SHFMT_VERSION=3.6.0
RUN wget https://github.com/mvdan/sh/releases/download/v${SHFMT_VERSION}/shfmt_v${SHFMT_VERSION}_linux_amd64 -O /usr/local/bin/shfmt

# direnv
ARG DIRENV_VERSION=2.32.1
RUN wget https://github.com/direnv/direnv/releases/download/v${DIRENV_VERSION}/direnv.linux-amd64 -O /usr/local/bin/direnv

# bat
ARG BAT_VERSION=0.22.1
RUN wget https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat-v${BAT_VERSION}-x86_64-unknown-linux-musl.tar.gz -O - | \
    tar -C /usr/local/bin/ -xzf - --strip-components=1 bat-v${BAT_VERSION}-x86_64-unknown-linux-musl/bat

# gojq
ARG GOJQ_VERSION=0.12.9
RUN wget https://github.com/itchyny/gojq/releases/download/v${GOJQ_VERSION}/gojq_v${GOJQ_VERSION}_linux_amd64.tar.gz -O - | \
    tar -C /usr/local/bin/ -xzf - --strip-components=1 gojq_v${GOJQ_VERSION}_linux_amd64/gojq

# lazydocker
ARG LAZYDOCKER_VERSION=0.18.1
RUN wget https://github.com/jesseduffield/lazydocker/releases/download/v${LAZYDOCKER_VERSION}/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz -O - | \
    tar -C /usr/local/bin/ -xzf - lazydocker

# glow
ARG GLOW_VERSION=1.4.1
RUN wget https://github.com/charmbracelet/glow/releases/download/v${GLOW_VERSION}/glow_${GLOW_VERSION}_linux_x86_64.tar.gz -O - | \
    tar -C /usr/local/bin/ -xzf - glow

# Make tools available system-wide
RUN mv /root/go/bin/* /usr/local/bin/ && \
    chmod +x /usr/local/bin/*

# devenv image
FROM debian:bullseye

RUN echo "Europe/Paris" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata && \
    echo "deb http://debian.mirrors.ovh.net/debian/ bullseye main contrib non-free" > /etc/apt/sources.list && \
    apt-get update && \
    apt-get upgrade -y

# dev packages
RUN apt-get install -y \
    ca-certificates \
    curl \
    docker.io \
    dos2unix \
    git \
    htop \
    locales \
    jq \
    man \
    make \
    moreutils \
    nginx \
    openssh-server \
    patch \
    pass \
    psmisc \
    python3-pip \
    python3-requests \
    rename \
    rsync \
    screen \
    sudo \
    telnet \
    tmux \
    unzip \
    vim \
    wget \
    xz-utils \
    zsh

# atuin
ARG ATUIN_VERSION=12.0.0
RUN wget https://github.com/ellie/atuin/releases/download/v${ATUIN_VERSION}/atuin_${ATUIN_VERSION}_amd64.deb -O /tmp/atuin.deb && \
    apt-get install /tmp/atuin.deb && \
    rm -f /tmp/atuin.deb

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# supervisor
RUN pip3 install supervisor

# pre-commit
RUN pip3 install pre-commit

# copy all binaries from builder
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /usr/local/go /usr/local/go
ENV GOROOT /usr/local/go

# create developer user
RUN echo "ALL ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    groupadd --gid 1000 developer && \
    useradd --uid 1000 -g developer --create-home --shell /bin/zsh developer && \
    usermod -aG sudo,docker developer && \
    passwd -d developer

# git config
ADD ./config/gitconfig /etc/gitconfig
RUN wget https://raw.githubusercontent.com/GitAlias/gitalias/main/gitalias.txt -O /etc/gitalias

# devenv landing page
ADD ./config/nginx/devenv /etc/nginx/sites-available/devenv
RUN ln -sf /etc/nginx/sites-available/devenv /etc/nginx/sites-enabled/devenv

# default env
ADD ./config/shell/ /tmp/shell/
RUN cp /tmp/shell/path_functions /etc/path_functions && \
    cat /tmp/shell/environment /tmp/shell/aliases >> /etc/bash.bashrc && \
    cat /tmp/shell/environment >> /etc/zsh/zshenv && \
    cat /tmp/shell/zprofile >> /etc/zsh/zprofile && \
    cat /tmp/shell/aliases >> /etc/zsh/zshrc && \
    rm -rf /tmp/shell
ENV GOPATH /home/user/go

# install oh-my-zsh
RUN ZSH=/usr/local/share/oh-my-zsh \
    CHSH=no \
    RUNZSH=no \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN install -m 644 -o developer -g developer /root/.zshrc /home/developer/.zshrc

# entrypoint
ADD ./entrypoint.sh /bin/entrypoint.sh
RUN chmod +x /bin/entrypoint.sh

ENTRYPOINT ["/bin/entrypoint.sh"]
