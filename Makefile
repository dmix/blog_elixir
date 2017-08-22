BIN_DIR=/usr/local/bin
MIX_ENV=production

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

install:
	@npm install -g phantomjs-prebuilt
	@npm install
	@mix deps.get
	@mix ecto.setup

.PHONY: install test server repl dev
.DEFAULT_GOAL := dev
