PREFIX ?= $(HOME)/.local

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
	tar caf releases/$(name)-$(version)-$(target).tar.xz bin/chrome-shell extra/man/chrome-shell.1.gz extra/shell-completion/chrome-shell.bash extra/shell-completion/chrome-shell.zsh extra/shell-completion/chrome-shell.fish extra/shell-completion/chrome-shell-completions.elv extra/shell-completion/chrome-shell-completions.nu docs samples

install: build
	install -d $(DESTDIR)$(PREFIX)/bin $(DESTDIR)$(PREFIX)/share/man/man1 $(DESTDIR)$(PREFIX)/share/bash-completion/completions $(DESTDIR)$(PREFIX)/share/zsh/site-functions $(DESTDIR)$(PREFIX)/share/fish/vendor_completions.d $(DESTDIR)$(PREFIX)/share/elvish/lib $(DESTDIR)$(PREFIX)/share/nushell/vendor/autoload
	install -m 0755 bin/chrome-shell $(DESTDIR)$(PREFIX)/bin
	install -m 0644 extra/man/chrome-shell.1.gz $(DESTDIR)$(PREFIX)/share/man/man1
	install -m 0644 extra/shell-completion/chrome-shell.bash $(DESTDIR)$(PREFIX)/share/bash-completion/completions
	install -m 0644 extra/shell-completion/chrome-shell.zsh $(DESTDIR)$(PREFIX)/share/zsh/site-functions/_chrome-shell
	install -m 0644 extra/shell-completion/chrome-shell.fish $(DESTDIR)$(PREFIX)/share/fish/vendor_completions.d
	install -m 0644 extra/shell-completion/chrome-shell-completions.elv $(DESTDIR)$(PREFIX)/share/elvish/lib
	install -m 0644 extra/shell-completion/chrome-shell-completions.nu $(DESTDIR)$(PREFIX)/share/nushell/vendor/autoload

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/chrome-shell $(DESTDIR)$(PREFIX)/share/man/man1/chrome-shell.1.gz $(DESTDIR)$(PREFIX)/share/bash-completion/completions/chrome-shell.bash $(DESTDIR)$(PREFIX)/share/zsh/site-functions/_chrome-shell $(DESTDIR)$(PREFIX)/share/fish/vendor_completions.d/chrome-shell.fish $(DESTDIR)$(PREFIX)/share/elvish/lib/chrome-shell-completions.elv $(DESTDIR)$(PREFIX)/share/nushell/vendor/autoload/chrome-shell-completions.nu

clean:
	git clean -d -f -X
