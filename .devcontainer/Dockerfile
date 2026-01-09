# Dockerfile for Ruby on Rails development with asdf

# Build arguments
ARG DEBIAN_FRONTEND=noninteractive
ARG VARIANT=bullseye
ARG RUBY_VERSION=3.3.6
ARG NODE_JS_VERSION=24.11.1
ARG WM_VERSION=v2022.01.03.00
ARG ASDF_VERSION=v0.16.7
ARG PORT=3000
ARG WORK_DIR=/app

# Base image
FROM mcr.microsoft.com/vscode/devcontainers/base:${VARIANT}

# Avoid stuck builds
ENV DEBIAN_FRONTEND=${DEBIAN_FRONTEND}

# Re-declare build arguments inside image
ARG RUBY_VERSION
ARG NODE_JS_VERSION
ARG WM_VERSION
ARG ASDF_VERSION
ARG WORK_DIR

# Default to workspace
WORKDIR ${WORK_DIR}

# Install system dependencies in one layer
RUN apt-get update && apt-get install -y \
  # Docker
  ca-certificates curl gnupg lsb-release \
  # Ruby/build essentials
  build-essential autoconf automake libtool pkg-config \
  libssl-dev zlib1g-dev libyaml-dev libreadline-dev libncurses5-dev \
  libffi-dev libgdbm-dev libdb-dev uuid-dev \
  # Database
  postgresql-client libpq-dev \
  # Image processing
  imagemagick libjpeg62-turbo-dev libpng-dev libtiff5-dev libwebp-dev libvips-dev \
  gifsicle \
  # Utilities + Zsh extras
  git curl wget unzip tzdata cron tmux vim zsh \
  openssh-client fonts-powerline \
  && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://get.docker.com | sh  

# Install asdf FIRST (before Oh My Zsh - fixes PATH issue)
RUN curl -fsSL https://github.com/asdf-vm/asdf/releases/download/${ASDF_VERSION}/asdf-${ASDF_VERSION}-linux-386.tar.gz | tar -xz -C /usr/local/bin

# NOW install Oh My Zsh (asdf is already available)
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.2.1/zsh-in-docker.sh)" \
  --oh-my-zsh-extra-plugins "git docker ruby bundler asdf rails" \
  --theme powerlevel10k

# Copy tool-versions before plugin installs (cache optimization)
COPY --chown=vscode:vscode .tool-versions* ./

ENV ASDF_DATA_DIR="/home/vscode/.asdf" \
  PATH="/usr/local/bin/asdf:${ASDF_DATA_DIR:-/home/vscode/.asdf}/shims:${ASDF_DATA_DIR:-/home/vscode/.asdf}/bin:$PATH" 

RUN mkdir -p /home/vscode/.asdf/completions/ /home/vscode/.asdf/shims /home/vscode/.asdf/bin

# Install Ruby and dependencies via asdf (now PATH is correct)
RUN asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git \
  && asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git \
  && asdf install ruby ${RUBY_VERSION} \
  && asdf install nodejs ${NODE_JS_VERSION} \
  && asdf set -u ruby ${RUBY_VERSION} \
  && asdf set -u nodejs ${NODE_JS_VERSION}

# Install and configure watchman
RUN curl -fsSL https://github.com/facebook/watchman/releases/download/${WM_VERSION}/watchman-${WM_VERSION}-linux.zip -o watchman.zip && \
  unzip watchman.zip && \
  mkdir -p /usr/local/{bin,lib} /usr/local/var/run/watchman && \
  cp watchman-*/bin/* /usr/local/bin && \
  cp watchman-*/lib/* /usr/local/lib && \
  chmod 755 /usr/local/bin/watchman && \
  chmod 2777 /usr/local/var/run/watchman && \
  touch /usr/local/var/run/watchman/.not-empty && \
  rm -rf watchman.zip watchman-*

# Fix permissions
RUN chown -R vscode:vscode /usr/local/bin/asdf /usr/local/bin/watchman /usr/local/var/run/watchman ${ASDF_DATA_DIR}

# Copy Gemfile and install bundler
COPY --chown=vscode:vscode Gemfile Gemfile.lock ./

# Use zsh login shell
SHELL ["/bin/zsh", "-lc"]

# Set zsh as default shell + initialize p10k
USER root

RUN chsh -s /bin/zsh vscode && \
  echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> /home/vscode/.zshrc

USER vscode

EXPOSE ${PORT}