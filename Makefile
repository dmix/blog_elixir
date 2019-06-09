# ---------------------------------------------------------------------------------
# BLOG APP
# ---------------------------------------------------------------------------------

# -- Options

MIX_ENV=production
BIN_DIR=/usr/local/bin
ASSETS_DIR=assets
FONTS_DIR=$(ASSETS_DIR)/static/fonts
DB_PATH=/Users/dmix/.asdf/installs/postgres/10.8
IEX_PATH=/Users/dmix/.asdf/shims/iex
HOME=/Users/dmix

# -- Helpers

dev:
	@tmuxp load .tmuxp.yaml

repl:
	@iex -S mix

asdf:
	. $(HOME)/.asdf/asdf.sh
	. $(HOME)/.asdf/completions/asdf.bash
	asdf local erlang 21.0

db-src:
	export PATH="\$PATH:~/.asdf/installs/postgres/10.8/bin/"

db:
	@$(DB_PATH)/bin/pg_ctl -D $(DB_PATH)/data -l logfile start

db-stop:
	@$(DB_PATH)/bin/pg_ctl -D $(DB_PATH)/data stop

server:
	@ln -sf /Users/dmix/dev/_elixir/blog/priv/static/app.js /Users/dmix/dev/_elixir/blog/priv/static/js/app.js
	@rlwrap -a foo iex -S mix phx.server

test:
	@mix test.watch

clean:
	@rm .DS_Store; rm **/*/.DS_Store

# -- Dependencies

update:
	@cd $(ASSETS_DIR) && npm update
	@mix deps.update --all

install-fonts:
	@cd $(ASSETS_DIR) && yarn add -D font-awesome
	@mkdir -p $(FONTS_DIR)
	@cd $(FONTS_DIR) && ln -sf ../../node_modules/font-awesome/fonts/fontawesome-webfont.* .

install-npm:
	@npm install -g phantomjs-prebuilt
	@cd $(ASSETS_DIR) && npm install

install-asdf:
	@asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
	@asdf plugin-add postgres https://github.com/smashedtoatoms/asdf-postgres.git
	@asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
	@asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
	@bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
	@asdf install
	@asdf install postgres 10.8

install: install-npm install-fonts
	@mix deps.get
	@mix ecto.setup
	@chmod +x ./bin/*

# -- Makefile

.PHONY: install install-fonts install-fonts update test server repl dev
.DEFAULT_GOAL := dev
