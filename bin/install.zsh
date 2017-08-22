#!/usr/bin/env zsh

source ~/zsh/src/logger.zsh
source ~/zsh/src/functions/bin-exists

# ==============================================================================
# Install dependencies
# ==============================================================================

# Dependencies
# -----------------------------------------------------------------------------

function install_phantomjs() {
    npm install -g phantomjs-prebuilt
}

function install_npm() {
    npm install
}

function install_mix() {
    mix deps.get
}

# Execute
# -----------------------------------------------------------------------------

zlog-init "BlogApp"
zlog-h1   "Dependency Installer"
zlog-install "phantomjs" install_phantomjs
zlog-install "npm" install_npm
zlog-done
