# ---------------------------------------------------------------------------------
# BLOG APP
# ---------------------------------------------------------------------------------

# -- Options

MIX_ENV=production
BIN_DIR=/usr/local/bin
ASSETS_DIR=./assets
FONTS_DIR=$(ASSETS_DIR)/static/fonts
NPM_DIR=$(ASSETS_DIR)/node_modules/

# -- Helpers

dev:
	@tmux split-window -v 'make test' \; \
		  last-pane 				  \; \
		  resize-pane -y 15
	@make server
	
repl:
	@iex -S mix

server:
	@iex -S mix phx.server

test:
	@mix test.watch


# -- Dependencies

update:
	@cd $(ASSETS_DIR) && npm update 
	@mix deps.update --all

install-fonts:
	@cd $(ASSETS_DIR) && npm install --save-dev font-awesome
	@mkdir -p $(FONTS_DIR)
	@ln -sf $(NPM_DIR)/font-awesome/fonts/fontawesome-webfont.* $(FONTS_DIR)

install-npm:
	@npm install -g phantomjs-prebuilt
	@cd $(ASSETS_DIR) && npm install

install: install-npm install-fonts 
	@mix deps.get
	@mix ecto.setup


# -- Makefile 

.PHONY: install install-fonts install-fonts update test server repl dev
.DEFAULT_GOAL := dev
