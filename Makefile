# ---------------------------------------------------------------------------------
# BLOG APP
# ---------------------------------------------------------------------------------

# -- Options

MIX_ENV=production
BIN_DIR=/usr/local/bin
ASSETS_DIR=assets
FONTS_DIR=$(ASSETS_DIR)/static/fonts

# -- Helpers

dev:
	@tmux \
         rename-window "terminal"                 \; \
         new-window -n "editor" -d "nvim"         \; \
         new-window -n "test" "cd test && nvim"   \; \
         split-window -h "make test"              \; \
		 split-window -v "make server"            \; \
         resize-pane -y 20                        \; \
         select-pane -L                           \; \
         select-window -t "editor"

repl:
	@iex -S mix

server:
	@iex -S mix phx.server

test:
	@mix test.watch

clean:
	@rm .DS_Store; rm **/*/.DS_Store

# -- Dependencies

update:
	@cd $(ASSETS_DIR) && npm update 
	@mix deps.update --all

install-fonts:
	@cd $(ASSETS_DIR) && npm install --save-dev font-awesome
	@mkdir -p $(FONTS_DIR)
	@cd $(FONTS_DIR) && ln -sf ../../node_modules/font-awesome/fonts/fontawesome-webfont.* .

install-npm:
	@npm install -g phantomjs-prebuilt
	@cd $(ASSETS_DIR) && npm install

install: install-npm install-fonts 
	@mix deps.get
	@mix ecto.setup
	@chmod +x ./bin/*

# -- Makefile 

.PHONY: install install-fonts install-fonts update test server repl dev
.DEFAULT_GOAL := dev
