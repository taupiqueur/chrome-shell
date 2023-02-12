# General options
name = chrome-shell
version = $(shell git describe --tags --always)
target = $(shell llvm-config --host-target)

# Build options
static = no

ifeq ($(static),yes)
  flags += --static
endif

build:
	shards build --release $(flags)

test:
	crystal spec

release: clean build
	mkdir -p releases
	tar caf releases/$(name)-$(version)-$(target).tar.xz bin/chrome-shell

install: build
	install -d ~/.local/bin
	install bin/chrome-shell ~/.local/bin

uninstall:
	rm -f ~/.local/bin/chrome-shell

clean:
	git clean -d -f -X
