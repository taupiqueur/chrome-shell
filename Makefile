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
	gzip -9 -f -k extra/man/chrome-shell.1
	mandoc -I os= -T html -O style="man-style.css",man="https://man.archlinux.org/man/%N.%S" extra/man/chrome-shell.1 > extra/man/chrome-shell.1.html

test:
	crystal spec

release: clean build
	mkdir -p releases
	tar caf releases/$(name)-$(version)-$(target).tar.xz bin/chrome-shell extra/man/chrome-shell.1.gz extra/shell-completion/chrome-shell.bash extra/shell-completion/chrome-shell.fish docs samples

install: build
	install -d ~/.local/bin ~/.local/share/man/man1 ~/.local/share/bash-completion/completions ~/.local/share/fish/vendor_completions.d
	install -m 0755 bin/chrome-shell ~/.local/bin
	install -m 0644 extra/man/chrome-shell.1.gz ~/.local/share/man/man1
	install -m 0644 extra/shell-completion/chrome-shell.bash ~/.local/share/bash-completion/completions
	install -m 0644 extra/shell-completion/chrome-shell.fish ~/.local/share/fish/vendor_completions.d

uninstall:
	rm -f ~/.local/bin/chrome-shell ~/.local/share/man/man1/chrome-shell.1.gz ~/.local/share/bash-completion/completions/chrome-shell.bash ~/.local/share/fish/vendor_completions.d/chrome-shell.fish

clean:
	git clean -d -f -X
