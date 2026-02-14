FROM mcr.microsoft.com/devcontainers/ruby:3.3-bookworm

# Install dependencies for dartsass-rails and Playwright
RUN apt-get update && apt-get install -y \
    build-essential \
    libsqlite3-dev \
    libyaml-dev \
    && rm -rf /var/lib/apt/lists/*

# Install bundler
RUN gem install bundler
