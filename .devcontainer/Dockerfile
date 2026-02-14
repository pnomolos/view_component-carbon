FROM ghcr.io/rails/devcontainer/images/ruby:3.3.9

ARG TZ
ENV TZ="$TZ"

USER root
# Install dependencies for dartsass-rails, Playwright, and dev tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libsqlite3-dev \
    libyaml-dev \
    less \
    procps \
    sudo \
    fzf \
    zsh \
    man-db \
    unzip \
    gnupg2 \
    jq \
    nano \
    vim \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install git-delta for better diffs
ARG GIT_DELTA_VERSION=0.18.2
RUN ARCH=$(dpkg --print-architecture) && \
    wget "https://github.com/dandavison/delta/releases/download/${GIT_DELTA_VERSION}/git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb" && \
    dpkg -i "git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb" && \
    rm "git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb"

# Persist bash history
ARG USERNAME=vscode
RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
    && mkdir /commandhistory \
    && touch /commandhistory/.bash_history \
    && chown -R $USERNAME /commandhistory

USER vscode
ENV DEVCONTAINER=true

# Create config directory and set permissions
RUN mkdir -p /home/vscode/.claude && \
    chown -R vscode:vscode /home/vscode/.claude
